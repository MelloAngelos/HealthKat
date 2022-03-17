import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:flutterapp/healthkatapp/Screens/Discover/generated/GeneratedElevationWidget3.dart';
import 'package:flutterapp/healthkatapp/Screens/Discover/generated/GeneratedStatesWidget1.dart';
import 'package:flutterapp/healthkatapp/Screens/Discover/generated/GeneratedIconWidget10.dart';

/* Instance FAB / 3. Mini/ Resting
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFAB3MiniRestingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/Profile'),
      child: Container(
        width: 38.293304443359375,
        height: 40.0,
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
                width: 40.0,
                height: 40.0,
                child: TransformHelper.translate(
                    x: -0.15,
                    y: 0.00,
                    z: 0,
                    child: GeneratedElevationWidget3()),
              ),
              Positioned(
                left: null,
                top: null,
                right: null,
                bottom: null,
                width: 40.0,
                height: 40.0,
                child: TransformHelper.translate(
                    x: -0.15, y: 0.00, z: 0, child: GeneratedStatesWidget1()),
              ),
              Positioned(
                left: null,
                top: null,
                right: null,
                bottom: null,
                width: 24.0,
                height: 24.0,
                child: TransformHelper.translate(
                    x: -0.15, y: 0.00, z: 0, child: GeneratedIconWidget10()),
              )
            ]),
      ),
    );
  }
}
