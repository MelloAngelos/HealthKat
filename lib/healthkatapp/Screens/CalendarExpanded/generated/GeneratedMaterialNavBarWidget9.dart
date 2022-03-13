import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedRecentWidget19.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedHomeWidget19.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedOvalWidget12.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedTintOutlookGrayWidget9.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedListDividerWidget9.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedBackWidget20.dart';

/* Group Material / Nav Bar
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedMaterialNavBarWidget9 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.0,
      height: 50.27582931518555,
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
                final double width = constraints.maxWidth;

                final double height =
                    constraints.maxHeight * 0.8571428354641794;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: constraints.maxHeight * 0.1428571455669776,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedTintOutlookGrayWidget9(),
                      ))
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
                final double width = constraints.maxWidth;

                final double height =
                    constraints.maxHeight * 0.2857142911339552;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: 0,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedListDividerWidget9(),
                      ))
                ]);
              }),
            ),
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 16.0,
              height: 16.0,
              child: TransformHelper.translate(
                  x: 101.00, y: 4.04, z: 0, child: GeneratedRecentWidget19()),
            ),
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 18.0,
              height: 18.0,
              child: TransformHelper.translate(
                  x: 1.00, y: 4.04, z: 0, child: GeneratedHomeWidget19()),
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
                double percentWidth = 0.03888890883501838;
                double scaleX =
                    (constraints.maxWidth * percentWidth) / 13.22222900390625;

                double percentHeight = 0.24999998103115692;
                double scaleY =
                    (constraints.maxHeight * percentHeight) / 12.56895637512207;

                return Stack(children: [
                  TransformHelper.translateAndScale(
                      translateX: constraints.maxWidth * 0.4833333183737362,
                      translateY: constraints.maxHeight * 0.44642853484580264,
                      translateZ: 0,
                      scaleX: scaleX,
                      scaleY: scaleY,
                      scaleZ: 1,
                      child: GeneratedOvalWidget12())
                ]);
              }),
            ),
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 15.0,
              height: 17.0,
              child: TransformHelper.translate(
                  x: -100.50, y: 3.54, z: 0, child: GeneratedBackWidget20()),
            )
          ]),
    );
  }
}
