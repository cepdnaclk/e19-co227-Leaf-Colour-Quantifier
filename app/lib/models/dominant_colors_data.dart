import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DominantColorsData {
  //list of data of each dominant color
  late List<_Data> data;

  DominantColorsData(String jsonString) {
    //Input: jsonString Response from the server
    final jsonData = json.decode(jsonString);
    final dominantList = jsonData['dominant'];

    //Convert each dominantList item to a _Data item
    data = dominantList.map<_Data>((item) {
      final colorValues = item['colour'];
      final color = Color.fromRGBO(
        colorValues[0].toInt(),
        colorValues[1].toInt(),
        colorValues[2].toInt(),
        1,
      );

      //Generate name in the format of "RGB(10,102,232)"
      final name = 'RGB(${color.red}, ${color.green}, ${color.blue})';

      //Get the percentage value of the dominant color
      final percent = double.parse(item['precentage'].toStringAsFixed(2));

      //return a _Data object
      return _Data(name: name, percent: percent, color: color);

    }).toList();
  }

  //Generate Pie Chart Section Data from the data list.
  List<PieChartSectionData> getSections() => data
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final double fontSize = 16;
        final double radius = 80;
        final value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: '${data.percent}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xffffffff),
          ),
        );

        return MapEntry(index, value);
      })
      .values
      .toList();
}


//Private class for the data format of each dominant color
class _Data {
  final String name;

  final double percent;

  final Color color;

  _Data({required this.name, required this.percent, required this.color});
}
