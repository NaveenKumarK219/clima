import 'package:clima/screens/weather_display.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clima',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Color(0xff448aff),
          brightness: Brightness.dark,
          centerTitle: true,
        ),
        scaffoldBackgroundColor: Color(0xff448aff),
        fontFamily: 'Philosopher',
      ),
      home: WeatherDisplay(),
    );
  }
}
