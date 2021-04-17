import 'package:clima/constants/style_contants.dart';
import 'package:clima/screens/weather_display.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CityScreen extends StatefulWidget {
  final String cityName;

  CityScreen({this.cityName});

  @override
  _CityScreenState createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    //_textEditingController.text = widget.cityName;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff448aff),
      appBar: AppBar(
        title: Text('City'),
        elevation: 0.0,
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: TextField(
          controller: _textEditingController,
          style: kLabelTextStyle.copyWith(
            fontSize: 20.0,
          ),
          decoration: InputDecoration(
            labelText: 'City Name',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
            helperText: 'Current city: ${widget.cityName}',
            helperStyle: kLabelTextStyle,
            prefixIcon: Icon(
              FontAwesomeIcons.city,
              color: Colors.white,
            ),
            suffixIcon: FlatButton(
                onPressed: () {
                  String cityInput = _textEditingController.text;
                  Navigator.pop(
                      context,
                      cityInput != null && cityInput.isNotEmpty
                          ? cityInput
                          : widget.cityName);
                },
                child: Icon(
                  FontAwesomeIcons.checkCircle,
                  color: Colors.white,
                )),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
