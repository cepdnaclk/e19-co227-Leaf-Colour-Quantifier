import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leaf_spectrum/image_page.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imageFile;
  String? dropDownValue;
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
              width: 240,
            ),

            // const PlantSelector(),
            // const SizedBox(height: 2),
            Text(

              "Quantifying Colours of Plant Leaves",
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                color: Colors.white60,
              ),

              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white, width: 1)),
                    onPressed: () => getImage(source: ImageSource.gallery),
                    label: const Text('Import',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        )),
                    icon: const Icon(
                      Icons.image,
                      size: 18,
                    )),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 33, 145, 126),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.black),
                    onPressed: () => getImage(source: ImageSource.camera),
                    label: const Text('Take Photo'),
                    icon: const Icon(Icons.camera)),
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
