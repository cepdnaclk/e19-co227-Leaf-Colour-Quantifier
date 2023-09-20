import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:leaf_spectrum/analysis.dart';
import 'package:leaf_spectrum/processed_image.dart';

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
