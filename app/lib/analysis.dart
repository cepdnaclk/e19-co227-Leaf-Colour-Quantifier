import 'dart:collection';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/components/histogram.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:leaf_spectrum/models/histogram_data.dart';
import 'package:leaf_spectrum/home.dart';
import 'package:leaf_spectrum/models/server_connection.dart';
// import 'package:leaf_spectrum/sendDataToServer.dart';
import 'package:leaf_spectrum/showRemarkDialog.dart';
import 'package:leaf_spectrum/showWaitingPopup.dart';

class Analysis extends StatefulWidget {
  final File imageFile;
  final File originalImage;

  const Analysis(
      {super.key, required this.imageFile, required this.originalImage});

  @override
  State<Analysis> createState() =>
      _AnalysisState(imageFile: imageFile, originalImage: originalImage);
}

class _AnalysisState extends State<Analysis> {
  final File imageFile;
  final File originalImage;

  _AnalysisState({required this.imageFile, required this.originalImage});
  //List to contain the toggle button status of the three channels; RGB in order.
  List<bool> toggleValues = [true, true, true];

  Future<HistogramData> getHistogramMaps() async {
    final Uint8List imageData = await widget.imageFile.readAsBytesSync();
    img.Image? image = img.decodeImage(imageData);

    // Split the image into channels
    List<int> channels = [];

    channels = (await image?.getBytes(order: img.ChannelOrder.rgb))!;

    Map<int, int> redData = {};
    Map<int, int> blueData = {};
    Map<int, int> greenData = {};

    //initializing the map
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

      //Eliminating Black Pixels
      if (red == 0 && green == 0 && blue == 0) continue;

      //Adding data to Map
      redData[red] = (redData[red] ?? 0) + 1;
      greenData[green] = (greenData[green] ?? 0) + 1;
      blueData[blue] = (blueData[blue] ?? 0) + 1;

      //Calculating the maximum values
      max = redData[red]! > max ? redData[red]! : max;
      max = greenData[green]! > max ? greenData[green]! : max;
      max = blueData[blue]! > max ? blueData[blue]! : max;
    }

    //sorting the Map according to its key
    redData = SplayTreeMap<int, int>.from(redData);
    greenData = SplayTreeMap<int, int>.from(greenData);
    blueData = SplayTreeMap<int, int>.from(blueData);

    //return HistogramData object
    return HistogramData([
      redData,
      greenData,
      blueData,
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
                Row(
                  children: [
                    const Icon(
                      Icons.bar_chart_outlined,
                      size: 32.0,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    const Text(
                      "Analysis",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 32.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 450,
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color:
                          const Color.fromRGBO(64, 72, 80, 0.4196078431372549)),
                  alignment: Alignment.center,
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      Expanded(
                        //aspectRatio: 0.9,
                        child: FutureBuilder<HistogramData>(
                          future: getHistogramMaps(),
                          builder: (BuildContext context,
                              AsyncSnapshot<HistogramData> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Histogram(
                                histogramData: snapshot.data!,
                                showRed: toggleValues[0],
                                showGreen: toggleValues[1],
                                showBlue: toggleValues[2],
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Showing Channels",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ToggleButtons(
                        isSelected: toggleValues,
                        onPressed: (int index) {
                          setState(() {
                            toggleValues[index] = !toggleValues[index];
                          });
                        },
                        borderRadius: BorderRadius.circular(30.0),
                        constraints:
                            BoxConstraints.expand(width: 80, height: 35),
                        color: Color.fromRGBO(255, 255, 255, 0.4),
                        disabledBorderColor: Colors.white24,
                        children: [
                          Text(
                            "Red",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            "Green",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          Text(
                            "Blue",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                // Center(
                //   child: ElevatedButton.icon(
                //       style: ElevatedButton.styleFrom(
                //           backgroundColor:
                //               const Color.fromARGB(255, 33, 145, 126),
                //           shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(40)),
                //           foregroundColor: Colors.black),
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => Home(),
                //           ),
                //         );
                //       },
                //       label: const Text('Analyse another leaf'),
                //       icon: const Icon(Icons.restart_alt_sharp)),
                // ),
              ]),
        ),
      ),
      floatingActionButton: Wrap(
        direction: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              // heroTag: "ProcessedImage: Improve Selection",
              shape: const StadiumBorder(
                  side: BorderSide(color: Colors.white60, width: 2)),
              foregroundColor: Colors.white60,
              backgroundColor: Colors.transparent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => Annotator(
                //       imageFile: originalImage,
                //     ),
                //   ),
                // );
              },
              label: Text(
                'Analyse another leaf',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  letterSpacing: 0.2,
                ),
              ),
              icon: Icon(Icons.restart_alt_sharp),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: FloatingActionButton.extended(
              heroTag: "ProcessedImage: Go to Analysis",
              onPressed: () async {
                final remark = await showRemarkDialog(context);

                if (remark!.isEmpty) {
                  // Show a watning Message
                  // show dialog
                  // showDialog(
                  //   context: context,
                  //   builder: (BuildContext context) {
                  //     return AlertDialog(
                  //       title: Text('Warning'),
                  //       content: Text('Please enter remarks.'),
                  //       actions: [
                  //         TextButton(
                  //           onPressed: () {
                  //             Navigator.of(context).pop();
                  //           },
                  //           child: Text('OK'),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                  // Snack bar

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a remark.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  showWaitingPopup(context);
                  ServerConnection server = new ServerConnection();

                  server.sendDataToServer(
                      imageFile, originalImage, remark, context);
                }
              },
              icon: Icon(
                Icons.bar_chart_outlined,
                size: 20.0,
              ),
              label: Text(
                "Report",
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
