import 'package:flutter/material.dart';

class ClimaContainer extends StatelessWidget {
  const ClimaContainer({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
      padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.white, width: 0.5),
        color: Color(0xff448aff),
      ),
      child: child,
    );
  }
}
