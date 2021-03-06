import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../Components/current_user.dart';
import '../Verification/Verification.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User _user;

  var _mailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _nameController = TextEditingController();
  var _ageController = TextEditingController();
  var _specialityController = TextEditingController();
  final FocusNode _mailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String errorText;
  String mailErrorText;
  String nameErrorText;
  String specialityErrorText;
  bool isSwitched = false;

  bool validateMail = false;
  bool validatePassword = false;
  bool validateName = false;
  bool validateSpeciality = false;

  bool _loading = false;

  File _image;
  String _uploadedFileURL;
  String imgUrl;
  var croppedImage;

  Future getImage() async {
    setState(() {
      _loading = true;
    });
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 512,
        maxHeight: 512,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.greenAccent[700],
          toolbarTitle: 'Crop Image',
          backgroundColor: Colors.white,
        ),
      );
      setState(() {
        _loading = false;
        _image = croppedImage;
        print('image: $croppedImage');
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future uploadFile(context) async {
    if(croppedImage != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child(
          'profile/${_mailController.text}');
      UploadTask uploadTask = storageReference.putFile(croppedImage);
      await uploadTask.whenComplete(() {
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) async {
          await signUp(context, fileURL);
          setState(() {
            _uploadedFileURL = fileURL;
            imgUrl = fileURL;
          });
        });
      }).catchError((onError) {
        print(onError);
      });
    }
  }

  Future signUp(c, url) async{
    setState(() {
      _loading=true;
    });

    try {

      if (isSwitched==true && (_specialityController.text==null || _specialityController.text.length < 2)) {
        setState(() {
          validatePassword=false;
          validateMail=false;
          validateSpeciality=true;
          validateName=false;
          specialityErrorText='Enter a valid speciality!';
          _loading=false;
        });
      } else if (_nameController.text==null || _nameController.text.length < 3) {
        setState(() {
          validatePassword=false;
          validateMail=false;
          validateSpeciality=false;
          validateName=true;
          nameErrorText='Enter a valid name!';
          _loading=false;
        });
      } else if (_mailController.text==null || _mailController.text.length < 6) {
        setState(() {
          validatePassword=false;
          validateMail=true;
          validateSpeciality=false;
          validateName=false;
          mailErrorText='Enter a valid e-mail!';
          _loading=false;
        });
      } else if (_passwordController.text==null || _passwordController.text.length < 8) {
        setState(() {
          validatePassword=true;
          validateMail=false;
          validateSpeciality=false;
          validateName=false;
          errorText='Password should contain at least 8 characters!';
          _loading=false;
        });
      } else {
        setState(() {
          validatePassword=false;
          validateMail=false;
        });

        var user = await _auth.createUserWithEmailAndPassword(email: _mailController.text, password: _passwordController.text);

        if (user != null) {
          print("User created!");
          _user = await _auth.currentUser;

          await _firestore
              .collection('users')
              .doc(_user.uid)
              .set({
            'uid': _user.uid,
            'displayName': _nameController.text,
            'age':_ageController.text,
            'phone':_phoneController.text,
            'address':_addressController.text,
            'speciality':_specialityController.text,
            'isDoctor':isSwitched,
            'isVerified':isSwitched?false:null,
            'profile':url,
            'indexList':indexing(_nameController.text),
            'specialityIndex':isSwitched?indexing(_specialityController.text):null,
            'timestamp': FieldValue.serverTimestamp(),
          });
            }
          await Provider.of<CurrentUser>(c, listen: false).getCurrentUser();
          setState(() {
            _loading=false;
          });
          if (isSwitched) {
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
              return VerificationScreen(false);
            }));
          } else {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
            }
          }

        }
      on FirebaseAuthException catch (error) {
        setState(() {
          _loading=false;
          errorText='Check your email/password combination!';
          mailErrorText=null;
        });

        print(error.code);

        switch (error.code) {
          case "email-already-in-use":
            setState(() {
              mailErrorText = "Email address already in use by another user.";
              errorText = null;
              validateMail = true;
              validatePassword = false;
            });
            break;
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

  List indexing(name) {

    List<String> splitList = name.split(" ");
    List<String> indexList=[];
    for (var i=0; i<splitList.length; i++) {
      for(var y=1; y<splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    return indexList;

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
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/Intro', (Route<dynamic> route) => false),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
          ),
          backgroundColor: Colors.greenAccent[400],
          body: Container(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10.0),
              children: <Widget>[
                Center(
                    child: Text(
                      'Register',
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
                Visibility(
                  visible: isSwitched,
                  child:
                    Column(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            getImage();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _image != null
                                  ? Image.file(
                                _image,
                                fit: BoxFit.cover,
                              )
                                  : Icon(
                                Icons.supervised_user_circle,
                                size: 50,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center( child: Text(
                          'Change profile photo',

                          style: TextStyle(color: Colors.white, fontSize: 15),
                        )),
                        SizedBox(
                          height: 10,
                        ),
                      ]
                    )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Patient', style: TextStyle(color: Colors.white),),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: Colors.green[700],
                      activeColor: Colors.green[700],
                    ),
                    Text('Doctor', style: TextStyle(color: Colors.white),),
                  ],
                ),
                Visibility(
                  visible: isSwitched,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      controller: _specialityController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      //controller: passwordController,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          borderSide: BorderSide(width: 1,color: Colors.green[900]),
                        ),
                        prefixIcon: Icon(Icons.content_paste,
                            color: Colors.green[700]),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        //labelText: 'Password',
                        hintText: 'Speciality',
                        errorText: validateSpeciality ? specialityErrorText : null,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child:  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.perm_contact_calendar,
                          color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      //labelText: 'Password',
                      hintText: 'Name',
                      errorText: validateName ? nameErrorText : null,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _ageController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.green[900]),
                      ),
                      prefixIcon: Icon(Icons.cake,
                          color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      //labelText: 'Password',
                      hintText: 'Age',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _phoneController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                      prefixIcon: Icon(Icons.phone,
                          color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      //labelText: 'Password',
                      hintText: 'Phone Number',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _addressController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.green[900]),
                      ),
                      prefixIcon: Icon(Icons.markunread_mailbox,
                          color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      //labelText: 'Password',
                      hintText: 'Address',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    controller: _mailController,
                    focusNode: _mailFocus,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.email,
                          color: Colors.green[700]),
                      //labelText: 'Password',
                      hintText: 'Email',
                      errorText: validateMail ? mailErrorText : null,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: true,
                    //controller: passwordController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(width: 1,color: Colors.green[900]),
                      ),
                      prefixIcon: Icon(Icons.lock,
                          color: Colors.green[700]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      //labelText: 'Password',
                      hintText: 'Password',
                      errorText: errorText,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value) {
                      signUp(context, null);
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(child:Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.28,
                    padding: EdgeInsets.all(5),
                    child: RawMaterialButton(
                      fillColor: Colors.white,
                      child: Text(
                                'REGISTER',
                                maxLines: 1,
                                style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w700,
                                color: Colors.green[700],
                      )),
                      onPressed: () async => await (isSwitched && _image!=null)?uploadFile(context):signUp(context, null),
                      shape: const StadiumBorder()
                    ))),
                TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamedAndRemoveUntil('/Login', (Route<dynamic> route) => false),
                  child: Text(
                    'Already a member? Login now!',
                    style: TextStyle(fontSize: 16, color: Colors.green[900]),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}