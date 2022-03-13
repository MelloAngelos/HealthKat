import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedBoundsWidget3.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedShapeWidget7.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Group battery
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedBatteryWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16.0,
      height: 15.763545989990234,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              width: null,
              height: null,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double percentWidth = 1.0;
                double scaleX = (constraints.maxWidth * percentWidth) / 16.0;

                double percentHeight = 1.0;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    15.763545989990234;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: 0,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedBoundsWidget3())
                ]);
              }),
            ),
            Positioned(
              left: null,
              top: null,
              right: 4.0,
              bottom: null,
              width: 9.0,
              height: 14.0,
              child: TransformHelper.translate(
                  x: 0.00, y: 0.18, z: 0, child: GeneratedShapeWidget7()),
            )
          ]),
    );
  }
}
