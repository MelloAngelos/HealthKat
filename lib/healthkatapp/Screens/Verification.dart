import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../current_user.dart';

import 'Home.dart';
import 'Login/Login.dart';

class VerificationScreen extends StatefulWidget {
  bool isVerified;
  VerificationScreen(this.isVerified);
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {


  bool loading =  false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.isVerified == true) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
          return Home();
        }));
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: Scaffold(
        backgroundColor: Colors.greenAccent[400],
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Waiting for Doctor to be verified.....',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white,size: 32,),
                  onPressed: () async{
                    setState(() {
                      loading=true;
                    });
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<CurrentUser>(context, listen: false).loggedInUser.uid)
                        .get()
                        .then((document) {
                      widget.isVerified = document.data()['isVerified'];
                    });
                    if (widget.isVerified) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                        return Home();
                      }));
                    }
                    setState(() {
                      loading=false;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white,size: 32,),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then((value) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                            return Login();
                          }));
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}