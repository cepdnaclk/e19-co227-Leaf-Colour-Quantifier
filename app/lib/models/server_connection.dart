import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:leaf_spectrum/models/dominant_colors_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:intl/intl.dart';

class ServerConnection {
  static final ServerConnection _singleton = ServerConnection._internal();
  static const String _baseUrl = 'http://192.168.8.104:5000';
  //static const String _baseUrl = 'http://agbc-fe.pdn.ac.lk:5000';

  factory ServerConnection() {
    return _singleton;
  }

  ServerConnection._internal();

  Future<File> sendImageAndGetProcessedImage(File imageFile) async {
    var url = Uri.parse('$_baseUrl/image/segmentaion');
    var request = http.MultipartRequest('POST', url);
    var file = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(file);
    var response = await request.send();
    var processedImage = await http.Response.fromStream(response);

    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var processedImageFilePath = '$tempPath/processed_image.jpg';

    // Delete the old file if it exists
    var oldFile = File(processedImageFilePath);
    if (await oldFile.exists()) {
      await oldFile.delete();
    }

    // Create and return the new file
    var processedImageFile = await File(processedImageFilePath)
        .writeAsBytes(processedImage.bodyBytes);
    return processedImageFile;
  }

  Future<DominantColorsData> getDominantColorsFromImage(File imageFile) async {
    var url = Uri.parse('$_baseUrl/analysis/dominant');
    var request = http.MultipartRequest('POST', url);

    var image = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(image);

    var response = await request.send();
    var responseString = await response.stream.bytesToString();

    // Handle the response
    if (response.statusCode == 200) {
      return DominantColorsData(responseString);
    } else {
      throw Exception(
          'Failed to get dominant color information. Status code: ${response
              .statusCode}');
    }
  }
  Future<File> sendImageAndMaskAndGetProcessedImage(
      File imageFile, Uint8List maskBytes) async {
    var url = Uri.parse('$_baseUrl/image/segmentaion/mask');
    var request = http.MultipartRequest('POST', url);

    var image = await http.MultipartFile.fromPath('image', imageFile.path);
    request.files.add(image);

    var mask =
        http.MultipartFile.fromBytes('mask', maskBytes, filename: 'mask.png');
    request.files.add(mask);

    var response = await request.send();
    var processedImage = await http.Response.fromStream(response);

    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var processedImageFilePath = '$tempPath/processed_image.jpg';

    // Delete the old file if it exists
    var oldFile = File(processedImageFilePath);
    if (await oldFile.exists()) {
      await oldFile.delete();
    }

    // Create and return the new file
    var processedImageFile = await File(processedImageFilePath)
        .writeAsBytes(processedImage.bodyBytes);

    return processedImageFile;
  }

  Future<void> sendDataToServer(File processedImage, File imageFile,
      String text, BuildContext context) async {
    Dio dio = Dio();

    Map<String, dynamic> queryParameters = {
      'remaks': text,
    };
    FormData formData = FormData.fromMap({
      'originalImage': await MultipartFile.fromFile(imageFile.path,
          contentType: MediaType('image', 'jpeg')),
      'segmentationImage': await MultipartFile.fromFile(processedImage.path,
          contentType: MediaType('image', 'jpeg')),
    });

    Response response;
    String appDocPath;
    String filePath;

    try {
      response = await dio.post(
        "$_baseUrl/report/image",
        queryParameters: queryParameters,
        data: formData,
        options: Options(responseType: ResponseType.bytes),
        // onReceiveProgress: (received, total) {
        //   if (total != -1) {
        //     double progress = (received / total * 100);
        //     print('Download progress: $progress%');
        //     // Update the progress indicator here
        //   }
        // },
      );
      print(response.statusCode);

      appDocPath = await _localPath();

      // Generate a unique file name for the PDF file
      // String fileName = "LeafSpectrum-" +
      //     text +
      //     '-' +
      //     DateTime.now().millisecondsSinceEpoch.toString() +
      //     '.pdf';
      String fileName = "LeafSpectrum-" +
          text +
          '-' +
          DateFormat('yyyy-MM-dd-HH-mm-ss').format(DateTime.now()) +
          '.pdf';

      // Save the received PDF response to the storage
      filePath = '$appDocPath/$fileName';
      await File(filePath).writeAsBytes(response.data);
    } catch (e) {
      print('Error: $e');
      // Handle the error here
      return;
    }

    // Close the waiting popup
    Navigator.of(context).pop();
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Download completed'),
    //   ),
    // );

    // Navigator.of(context).pop();
    // NotificationService().showNotification();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color.fromARGB(255, 33, 145, 126),
        title: Text('The Report Is Ready'),
        content: Text('The Report has been downloaded successfully.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await OpenFile.open(filePath);
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Colors.black), // Set the text color here
            ),
            child: Text('Open'),
          ),
        ],
      ),
    );
    // await OpenFile.open(filePath);

    // Show a completion message to the user
    // OpenFile.open(filePath);
    // Open the PDF file using flutter_pdfview
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => PDFView(
    //       filePath: filePath,
    //     ),
    //   ),
    // );
  }

  Future<String> _localPath() async {
    final String externalDocumentPath = await getExternalDocumentPath();
    return externalDocumentPath;
  }

  Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    Directory directory;
    if (Platform.isAndroid) {
      directory = Directory("/storage/emulated/0/Download");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    await Directory(exPath).create(recursive: true);
    return exPath;
  }
}
