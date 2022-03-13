import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/Discover/generated/GeneratedRectangleWidget24.dart';
import 'package:flutterapp/healthkatapp/Screens/Discover/generated/GeneratedIconWidget13.dart';

/* Group Tab 1
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedTab1Widget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/GeneratedHomePageContactListWidget'),
      child: Container(
        width: 79.99999237060547,
        height: 52.604652404785156,
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
                width: 79.99999237060547,
                height: 52.604652404785156,
                child: GeneratedRectangleWidget24(),
              ),
              Positioned(
                left: 28.5,
                top: 14.162793159484863,
                right: null,
                bottom: null,
                width: 24.0,
                height: 24.316490173339844,
                child: GeneratedIconWidget13(),
              )
            ]),
      ),
    );
  }
}
