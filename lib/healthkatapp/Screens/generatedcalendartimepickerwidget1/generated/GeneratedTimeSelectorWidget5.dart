import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedInputfieldWidget5.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedLabelWidget23.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Instance Time Selector
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedTimeSelectorWidget5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Container(
        width: 96.0,
        height: 103.0,
        child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            overflow: Overflow.visible,
            children: [
              Positioned(
                left: 0.0,
                top: 0.0,
                right: null,
                bottom: null,
                width: 96.0,
                height: 80.0,
                child: GeneratedInputfieldWidget5(),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                width: null,
                height: null,
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final double width =
                      constraints.maxWidth * 0.4583333333333333;

                  final double height =
                      constraints.maxHeight * 0.20388349514563106;

                  return Stack(children: [
                    TransformHelper.translate(
                        x: 0,
                        y: constraints.maxHeight * 0.8446601941747572,
                        z: 0,
                        child: Container(
                          width: width,
                          height: height,
                          child: GeneratedLabelWidget23(),
                        ))
                  ]);
                }),
              )
            ]),
      ),
    );
  }
}
