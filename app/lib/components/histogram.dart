import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Histogram extends StatelessWidget {
  const Histogram({super.key});

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w200,
      fontSize: 12,
      color: Color.fromRGBO(200, 200, 200, 0.8),
    );

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
    interval: 2000,
    reservedSize: 24,
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
    reservedSize: 16,

  );

  LineChartBarData lineData({required List<FlSpot> spots, required Color color}) => LineChartBarData(
    spots: spots,
    color: color,
    isCurved: true,
    dotData: const FlDotData(
      show: false,
    )
  );

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(
        backgroundColor: Colors.transparent,
        clipData: const FlClipData.none(),
        titlesData: FlTitlesData(
          show: true,

          topTitles: const AxisTitles(
            axisNameWidget:Text("Histogram",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            axisNameSize: 20.0
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


        minX: 0,
        maxX: 255,
        minY: 0,
        maxY: 10000,
        gridData: const FlGridData(
          show: true,
        ),
      borderData: FlBorderData(
        show: false,
      ),
        lineBarsData: [

          lineData(
            spots: [
              const FlSpot(0, 3000),
              const FlSpot(10, 5000),
              const FlSpot(25, 10000),
              const FlSpot(255, 2000)
            ],
            color: Colors.redAccent,
          ),
          lineData(
            spots: [
              const FlSpot(20, 2000),
              const FlSpot(40, 3000),
            ],
            color: Colors.greenAccent,
          ),

          lineData(
            spots: [
              const FlSpot(50, 2000),
              const FlSpot(80, 3000),
            ],
            color: Colors.blueAccent,
          )
        ],
      ),
    );
  }
}

