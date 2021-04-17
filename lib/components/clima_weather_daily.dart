import 'package:clima/components/clima_fit_text.dart';
import 'package:clima/models/weather_info.dart';
import 'package:flutter/material.dart';

class ClimaWeatherDaily extends StatelessWidget {
  final WeatherInfo weatherInfo;

  ClimaWeatherDaily({this.weatherInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: ClimaFitText(
            text: '${weatherInfo.maxTemp}°C',
          ),
        ),
        Flexible(
          child: ClimaFitText(
            text: '${weatherInfo.minTemp}°C',
          ),
        ),
        Flexible(
          child: Image.network(
              'http://openweathermap.org/img/wn/${weatherInfo.icon ?? '02d'}@2x.png'),
        ),
        Flexible(
          child: ClimaFitText(
            text: '${weatherInfo.day}',
          ),
        ),
      ],
    );
  }
}
