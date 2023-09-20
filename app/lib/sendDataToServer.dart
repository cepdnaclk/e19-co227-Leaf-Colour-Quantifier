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

Future<Void?> sendDataToServer(File processedImage, File imageFile, String text,
    String url, BuildContext context) async {
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
}
