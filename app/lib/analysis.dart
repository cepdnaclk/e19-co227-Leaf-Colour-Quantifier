import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/components/histogram.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class Analysis extends StatelessWidget {
  final File imageFile;
  const Analysis({super.key, required this.imageFile});


  Future<List<int>> getImageChannels() async {
    final Uint8List imageData = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageData);


    // Split the image into channels
    List<int> channels =[];

    channels = (await image?.getBytes(order: img.ChannelOrder.rgb))!;

    Map<int, int> redData = {};
    Map<int, int> blueData = {};
    Map<int, int> greenData = {};
    for (int i = 0; i < channels.length; i += 4) {
      int red = channels[i];
      int green = channels[i + 1];
      int blue = channels[i + 2];

      redData[red] = (redData[red] ?? 0) + 1;
      greenData[green] = (greenData[green] ?? 0) + 1;
      blueData[blue] = (blueData[blue] ?? 0) + 1;
    }


    List<Map<int, int>> histogramData = [redData, blueData, greenData];
    print(histogramData);
    return channels;



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: SafeArea(
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text(
                "Analysis",

                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 32.0,
                ),
              ),
              const SizedBox(height: 20,),
              AspectRatio(
                aspectRatio: 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromRGBO(
                          64, 72, 80, 0.4196078431372549)
                  ),
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: const Histogram(),
                ),
              ),
              const SizedBox(height: 40,),
              Center(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 145, 126),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        foregroundColor: Colors.black),
                    onPressed: () {},
                    label: const Text('Analyse another leaf'),
                    icon: const Icon(
                        Icons.restart_alt_sharp
                    )
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }



}
