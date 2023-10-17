import 'dart:io';
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/components/histogram_with_toggles.dart';
import 'package:leaf_spectrum/components/pie_chart.dart';
import 'package:leaf_spectrum/models/dominant_colors_data.dart';
import 'package:leaf_spectrum/home.dart';
import 'package:leaf_spectrum/models/server_connection.dart';
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


  Future<DominantColorsData> getDominantColors() async {
    return ServerConnection().getDominantColorsFromImage(imageFile);
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
                  child:
                    HistogramCardWithToggles(imageFile: imageFile,),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 380,
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
                      Text(
                        "Dominant Colors",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10,),
                      FutureBuilder<DominantColorsData>(
                        future:
                            getDominantColors(), // Assuming getDominantColors() returns a Future<List<Data>>
                        builder: (BuildContext context,
                            AsyncSnapshot<DominantColorsData> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return PieChartWidget(
                                dominantColorsData: snapshot.data!

                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                )
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
                  side: BorderSide(color: Color.fromRGBO(119, 182, 178, 0.4), width: 1)),
              foregroundColor: Color.fromRGBO(119, 182, 178, 1.0),
              backgroundColor: Color.fromRGBO(28, 47, 46, 1.0),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a remark.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  showWaitingPopup(
                    context,
                    'Processing Report',
                  );
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
