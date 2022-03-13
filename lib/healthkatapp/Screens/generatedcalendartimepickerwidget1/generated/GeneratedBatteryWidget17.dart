import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedShapeWidget84.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedBoundsWidget51.dart';

/* Group battery
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedBatteryWidget17 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15.611083984375,
      height: 14.408866882324219,
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
                double percentWidth = 0.9679714745945608;
                double scaleX =
                    (constraints.maxWidth * percentWidth) / 15.111083984375;

                double percentHeight = 0.9969231160241004;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    14.364532470703125;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: constraints.maxWidth * 0.03202852540543922,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedBoundsWidget51())
                ]);
              }),
            ),
            Positioned(
              left: null,
              top: null,
              right: 6.611083984375,
              bottom: null,
              width: 9.0,
              height: 14.0,
              child: TransformHelper.translate(
                  x: 0.00, y: 0.20, z: 0, child: GeneratedShapeWidget84()),
            )
          ]),
    );
  }
}
