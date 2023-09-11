import 'package:fl_chart/fl_chart.dart';
class HistogramData {
  late Map<int, int> redData;
  late Map<int, int> greenData;
  late Map<int, int> blueData;
  int max;

  HistogramData(List<Map<int, int>> histogramMaps, this.max) {
    this.redData = histogramMaps[0];
    this.greenData = histogramMaps[1];
    this.blueData = histogramMaps[2];
  }

  List<FlSpot> _getSpots (Map<int, int> mapData) {
    return mapData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
  }

  List<FlSpot> getRedSpots() => _getSpots(redData);

  List<FlSpot> getGreenSpots() => _getSpots(greenData);

  List<FlSpot> getBlueSpots() => _getSpots(blueData);

  int getMaximum() => max;

}