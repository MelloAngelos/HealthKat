import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedTextWidget3.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratediconWidget3.dart';

/* Instance Button
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedButtonWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.0,
      height: 36.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          width: 1.0,
          color: Color.fromARGB(30, 0, 0, 0),
        ),
      ),
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 8.0,
              top: null,
              right: null,
              bottom: null,
              width: 24.0,
              height: 24.0,
              child: GeneratediconWidget3(),
            ),
            Positioned(
              left: 8.0,
              top: 6.0,
              right: null,
              bottom: null,
              width: 74.0,
              height: 24.0,
              child: GeneratedTextWidget3(),
            )
          ]),
    );
  }
}
