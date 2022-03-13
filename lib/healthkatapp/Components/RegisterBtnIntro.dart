import 'package:flutter/material.dart';

class RegisterBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "REGISTER",
              maxLines: 1,
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Mulish',
                fontWeight: FontWeight.w700,
                color: Colors.green[600],
              ),
            ),
          ],
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, '/Register'),
      shape: const StadiumBorder(),
    );
  }
}
