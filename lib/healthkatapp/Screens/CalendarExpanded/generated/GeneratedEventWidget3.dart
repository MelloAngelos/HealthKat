import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/Generated10AMWidget1.dart';
import 'package:flutterapp/healthkatapp/Screens/CalendarExpanded/generated/GeneratedGerasimosPolitisWidget1.dart';

/* Frame Event
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedEventWidget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Container(
        width: 275.0,
        height: 51.0,
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
                width: 50.0,
                height: 21.0,
                child: Generated10AMWidget1(),
              ),
              Positioned(
                left: 0.0,
                top: 27.0,
                right: null,
                bottom: null,
                width: 418.62744140625,
                height: 26.0,
                child: GeneratedGerasimosPolitisWidget1(),
              )
            ]),
      ),
    );
  }
}
