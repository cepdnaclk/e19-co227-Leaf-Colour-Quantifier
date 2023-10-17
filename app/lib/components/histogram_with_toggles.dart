import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/models/histogram_data.dart';
import 'dart:collection';

import 'histogram_chart.dart';

class HistogramCardWithToggles extends StatefulWidget {
  final File imageFile;
  const HistogramCardWithToggles({required this.imageFile, super.key});

  @override
  State<HistogramCardWithToggles> createState() => _HistogramCardWithTogglesState();
}

class _HistogramCardWithTogglesState extends State<HistogramCardWithToggles> {

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
    return Column(
      children: [
        Expanded(
          //aspectRatio: -1.9,
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
                  key: ValueKey("Histogram"),
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
          height: 9,
        ),
        Text(
          "Showing Channels",
          style: TextStyle(
            color: Color.fromRGBO(254, 255, 255, 0.5),
            fontSize: 11,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        ToggleButtons(
          isSelected: toggleValues,
          onPressed: (int index) {
            setState(() {
              toggleValues[index] = !toggleValues[index];
            });
          },
          borderRadius: BorderRadius.circular(29.0),
          constraints:
          BoxConstraints.expand(width: 79, height: 35),
          color: Color.fromRGBO(254, 255, 255, 0.4),
          disabledBorderColor: Colors.white24,
          children: [
            Text(
              "Red",
              style: TextStyle(fontSize: 11.0),
            ),
            Text(
              "Green",
              style: TextStyle(fontSize: 11.0),
            ),
            Text(
              "Blue",
              style: TextStyle(fontSize: 11.0),
            ),
          ],
        )
      ],
    );
  }
}
