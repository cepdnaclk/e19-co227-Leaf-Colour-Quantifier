import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:leaf_spectrum/analysis.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

import 'package:leaf_spectrum/home.dart';

// Future<File> moveAssetToFile(String assetPath) async {
//   Directory tempDir = await getTemporaryDirectory();
//   String tempPath = tempDir.path;
//   String fileName = assetPath.split('/').last;
//   String filePath = '$tempPath/$fileName';
//
//   ByteData byteData = await rootBundle.load(assetPath);
//   List<int> bytes = byteData.buffer.asUint8List();
//
//   File file = File(filePath);
//   await file.writeAsBytes(bytes);
//
//   return file;
// }
// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding
//   File file = await moveAssetToFile('assets/images/test.jpeg');
//   Analysis analysis = Analysis(imageFile: file);
//
//   // print(await analysis.getHistogramMaps());
//   runApp(MaterialApp(
//   home: analysis,
//   ));
//
// }


void main() {
  runApp(
    MaterialApp(
      home: Home(),
    )
  );
}
