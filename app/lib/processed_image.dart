
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:leaf_spectrum/analysis.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ProcessedImagePage extends StatelessWidget {
  final File processedImage;

  const ProcessedImagePage({Key? key, required this.processedImage})
      : super(key: key);

  Future<String> sendImageToServer(
      File processedImage, String url, BuildContext context) async {
    // Create a multipart request
    // print(imageFile.p);
    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Attach the image file to the request
    var file = await http.MultipartFile.fromPath('file', processedImage.path);
    request.files.add(file);

    // Send the request and wait for the response
    var response = await request.send();

    // Read the response and convert it to a file
    var report = await http.Response.fromStream(response);

    // var processedImageFile = File('./assets');
    // var tempDir = await getTemporaryDirectory();
    // var tempPath = tempDir.path;
    // var reportFile = File('$tempPath/processed_image.pdf');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String pdfPath = '${appDocDir.path}/analyzed_leaf.pdf';
    File reportFile = File(pdfPath);
    await reportFile.writeAsBytes(report.bodyBytes);

    // await pdfFile.writeAsBytes(response.bodyBytes);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFView(
          filePath: pdfPath,
        ),
      ),
    );
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
                // sendImageToServer(processedImage,
                //     'http://192.168.8.177:5000/report/image', context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Analysis(imageFile: processedImage,),
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
