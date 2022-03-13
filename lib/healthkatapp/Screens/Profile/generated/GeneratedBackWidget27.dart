import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/generated/GeneratedShapeWidget94.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Group Back
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedBackWidget27 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11.444280624389648,
      height: 31.99359893798828,
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
                double scaleX =
                    (constraints.maxWidth * percentWidth) / 11.444280624389648;

                double percentHeight = 1.0;
                double scaleY =
                    (constraints.maxHeight * percentHeight) / 31.99359893798828;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: 0,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedShapeWidget94())
                ]);
              }),
            )
          ]),
    );
  }
}
