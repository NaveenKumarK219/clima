import 'package:clima/models/weather_info.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ClimaChart extends StatelessWidget {
  final List<charts.Series<WeatherInfo, DateTime>> weatherDataList;
  final bool animate;

  ClimaChart({this.weatherDataList, this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      weatherDataList,
      animate: animate,
      defaultRenderer: charts.LineRendererConfig(
        includePoints: true,
      ),
    );
  }
}
