import 'package:clima/constants/style_contants.dart';
import 'package:flutter/material.dart';

class ClimaFitText extends StatelessWidget {
  final String text;

  const ClimaFitText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Text(
        '$text',
        style: kLabelTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
