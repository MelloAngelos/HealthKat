import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedMaterialStatusbarWidget1.dart';
import 'package:flutterapp/healthkatapp/Screens/Calendar/generated/GeneratedStatusbarbgWidget1.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Group status bar
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedStatusbarWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360.0,
      height: 23.645320892333984,
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
                double scaleX = (constraints.maxWidth * percentWidth) / 360.0;

                double percentHeight = 1.0;
                double scaleY = (constraints.maxHeight * percentHeight) /
                    23.645320892333984;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: 0,
                      translateY: 0,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedStatusbarbgWidget1())
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
                final double width = constraints.maxWidth * 0.26395170423719616;

                final double height = constraints.maxHeight * 0.679166614906657;

                return Stack(children: [
                  TransformHelper.translate(
                      x: constraints.maxWidth * 0.7138260735405816,
                      y: constraints.maxHeight * 0.16666667338874586,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedMaterialStatusbarWidget1(),
                      ))
                ]);
              }),
            )
          ]),
    );
  }
}
