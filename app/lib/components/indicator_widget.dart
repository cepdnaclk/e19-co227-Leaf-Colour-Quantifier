import 'package:flutter/material.dart';
import 'package:leaf_spectrum/models/dominant_colors_data.dart';

class IndicatorsWidget extends StatelessWidget {
  //Indicator Widget for Displaying the Legend of the Pie Chart
  final DominantColorsData dominantColorsData;
  IndicatorsWidget({required this.dominantColorsData});
  @override
  Widget build(BuildContext context) => Wrap(
    direction: Axis.horizontal,
    children: dominantColorsData.data
        .map(
          (data) => Container(
          child: buildIndicator(
            color: data.color,
            text: data.name,
          )),
    )
        .toList(),
  );

  Widget buildIndicator({
    //Create a Row element with a circle of the color given and the rgb code as its text
    required Color color,
    required String text,
    double size = 6,
    Color textColor = Colors.white60,
  }) =>
      Row(

        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        ],
      );
}