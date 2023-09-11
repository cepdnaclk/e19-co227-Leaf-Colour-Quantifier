import 'package:flutter/material.dart';
import 'dart:io';
import 'package:leaf_spectrum/analysis.dart';

class ProcessedImagePage extends StatelessWidget {
  final File processedImage;

  const ProcessedImagePage({Key? key, required this.processedImage})
      : super(key: key);

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Analysis(imageFile: processedImage)                ,
                  ),
                );
              },
              label: const Text('Analyse The Leaf'),
              icon: const Icon(Icons.bar_chart_outlined)),
        ],
      ),
    );
  }
}
