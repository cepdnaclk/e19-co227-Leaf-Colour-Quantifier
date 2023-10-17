import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:leaf_spectrum/models/dominant_colors_data.dart';

class PieChartWidget extends StatefulWidget {
  final DominantColorsData dominantColorsData;
  PieChartWidget({Key? key, required this.dominantColorsData}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  // late int touchedIndex;

  @override
  Widget build(BuildContext context) =>
        Expanded(
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: widget.dominantColorsData.getSections(),
            ),
          ),
        );
}