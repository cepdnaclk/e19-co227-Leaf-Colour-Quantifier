import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:leaf_spectrum/models/histogram_data.dart';

class Histogram extends StatelessWidget {
  final HistogramData histogramData;

  //Boolean Variables to conditionally render red, blue, green channels separately
  final bool showRed;
  final bool showGreen;
  final bool showBlue;


  //Constructor
  Histogram({super.key, required this.histogramData, required this.showRed, required this.showGreen, required this.showBlue});


  List<LineChartBarData> getLineData() {
    //Returns a List of LineChartBarData for the Histogram rendering
    List<LineChartBarData> lineDataList = [];

    //If Red is Selected, add the red channel graph
    if (showRed) {
      lineDataList.add(lineData(
          spots: histogramData.getRedSpots(), color: Colors.redAccent),);
    }

    //If Green is Selected, add the green channel graph
    if (showGreen) {
      lineDataList.add(lineData(spots: histogramData.getGreenSpots(), color: Colors.greenAccent));
    }

    //If Blue is selected, add the blue channel graph
    if (showBlue) {
      lineDataList.add(
          lineData(spots: histogramData.getBlueSpots(), color:Colors.blueAccent )
      );
    }
    return lineDataList;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {

    //Generate the Y axis labels for the histogram
    const style = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 12,
      color: Color.fromRGBO(200, 200, 200, 0.8),
    );

    //Instead of showing 1000 -> 1K
    String text;
    text = '${value~/ 1000}k';

    if (value.toInt() == 0) {
      return const Text("");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 2.0),
      child: Text(text, style: style, textAlign: TextAlign.left),
    );
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: histogramData.getMaximum() / 10,
    reservedSize: 24, // Reserve 24 Pixels for the Y labels
  );

  Widget rightTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 12,
      color: Color.fromRGBO(200, 200, 200, 0.8),
    );

    return
      Text(value.toInt().toString(), style: style, textAlign: TextAlign.left);
  }
  SideTitles bottomTitles() => SideTitles(
    getTitlesWidget: rightTitleWidgets,
    showTitles: true,
    interval: 64,
    reservedSize: 16, //Reserve 16 pixels for the X Labels

  );

  LineChartBarData lineData({required List<FlSpot> spots, required Color color}) => LineChartBarData(
      spots: spots,
      color: color,
      isCurved: false,
      dotData: const FlDotData(
        show: false,
      )
  );

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
      backgroundColor: Colors.transparent,
      clipData: const FlClipData.none(),
      lineTouchData: LineTouchData(
        enabled: false,
      ),

      titlesData: FlTitlesData(
        show: true,

        topTitles: const AxisTitles(
            axisNameWidget:Text("Histogram",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            axisNameSize: 30.0
        ),
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles(),

        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),


      minX: 0, //Starting Range of Frequencies
      maxX: 255, //End Range of Frequencies
      minY: 0,
      maxY: histogramData.getMaximum().toDouble(),
      gridData: const FlGridData(
        show: true,
      ),
      borderData: FlBorderData(
        show: false,
      ),
      lineBarsData: getLineData(),
    ),
    );
  }
}

