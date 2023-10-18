import 'package:flutter/material.dart';
import 'dart:io';
import 'package:leaf_spectrum/models/server_connection.dart';
import 'package:leaf_spectrum/screens/processed_image.dart';
import 'package:leaf_spectrum/components/showWaitingPopup.dart';

class ImagePage extends StatelessWidget {
  final File imageFile;

  const ImagePage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(
              Icons.image,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Captured Image',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          print(imageFile.path);
          showWaitingPopup(
            context,
            'Processing Image',
          );
          ServerConnection server = ServerConnection();

          var processedImage =
              await server.sendImageAndGetProcessedImage(imageFile);
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProcessedImagePage(
                processedImage: processedImage,
                originalImage: imageFile,
                key: UniqueKey(),
              ),
            ),
          );
        },
        icon: Icon(
          Icons.navigate_next,
          size: 20.0,
        ),
        label: Text(
          "Process",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
            letterSpacing: 0.2,
          ),
        ),
        foregroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
