import 'dart:convert';
import 'dart:ui';

import 'package:clima/components/clima_chart.dart';
import 'package:clima/components/clima_fit_text.dart';
import 'package:clima/constants/ApiConstants.dart';
import 'package:clima/constants/style_contants.dart';
import 'package:clima/models/weather_info.dart';
import 'package:clima/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:clima/components/clima_container.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class WeatherDisplay extends StatefulWidget {
  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  dynamic weatherData;
  String cityName;
  String country;
  String weatherIcon;
  String description;
  String temperature;
  String tempFeelsLike;
  String minTemp;
  String maxTemp;
  String pressure;
  String humidity;
  String wind;
  String dateTime;
  String sunRise;
  String sunSet;
  String visibility;
  String clouds;
  dynamic rain;
  dynamic snow;
  List<WeatherInfo> weatherInfoList;
  String message;

  @override
  void initState() {
    super.initState();
    weatherInfoList = [];
    getWeatherData();
  }

  void getWeatherData() async {
    http.Response response = await http.get(
        'http://api.openweathermap.org/data/2.5/weather?q=${cityName ?? 'Hyderabad'}&appid=$kApiKey&units=metric');
    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
        cityName = weatherData['name'];
        country = weatherData['sys']['country'];
        weatherIcon = weatherData['weather'][0]['icon'];
        temperature = weatherData['main']['temp'].toStringAsFixed(0);
        tempFeelsLike = weatherData['main']['feels_like'].toStringAsFixed(0);
        minTemp = weatherData['main']['temp_min'].toStringAsFixed(0);
        maxTemp = weatherData['main']['temp_max'].toStringAsFixed(0);
        pressure = weatherData['main']['pressure'].toString();
        humidity = weatherData['main']['humidity'].toString();
        wind = weatherData['wind']['speed'].toString();
        description = weatherData['weather'][0]['description'];
        visibility = weatherData['visibility'].toString();
        clouds = weatherData['clouds']['all'].toString();
        rain = weatherData['rain'];
        snow = weatherData['snow'];
        int timeZone = weatherData['timezone'];

        DateFormat dateFormat = DateFormat('hh:mm a');
        int epochTime = weatherData['sys']['sunrise'];
        sunRise = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
            (epochTime + timeZone) * 1000,
            isUtc: true));

        epochTime = weatherData['sys']['sunset'];
        sunSet = dateFormat.format(DateTime.fromMillisecondsSinceEpoch(
            (epochTime + timeZone) * 1000,
            isUtc: true));

        dateFormat = DateFormat('EEE, d MMM\nhh:mm a');
        DateTime dt = DateTime.fromMillisecondsSinceEpoch(
            (weatherData['dt'] + timeZone) * 1000,
            isUtc: true);

        dateTime = dateFormat.format(dt);
      });

      print(weatherData);

      getDailyWeatherData(
          weatherData['coord']['lat'], weatherData['coord']['lon']);
    } else if (response.statusCode == 404) {
      setState(() {
        weatherData = jsonDecode(response.body);
        message = weatherData['message'];
      });
      print(message);
    }
  }

  void getDailyWeatherData(lat, lon) async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly&appid=$kApiKey&units=metric');

    if (response.statusCode == 200) {
      setState(() {
        weatherData = jsonDecode(response.body);
        List dailyList = weatherData['daily'];
        int timezoneOffset = weatherData['timezone_offset'];
        weatherInfoList = [];

        dailyList.forEach((element) {
          DateTime dt = DateTime.fromMillisecondsSinceEpoch(
              (element['dt'] + timezoneOffset) * 1000,
              isUtc: true);
          weatherInfoList.add(WeatherInfo(
            minTemp: element['temp']['min'].toInt(),
            maxTemp: element['temp']['max'].toInt(),
            dateTime: dt,
          ));
        });
      });
    }
    print(weatherInfoList.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima'),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return CityScreen(
                  cityName: cityName,
                );
              }));
              setState(() {
                if (result != null && result != cityName) {
                  cityName = result.toString();
                  message = null;
                  getWeatherData();
                }
              });
            },
            icon: Icon(FontAwesomeIcons.city),
          ),
          IconButton(
            onPressed: () {
              getWeatherData();
            },
            icon: Icon(
              FontAwesomeIcons.redo,
            ),
          ),
        ],
        actionsIconTheme: IconThemeData(size: 24.0),
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: ClimaContainer(
              child: message != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Text(
                            '${message.toUpperCase() + "\nPlease Try Again!"}',
                            style: kLabelTextStyle,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                fit: FlexFit.loose,
                                child: ClimaFitText(
                                  text: '$cityName\n$country',
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Image.network(
                                  'http://openweathermap.org/img/wn/${weatherIcon ?? '02d'}@2x.png',
                                ),
                              ),
                              Flexible(
                                child: ClimaFitText(
                                  text: '$description',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    '$dateTime',
                                    style: kDateStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      flex: 3,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          '${temperature ?? 0}',
                                          style: kLabelTextStyle.copyWith(
                                            fontSize: 70.0,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        '°C',
                                        style: kLabelTextStyle.copyWith(
                                          fontSize: 30.0,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: ClimaFitText(
                                  text: 'Feel : $tempFeelsLike°C',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: ClimaFitText(
                                      text: 'Min: $minTemp°C',
                                    ),
                                  ),
                                  Flexible(
                                    child: ClimaFitText(
                                      text: 'Max: $maxTemp°C',
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                  child: ClimaFitText(
                                text: 'Pressure : $pressure hPa',
                              )),
                              Flexible(
                                child: Text(
                                  'Humidity : $humidity %',
                                  style: kLabelTextStyle,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  'Wind : $wind m/s ',
                                  style: kLabelTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Expanded(
            flex: 1,
            child: ClimaContainer(
              child: ClimaChart(
                weatherDataList: [
                  charts.Series<WeatherInfo, DateTime>(
                    id: 'MaxTemp',
                    data: weatherInfoList,
                    domainFn: (WeatherInfo info, _) => info.dateTime,
                    measureFn: (WeatherInfo info, _) => info.maxTemp,
                    colorFn: (_, __) => charts.MaterialPalette.white,
                  ),
                  charts.Series<WeatherInfo, DateTime>(
                    id: 'MinTemp',
                    data: weatherInfoList,
                    domainFn: (WeatherInfo info, _) => info.dateTime,
                    measureFn: (WeatherInfo info, _) => info.minTemp,
                    colorFn: (_, __) => charts.MaterialPalette.white,
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ClimaContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: ClimaFitText(
                          text: 'Sunrise\n$sunRise',
                        )),
                        Flexible(
                            child: ClimaFitText(
                          text: 'Sunset\n$sunSet',
                        )),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                            child: ClimaFitText(
                          text: 'Visibility\n$visibility m',
                        )),
                        Flexible(
                            child: ClimaFitText(
                          text: 'Clouds\n$clouds %',
                        )),
                      ],
                    ),
                  ),
                  if (rain != null)
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                              child: ClimaFitText(
                            text: 'Rain',
                          )),
                          Flexible(
                              child: ClimaFitText(
                            text: 'Last 1 Hour\n${rain['1h']} mm',
                          )),
                          if (rain['3h'] != null)
                            Flexible(
                              child: ClimaFitText(
                                text: 'Last 3 Hours\n${rain['3h']} mm',
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (snow != null)
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: ClimaFitText(
                              text: 'Snow',
                            ),
                          ),
                          Flexible(
                            child: ClimaFitText(
                              text: 'Last 1 Hour\n${snow['1h']}',
                            ),
                          ),
                          if (snow['3h'] != null)
                            Flexible(
                              child: ClimaFitText(
                                text: 'Last 1 Hour\n${snow['3h']}',
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
