import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:leaf_spectrum/analysis.dart';
import 'package:leaf_spectrum/processed_image.dart';
import 'package:leaf_spectrum/sendImageToServer.dart';

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
              imageFile, 'http://192.168.8.177:5000/image/segmentaion');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessedImagePage(
                processedImage: processedImage,
                imageFile: imageFile,
              ),
            ),
          );
        },
        child: Icon(Icons.send),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
