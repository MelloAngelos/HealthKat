import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/generated/GeneratedWifiWidget19.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/generated/GeneratedTimeWidget19.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/generated/GeneratedCellularWidget19.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:flutterapp/healthkatapp/Screens/Profile/generated/GeneratedBatteryWidget19.dart';

/* Group Material / Status bar
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedMaterialStatusbarWidget19 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 89.29913330078125,
      height: 16.0,
      child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          overflow: Overflow.visible,
          children: [
            Positioned(
              left: null,
              top: null,
              right: 0.0,
              bottom: null,
              width: 36.0,
              height: 16.0,
              child: GeneratedTimeWidget19(),
            ),
            Positioned(
              left: null,
              top: null,
              right: 36.388916015625,
              bottom: null,
              width: 15.611083984375,
              height: 14.408866882324219,
              child: TransformHelper.translate(
                  x: 0.00, y: -0.20, z: 0, child: GeneratedBatteryWidget19()),
            ),
            Positioned(
              left: null,
              top: null,
              right: 55.27777099609375,
              bottom: null,
              width: 19.72222900390625,
              height: 14.408866882324219,
              child: TransformHelper.translate(
                  x: 0.00, y: -0.20, z: 0, child: GeneratedCellularWidget19()),
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
                final double width = constraints.maxWidth * 0.19084993903260047;

                final double height =
                    constraints.maxHeight * 0.8977832794189453;

                return Stack(children: [
                  TransformHelper.translate(
                      x: 0,
                      y: constraints.maxHeight * 0.03694581985473633,
                      z: 0,
                      child: Container(
                        width: width,
                        height: height,
                        child: GeneratedWifiWidget19(),
                      ))
                ]);
              }),
            )
          ]),
    );
  }
}
