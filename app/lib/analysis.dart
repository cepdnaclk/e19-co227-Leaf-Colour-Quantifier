import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/components/histogram.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:leaf_spectrum/models/histogram_data.dart';


class Analysis extends StatelessWidget {
  final File imageFile;

  const Analysis({super.key, required this.imageFile});


  Future<HistogramData> getHistogramMaps() async {
    final Uint8List imageData = await imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(imageData);


    // Split the image into channels
    List<int> channels =[];

    channels = (await image?.getBytes(order: img.ChannelOrder.rgb))!;

    Map<int, int> redData = {};
    Map<int, int> blueData = {};
    Map<int, int> greenData = {};

    for (int i = 0; i < 256; i++) {
      redData[i] = 0;
      greenData[i] = 0;
      blueData[i] = 0;
    }
    int max = 0;
    for (int i = 0; i < channels.length; i += 3) {
      int red = channels[i];
      int green = channels[i + 1];
      int blue = channels[i + 2];

      redData[red] = (redData[red] ?? 0) + 1;
      greenData[green] = (greenData[green] ?? 0) + 1;
      blueData[blue] = (blueData[blue] ?? 0) + 1;

      max = redData[red]! > max ? redData[red]! : max;
      max = greenData[green]! > max ? greenData[green]! : max;
      max = blueData[blue]! > max ? blueData[blue]! : max;
    }

    print(SplayTreeMap<int, int>.from(redData));

    return HistogramData([
      SplayTreeMap<int, int>.from(redData),
      SplayTreeMap<int, int>.from(greenData),
      SplayTreeMap<int, int>.from(blueData),
    ], max);


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
                  child: FutureBuilder<HistogramData>(
                    future: getHistogramMaps(),
                    builder: (BuildContext context, AsyncSnapshot<HistogramData> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Histogram(histogramData: snapshot.data!);
                      }
                    },
                  ),
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
