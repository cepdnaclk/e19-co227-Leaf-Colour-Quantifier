import 'package:flutter/material.dart';
import 'dart:io';

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
    );
  }
}
