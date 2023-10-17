import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:leaf_spectrum/processed_image.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:leaf_spectrum/showWaitingPopup.dart';

import 'models/server_connection.dart';

class Annotator extends StatefulWidget {
  final File imageFile;

  Annotator({Key? key, required this.imageFile}) : super(key: key);

  @override
  _AnnotatorState createState() => _AnnotatorState();
}

class _AnnotatorState extends State<Annotator> {
  Future<ui.Image>? imageFuture;
  GlobalKey _myCanvasKey = new GlobalKey();
  ImageEditor? editor;

  @override
  void initState() {
    super.initState();
    imageFuture = loadImageFromFile(widget.imageFile);
  }

  Future<ui.Image> loadImageFromFile(File file) async {
    final Uint8List bytes = await file.readAsBytes();
    final Completer<ui.Image> completer = Completer();
    final codec = await ui.instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    completer.complete(frameInfo.image);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: imageFuture,
      builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          ui.Image image = snapshot.data!;
          editor = ImageEditor(image: image);
          return buildAnnotator(context, image);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildImage() {
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
  }

  Widget buildAnnotator(BuildContext context, ui.Image image) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        titleSpacing: 0,
        title: Row(
          children: [
            Icon(
              Icons.brush_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Paint Over the Leaf',
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

                  ServerConnection server = ServerConnection();
                  showWaitingPopup(
                    context,
                    'Wait, The Image is Processing...',
                  );
                  var processedImage =
                      await server.sendImageAndMaskAndGetProcessedImage(
                          widget.imageFile, pngBytes);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessedImagePage(
                        processedImage: processedImage,
                        originalImage: widget.imageFile,
                        key: UniqueKey(),
                      ),
                    ),
                  );
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
