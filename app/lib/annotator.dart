import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Annotator extends StatefulWidget {
  final File imageFile;

  Annotator({Key? key, required this.imageFile}) : super(key: key);

  @override
  _AnnotatorState createState() => _AnnotatorState();
}

class _AnnotatorState extends State<Annotator> {
  late ui.Image image;
  bool isImageloaded = false;
  GlobalKey _myCanvasKey = new GlobalKey();
  ImageEditor? editor;

  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    final data = await widget.imageFile.readAsBytes();
    image = await loadImage(data);
    editor = ImageEditor(image: image);
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    if (this.isImageloaded) {
      return GestureDetector(
        onPanDown: (detailData) {
          editor!.update(detailData.localPosition);
          _myCanvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
        },
        onPanUpdate: (detailData) {
          editor!.update(detailData.localPosition);
          _myCanvasKey.currentContext?.findRenderObject()?.markNeedsPaint();
        },
        child: RepaintBoundary(
          key: _myCanvasKey,
          child: CustomPaint(
            painter: editor,
          ),
        ),
      );
    } else {
      return Center(child: Text('loading'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paint Over The Leaf'),
        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal, //use vertical to show on vertical axis
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    editor?.clear();
                    _myCanvasKey.currentContext
                        ?.findRenderObject()
                        ?.markNeedsPaint();
                  });
                },
                child: Icon(Icons.undo),
                backgroundColor: Colors.black45,
              )),
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () async {
                  RenderRepaintBoundary boundary = _myCanvasKey.currentContext!
                      .findRenderObject() as RenderRepaintBoundary;
                  ui.Image capture = await boundary.toImage(pixelRatio: 3.0);
                  ByteData? byteData = await capture.toByteData(
                      format: ui.ImageByteFormat.png); // Save as PNG
                  Uint8List pngBytes = byteData!.buffer.asUint8List();

                  final directory = await getApplicationDocumentsDirectory();
                  final pathOfTheFileToWrite = directory.path +
                      "/painted_image.png"; // Change the file extension to ".png"
                  File file = File(pathOfTheFileToWrite);
                  await file.writeAsBytes(pngBytes);
                  print("Image saved to Gallery");
                },
                backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                child: Icon(Icons.check),
              )),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Center(
          child: AspectRatio(
            aspectRatio: image.width / image.height,
            child: _buildImage(),
          ),
        ),
      ),
    );
  }
}

class ImageEditor extends CustomPainter {
  ImageEditor({
    required this.image,
  });
  ui.Image image;
  List<Offset>? points = [];

  //Change Painting Style here
  final Paint painter = new Paint()
    ..color = Color.fromRGBO(0, 0, 0, 1.0)
    ..blendMode = BlendMode.hue
    ..strokeWidth = 48.0
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;


  void update(Offset offset) {
    points?.add(offset);
  }

  void clear() {
    points?.clear();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromLTRB(0, 0, size.width, size.height),
        Paint());
    for (Offset offset in points!) {
      canvas.drawCircle(offset, 10, painter);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}