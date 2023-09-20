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
import 'package:leaf_spectrum/sendDataToServer.dart';

class ProcessedImagePage extends StatelessWidget {
  final File processedImage;
  final File imageFile;

  const ProcessedImagePage(
      {Key? key, required this.processedImage, required this.imageFile})
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
                sendDataToServer(processedImage, imageFile, "Remarkstest123",
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
