import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:leaf_spectrum/processed_image.dart';

class ImagePage extends StatelessWidget {
  final File imageFile;

  const ImagePage({Key? key, required this.imageFile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
        title: const Text('Captured Image'),
      ),
      body: Center(
        child: Container(
          width: 640,
          height: 480,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: DecorationImage(
              image: FileImage(imageFile),
              fit: BoxFit.cover,
            ),
            border: Border.all(width: 8, color: Colors.black),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(imageFile.path);
          var processedImage = await sendImageToServer(
              imageFile, 'http://192.168.0.101:5000/image/segmentaion');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProcessedImagePage(processedImage: processedImage),
            ),
          );
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<File> sendImageToServer(File imageFile, String url) async {
    // Create a multipart request
    // print(imageFile.p);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Attach the image file to the request
    var file = await http.MultipartFile.fromPath('file', imageFile.path);
    request.files.add(file);

    // Send the request and wait for the response
    var response = await request.send();

    // Read the response and convert it to a file
    var processedImage = await http.Response.fromStream(response);

    // var processedImageFile = File('./assets');
    var tempDir = await getTemporaryDirectory();
    var tempPath = tempDir.path;
    var processedImageFile = File('$tempPath/processed_image.jpg');
    await processedImageFile.writeAsBytes(processedImage.bodyBytes);

    return processedImageFile;
  }
}
