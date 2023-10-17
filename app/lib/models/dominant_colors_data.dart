import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DominantColorsData {
  //list of data of each dominant color
  late List<_Data> data;

  DominantColorsData(String jsonString) {
    final jsonData = json.decode(jsonString);
    final dominantList = jsonData['dominant'];

    data = dominantList.map<_Data>((item) {
      final colorValues = item['colour'];
      final color = Color.fromRGBO(
        colorValues[0].toInt(),
        colorValues[1].toInt(),
        colorValues[2].toInt(),
        1,
      );
      final name = 'RGB(${color.red}, ${color.green}, ${color.blue})';
      final percent = double.parse(item['precentage'].toStringAsFixed(2));



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


//Class for the data format of each dominant color
class _Data {
  final String name;

  final double percent;

  final Color color;

  _Data({required this.name, required this.percent, required this.color});
}
