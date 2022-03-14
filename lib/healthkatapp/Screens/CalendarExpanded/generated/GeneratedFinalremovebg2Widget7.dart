import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

/* Rectangle final-removebg 2
    Autogenerated by FlutLab FTF Generator
  */
class GeneratedFinalremovebg2Widget7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TransformHelper.rotate(
        a: 1.00,
        b: 0.00,
        c: -0.00,
        d: 1.00,
        child: Container(
          width: 53.0,
          height: 62.0,
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Image.asset(
              "assets/images/logo.png",
              color: null,
              fit: BoxFit.cover,
              width: 53.0,
              height: 62.0,
              colorBlendMode: BlendMode.dstATop,
            ),
          ),
        ));
  }
}
