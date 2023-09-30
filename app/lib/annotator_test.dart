import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async';
import 'dart:typed_data';

class Annotator extends StatefulWidget {
  Annotator({Key? key}) : super(key: key);
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
    final ByteData data = await rootBundle.load('assets/images/test.jpeg');
    image = await loadImage(Uint8List.view(data.buffer));
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
        child: CustomPaint(
          key: _myCanvasKey,
          painter: editor,
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

        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    editor!.clear();
                  });
                },
                child: Icon(Icons.undo),
                backgroundColor: Colors.black45,
              )), //button first

          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  // Send mask to the backend
                },
                backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                child: Icon(Icons.check),
              )), // button third

          // Add more buttons here
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
  final Paint painter = new Paint()
    ..color = Colors.blue[400]!
    ..blendMode = BlendMode.lighten
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
