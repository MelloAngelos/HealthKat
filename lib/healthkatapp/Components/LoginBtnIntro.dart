import 'package:flutter/material.dart';

class LoginBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.green[600],
      child: Padding(
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "LOGIN",
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Mulish',
                  fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      onPressed: () => Navigator.pushNamed(context, '/Login'),
      shape: const StadiumBorder(),
    );
  }
}
