import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

class RegisterBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/Homepage'),
      child: Container(
        width: 134.39999389648438,
        height: 59.113311767578125,
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
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  final double width = constraints.maxWidth;

                  final double height = constraints.maxHeight;

                  return Stack(children: [
                    TransformHelper.translate(
                        x: 0,
                        y: 0,
                        z: 0,
                        child: Container(
                          width: width,
                          height: height,
                          child: Container(
                            width: 134.39999389648438,
                            height: 59.113311767578125,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: 1.0,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
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
                  final double width =
                      constraints.maxWidth * 0.6611337280788299;

                  final double height =
                      constraints.maxHeight * 0.45124972573921346;

                  return Stack(children: [
                    TransformHelper.translate(
                        x: constraints.maxWidth * 0.1880342705151817,
                        y: constraints.maxHeight * 0.31666653760276714,
                        z: 0,
                        child: Container(
                            width: width,
                            height: height,
                            child:  Text(
                              '''Register''',
                              overflow: TextOverflow.visible,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 1.171875,
                                fontSize: 18.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 255, 255, 255),

                                /* letterSpacing: 0.0, */
                              ),
                            ),
                        ),
                    )
                  ]);
                }),
              )
            ]),
      ),
    );
  }
}
