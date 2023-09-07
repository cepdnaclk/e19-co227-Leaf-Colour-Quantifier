import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo-vertical.png',
              width: 280,

            ),


            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1)

                    ),

                    onPressed: () => getImage(source: ImageSource.camera),
                    label: const Text('Import',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      )
                    ),
                    icon: const Icon(
                        Icons.image,
                      size: 18,
                    )
                ),
                const SizedBox(width: 10),

                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.black),
                    onPressed: () => getImage(source: ImageSource.camera),
                    label: const Text('Take Photo'),
                    icon: const Icon(
                      Icons.camera
                    )
                  ),

              ],
            ),
          ],
        ),
      ),
    );
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70, //0 - 100
    );

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePage(imageFile: imageFile!),
        ),
      );
    }
  }
}

class ImagePage extends StatelessWidget {
  final File imageFile;

  const ImagePage({Key? key, required this.imageFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 33, 145, 126),
        title: const Text('Captured Image'),
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
    );
  }
}
