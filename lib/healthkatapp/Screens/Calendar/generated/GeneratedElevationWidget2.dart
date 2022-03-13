import 'package:flutter/material.dart';

/* Rectangle ☁️ Elevation
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedElevationWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/GeneratedCalendarExpandedWidget'),
      child: Container(
        width: 102.0,
        height: 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(51, 0, 0, 0),
              offset: Offset(0.0, 2.0),
              blurRadius: 4.0,
            ),
            BoxShadow(
              color: Color.fromARGB(30, 0, 0, 0),
              offset: Offset(0.0, 1.0),
              blurRadius: 10.0,
            ),
            BoxShadow(
              color: Color.fromARGB(35, 0, 0, 0),
              offset: Offset(0.0, 4.0),
              blurRadius: 5.0,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.0),
          child: Container(
            color: Color.fromARGB(255, 16, 245, 39),
          ),
        ),
      ),
    );
  }
}
