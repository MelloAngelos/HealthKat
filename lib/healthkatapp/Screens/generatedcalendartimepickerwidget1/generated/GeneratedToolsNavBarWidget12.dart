import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedMaterialNavBarWidget11.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedContentListDividerWidget11.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedRecentWidget22.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedHomeWidget22.dart';
import 'package:flutterapp/healthkatapp/Screens/generatedcalendartimepickerwidget1/generated/GeneratedBackWidget23.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Instance Tools / Nav Bar
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedToolsNavBarWidget12 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340.0,
      height: 43.09356689453125,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 16.0,
              height: 16.0,
              child: TransformHelper.translate(
                  x: 101.00, y: 0.45, z: 0, child: GeneratedRecentWidget22()),
            ),
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 16.0,
              height: 16.0,
              child: TransformHelper.translate(
                  x: 0.00, y: 0.45, z: 0, child: GeneratedHomeWidget22()),
            ),
            Positioned(
              left: null,
              top: null,
              right: null,
              bottom: null,
              width: 15.0,
              height: 17.0,
              child: TransformHelper.translate(
                  x: -100.50, y: -0.05, z: 0, child: GeneratedBackWidget23()),
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
                    constraints.maxHeight * 1.1666666961737566;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: constraints.maxHeight * -0.16666667404343916,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedMaterialNavBarWidget11(),
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
                    constraints.maxHeight * 0.010416667127714947;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: 0,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedContentListDividerWidget11(),
                      ))
                ]);
              }),
            )
          ]),
    );
  }
}
