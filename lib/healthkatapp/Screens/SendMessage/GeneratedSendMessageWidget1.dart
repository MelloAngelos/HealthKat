import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/SendMessage/generated/GeneratedToolsStatusBarDarkWidget6.dart';
import 'package:flutterapp/healthkatapp/Screens/SendMessage/generated/GeneratedTopBarWidget5.dart';
import 'package:flutterapp/healthkatapp/Screens/SendMessage/generated/GeneratedSearchWidget2.dart';
import 'package:flutterapp/healthkatapp/Screens/SendMessage/generated/GeneratedToolsNavBarWidget6.dart';
import 'package:flutterapp/healthkatapp/Screens/SendMessage/generated/GeneratedPeopleWidget1.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Frame Send Message
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedSendMessageWidget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/GeneratedHomePageContactListWidget'),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Container(
          width: 360.0,
          height: 800.0,
          child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              overflow: Overflow.visible,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  top: -1.0,
                  right: null,
                  bottom: null,
                  width: 375.0,
                  height: 88.0,
                  child: GeneratedTopBarWidget5(),
                ),
                Positioned(
                  left: 0.0,
                  top: 87.0,
                  right: null,
                  bottom: null,
                  width: 375.0,
                  height: 44.0,
                  child: GeneratedSearchWidget2(),
                ),
                Positioned(
                  left: 0.0,
                  top: 142.0,
                  right: null,
                  bottom: null,
                  width: 375.0,
                  height: 636.0,
                  child: GeneratedPeopleWidget1(),
                ),
                Positioned(
                  left: 0.0,
                  top: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  width: null,
                  height: null,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    final double width = constraints.maxWidth;

                    final double height =
                        constraints.maxHeight * 0.02955665111541748;

                    return Stack(children: [
                      TransformHelper.translate(
                          x: 0,
                          y: 0,
                          z: 0,
                          child: Container(
                            width: width,
                            height: height,
                            child: GeneratedToolsStatusBarDarkWidget6(),
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
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    final double width = constraints.maxWidth;

                    final double height =
                        constraints.maxHeight * 0.059113235473632814;

                    return Stack(children: [
                      TransformHelper.translate(
                          x: 0,
                          y: constraints.maxHeight * 0.9458128356933594,
                          z: 0,
                          child: Container(
                            width: width,
                            height: height,
                            child: GeneratedToolsNavBarWidget6(),
                          ))
                    ]);
                  }),
                )
              ]),
        ),
      ),
    ));
  }
}