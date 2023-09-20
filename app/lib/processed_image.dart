import 'dart:ffi';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:leaf_spectrum/analysis.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ProcessedImagePage extends StatelessWidget {
  final File processedImage;
  final File imageFile;

  const ProcessedImagePage(
      {Key? key, required this.processedImage, required this.imageFile})
      : super(key: key);

  Future<String> sendImageToServer(File processedImage, File imageFile,
      String text, String url, BuildContext context) async {
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

    // dio.options.queryParameters = {
    //   'remaks': text,
    // };
    // var multipartFile1 = await MultipartFile.fromFile(imageFile as String,
    //     filename: 'imageFile');
    // var multipartFile2 = await MultipartFile.fromFile(processedImage as String,
    //     filename: 'processedImage');

    // var formData = FormData.fromMap({
    //   'originalImage': multipartFile1,
    //   'segmentationImage': multipartFile2,
    // });

    // Create a multipart request
    // print(imageFile.p);
    // var request = http.MultipartRequest('POST', Uri.parse(url));
    // request.files.add(
    //     await http.MultipartFile.fromPath('originalImage', imageFile.path));
    // request.files.add(await http.MultipartFile.fromPath(
    //     'segmentationImage', processedImage.path));
    // Attach the image file to the request
    // var file = await http.MultipartFile.fromPath('file', processedImage.path);
    // request.files.add(file);
    // request.fields['remaks'] = text;

    // Send the request and wait for the response
    // var response = await request.send();

    Response response = await dio.post(
      url,
      queryParameters: queryParameters,
      data: formData,
      options: Options(responseType: ResponseType.bytes),
    );
    // var response = await dio.post(url, data: formData);
    print(response.statusCode);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Generate a unique file name for the PDF file
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.pdf';

    // Save the received PDF response to the temporary directory
    String filePath = '$tempPath/$fileName';
    await File(filePath).writeAsBytes(response.data);

    // Open the PDF file using flutter_pdfview
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: filePath,
        ),
      ),
    );

    // Read the response and convert it to a file
    // var report = await http.Response.fromStream(response);

    // var processedImageFile = File('./assets');
    // var tempDir = await getTemporaryDirectory();
    // var tempPath = tempDir.path;
    // var reportFile = File('$tempPath/processed_image.pdf');
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String pdfPath = '${appDocDir.path}/report.pdf';
    // File reportFile = File(pdfPath);
    // // await reportFile.writeAsBytes(report.bodyBytes);
    // print("Hey");
    // print(reportFile);
    // // await pdfFile.writeAsBytes(response.bodyBytes);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Expanded(
    //       child: PDFView(
    //         filePath: pdfPath,
    //       ),
    //     ),
    //   ),
    // );
    // return reportFile;
    // print("Success");
    return 'ss';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
        title: Text('Processed Image'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.file(processedImage),
          ),
          SizedBox(
            height: 35,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  foregroundColor: Colors.black),
              onPressed: () {
                sendImageToServer(processedImage, imageFile, "Remarkstest123",
                    'http://192.168.1.51:5000/report/image', context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Analysis(),
                //   ),
                // );
              },
              label: const Text('Report'),
              icon: const Icon(Icons.bar_chart_outlined)),
        ],
      ),
    );
  }
}
