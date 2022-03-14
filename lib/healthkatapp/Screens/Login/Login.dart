import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../../helpers/transform/transform.dart';
import '../Admin/Admin.dart';
import '../Homepage/Homepage.dart';
import '../Verification.dart';
import '../../current_user.dart';
import '../Register/Register.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

//  String mail;
//  String password;
  String errorText;
  String mailErrorText;
  bool validateMail = false;
  bool validatePassword = false;
  bool _loading = false;

  var _mailController = TextEditingController();
  var _passwordController = TextEditingController();
  final FocusNode _mailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future logIn() async {
    setState(() {
      _loading = true;
    });
    try {
      if (_mailController.text == null || _mailController.text.length < 1) {
        setState(() {
          validateMail = true;
          mailErrorText = 'Enter a valid e-mail!';
          _loading = false;
        });
      } else if (_passwordController.text == null ||
          _passwordController.text.length < 8) {
        setState(() {
          validatePassword = true;
          validateMail = false;
          errorText = 'Enter a valid password!';
          _loading = false;
        });
      } else {
        setState(() {
          validatePassword = false;
          validateMail = false;
        });

        var user = await _auth.signInWithEmailAndPassword(
            email: _mailController.text, password: _passwordController.text);

        setState(() {
          _loading = false;
        });

        if (user != null) {

          _user = await _auth.currentUser;
          bool isDoc = false;
          bool admin = false;
          bool isVerified = false;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(_user.uid)
              .get()
              .then((document) {
            print(document.data()['photoUrl']);
            isDoc = document.data()['isDoctor'];
            admin = document.data()['admin'];
            isVerified = document.data()['isVerified'];
          });
          Navigator.of(context).popUntil((route) => route.isFirst);
          await Provider.of<CurrentUser>(context, listen: false)
              .getCurrentUser();
          if (isDoc) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return VerificationScreen(isVerified);
            }));
          } else if (admin!=null || admin == true){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Admin();
            }));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return Homepage();
            }));
          }
        }
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _loading = false;
        errorText = 'Check your email/password combination!';
        mailErrorText = null;
      });

      print(error.code);

      switch (error.code) {
        case "invalid-email":
          setState(() {
            mailErrorText = "Your email address appears to be malformed.";
            errorText = null;
            validateMail = true;
            validatePassword = false;
          });
          break;
        case "wrong-password":
          setState(() {
            errorText = "Wrong password!";
            mailErrorText = null;
            validateMail = false;
            validatePassword = true;
          });
          break;
        case "user-not-found":
          setState(() {
            mailErrorText = "User with this email doesn't exist.";
            errorText = null;
            validateMail = true;
            validatePassword = false;
          });
          break;
        case "user-disabled":
          setState(() {
            mailErrorText = "User with this email has been disabled.";
            errorText = null;
            validateMail = true;
            validatePassword = false;
          });
          break;
        case "too-many-requests":
          setState(() {
            errorText = "Too many requests. Try again later.";
            mailErrorText = null;
            validateMail = false;
            validatePassword = true;
          });
          break;
        case "network-request-failed":
          setState(() {
            errorText = 'The internet connection appears to be offline';
            mailErrorText = null;
            validateMail = false;
            validatePassword = true;
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
      FocusScope.of(context).unfocus();
    },
    child: ModalProgressHUD(
      inAsyncCall: _loading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.greenAccent[400],
        body: Container(
          child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
                children: <Widget>[
                  Center (
                    child:
                    TransformHelper.rotate(
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
                    )
                  ),
                  Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                      ),
                    )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      focusNode: _mailFocus,
                      controller: _mailController,
                      keyboardType: TextInputType.emailAddress,
                      onSubmitted: (value) {
                        _fieldFocusChange(context, _mailFocus, _passwordFocus);
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 1,color: Colors.white),
                        ),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.green[700],
                        ),
                        border:
                        OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white,
                        hintText: 'Email',
                        errorText: validateMail ? mailErrorText : null,
                        hintStyle: new TextStyle(color: Colors.grey),
                        //labelText: 'User Name',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: new TextField(
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      focusNode: _passwordFocus,
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 1,color: Colors.white),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        errorText: validatePassword ? errorText : null,
                        //labelText: 'Password',
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock,
                            color: Colors.green[700]),
                        hintStyle: new TextStyle(color: Colors.grey),
                      ),
                      onSubmitted: (value) => logIn(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.height * 0.28,
                      padding: EdgeInsets.all(5),
                      child: RawMaterialButton(
                          fillColor: Colors.green[700],
                          child: Text(
                              'LOGIN',
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              )),
                          onPressed: () async => await logIn(),
                          shape: const StadiumBorder()
                      )
                    )
                  ),

                  Container(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white,
                              fontSize: 16),
                        ),
                        TextButton(
                            child: Text(
                              'Register here',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Register()),
                              );
                            }
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
              ]),
            ]),
          )
      )
    ));
  }
}