import 'package:fl_chart/fl_chart.dart';
class HistogramData {
  // late Map<int, int> redData;
  // late Map<int, int> greenData;
  // late Map<int, int> blueData;

  //maximum intensity value to scale the histogram
  int max;

  //FLspot Lists for separate channels for plotting the historgram
  late List<FlSpot> _redSpots;
  late List<FlSpot> _blueSpots;
  late List<FlSpot> _greenSpots;

  HistogramData(List<Map<int, int>> histogramMaps, this.max) {
    //Map Data
    // this.redData = histogramMaps[0];
    // this.greenData = histogramMaps[1];
    // this.blueData = histogramMaps[2];

    //flSpots Data
    this._redSpots = _getSpots(histogramMaps[0]);
    this._greenSpots = _getSpots(histogramMaps[1]);
    this._blueSpots = _getSpots(histogramMaps[2]);
  }

  List<FlSpot> _getSpots (Map<int, int> mapData) {
    return mapData.entries.map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble())).toList();
  }

  List<FlSpot> getRedSpots() => _redSpots;

  List<FlSpot> getGreenSpots() => _greenSpots;

  List<FlSpot> getBlueSpots() => _blueSpots;

  int getMaximum() => max;

}