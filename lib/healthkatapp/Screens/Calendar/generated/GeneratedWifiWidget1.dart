import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedBoundsWidget5.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedShapeWidget9.dart';

/* Group wifi
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedWifiWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18.045244216918945,
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
                double percentWidth = 0.886660208510708;
                double scaleX = (constraints.maxWidth * percentWidth) / 16.0;

                double percentHeight = 1.0;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    15.763545989990234;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: constraints.maxWidth * 0.05666942010304511,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedBoundsWidget5())
                ]);
              }),
            ),
            Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              width: null,
              height: null,
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                double percentWidth = 1.0000007398869346;
                double scaleX =
                    (constraints.maxWidth * percentWidth) / 18.045257568359375;

                double percentHeight = 0.8750001512467939;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    13.793105125427246;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: 0,
                      translateY: constraints.maxHeight * 0.062499984875320616,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedShapeWidget9())
                ]);
              }),
            )
          ]),
    );
  }
}
