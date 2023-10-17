import 'package:flutter/material.dart';
import 'package:leaf_spectrum/models/dominant_colors_data.dart';

class IndicatorsWidget extends StatelessWidget {

  final DominantColorsData dominantColorsData;
  IndicatorsWidget({required this.dominantColorsData});
  @override
  Widget build(BuildContext context) => Wrap(
    direction: Axis.horizontal,
    children: dominantColorsData.data
        .map(
          (data) => Container(
          padding: EdgeInsets.symmetric(horizontal: 0),
          child: buildIndicator(
            color: data.color,
            text: data.name,
            // isSquare: true,
          )),
    )
        .toList(),
  );

  Widget buildIndicator({
    required Color color,
    required String text,
    bool isSquare = false,
    double size = 6,
    Color textColor = Colors.white60,
  }) =>
      Row(

        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
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