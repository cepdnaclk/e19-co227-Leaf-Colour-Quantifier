import 'package:fl_chart/fl_chart.dart';
class HistogramData {
  late Map<int, int> redData;
  late Map<int, int> greenData;
  late Map<int, int> blueData;
  int max;

  late List<FlSpot> redSpots;
  late List<FlSpot> blueSpots;
  late List<FlSpot> greenSpots;

  HistogramData(List<Map<int, int>> histogramMaps, this.max) {
    //Map Data
    this.redData = histogramMaps[0];
    this.greenData = histogramMaps[1];
    this.blueData = histogramMaps[2];

    //flSpots Data
    this.redSpots = _getSpots(histogramMaps[0]);
    this.greenSpots = _getSpots(histogramMaps[1]);
    this.blueSpots = _getSpots(histogramMaps[2]);
  }

  List<FlSpot> _getSpots (Map<int, int> mapData) {
    return mapData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
  }

  List<FlSpot> getRedSpots() => redSpots;

  List<FlSpot> getGreenSpots() => greenSpots;

  List<FlSpot> getBlueSpots() => blueSpots;

  int getMaximum() => max;

}