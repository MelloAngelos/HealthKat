import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Components/LoginBtnIntro.dart';
import 'package:flutterapp/healthkatapp/Components/RegisterBtnIntro.dart';
import 'package:flutterapp/helpers/transform/transform.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.greenAccent[400],
      child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: MediaQuery.of(context).size.height * 0.11,
                top: MediaQuery.of(context).size.height * 0.12,
                child: TransformHelper.rotate(
                    a: 1.00,
                    b: 0.00,
                    c: -0.00,
                    d: 1.00,
                    child: Container(
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.cover,
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                    ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.35,
                child: Text(
                  '''Health Kat''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.18,
                    fontFamily: 'WinterSong',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    /* letterSpacing: 0.0, */
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.65,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.07,
                child: LoginBtn(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.77,
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.height * 0.07,
                child: RegisterBtn(),
              )
            ]),
        );
  }
}
