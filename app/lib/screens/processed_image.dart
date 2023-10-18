import 'package:flutter/material.dart';
import 'dart:io';
import 'package:leaf_spectrum/screens/annotator.dart';
import 'package:leaf_spectrum/screens/analysis.dart';

class ProcessedImagePage extends StatelessWidget {
  final File processedImage;
  final File originalImage;

  const ProcessedImagePage(
      {Key? key, required this.processedImage, required this.originalImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    //clear cache before building the widget
    //selectively clearing cache, so performance won't be affected.
    imageCache.evict(FileImage(File(processedImage.path)));
    imageCache.evict(FileImage(File(originalImage.path)));

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
              'Processed Image',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.file(processedImage),
          ),
        ],
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              heroTag: "ProcessedImage: Improve Selection",
              shape: const StadiumBorder(
                  side: BorderSide(color: Colors.white60, width: 2)),
              foregroundColor: Colors.white60,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Annotator(
                      imageFile: originalImage,
                    ),
                  ),
                );
              },
              label: Text(
                'Improve Selection',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  letterSpacing: 0.2,
                ),
              ),
              icon: Icon(Icons.format_paint),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              heroTag: "ProcessedImage: Go to Analysis",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Analysis(
                        imageFile: processedImage,
                        originalImage: originalImage),
                  ),
                );
              },
              icon: Icon(
                Icons.bar_chart_outlined,
                size: 20.0,
              ),
              label: Text(
                "Analyze",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  letterSpacing: 0.2,
                ),
              ),
              foregroundColor: Colors.black,
              backgroundColor: const Color.fromARGB(255, 33, 145, 126),
            ),
          ),
        ],
      ),
    );
  }
}
