import 'dart:ffi';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

import '../../current_user.dart';

class NewAppointment extends StatefulWidget {
  final String docId = 'vhTV0S9ao9YG9a7r9UI9YIfK3Nv1';
  NewAppointment();
  @override
  _NewAppointmentState createState() => _NewAppointmentState();
}

class _NewAppointmentState extends State<NewAppointment> {
  bool inProgress = false;

  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  DateTime dateTime;
  String text;
  String imgUrl;
  List groups;
  List groupNames;
  String groupId = "",
      doctorName = "",
      profilePicUrl = "",
      phone = "",
      age = "",
      speciality = "";
  double minPrice;
  double maxPrice;
  TextEditingController textEditingController = TextEditingController();

  BottomNavigationBar navigationBar;

  getDoctorInfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.docId)
        .get();
    doctorName = "${querySnapshot.docs[0]["displayName"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profile"]}";
    phone = "${querySnapshot.docs[0]["phone"]}";
    age = "${querySnapshot.docs[0]["age"]}";
    speciality = "${querySnapshot.docs[0]["speciality"]}";
    setState(() {});
  }

  @override
  void initState() {
    getDoctorInfo();
    super.initState();
  }

  Future pushData() async {
    try {
      if ((textEditingController.text == "")) {
        setState(() {
          inProgress = false;
        });
        BotToast.showSimpleNotification(title: 'Add a description');
      } else {
        DocumentReference reference =
            await FirebaseFirestore.instance.collection('appointments').add({
          'description': textEditingController.text,
          'appointmentStatus': 'Approval Pending',
          'uid':
              Provider.of<CurrentUser>(context, listen: false).loggedInUser.uid,
          'clientName':
              Provider.of<CurrentUser>(context, listen: false).displayName,
          'doctorID': widget.docId,
          'dateTime': dateTime,
          'timeCreated': FieldValue.serverTimestamp(),
        });

        textEditingController.clear();
        Navigator.pop(context);
        setState(() {
          inProgress = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        inProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Appointment'),
        backgroundColor: Color(0xFF0A0E21),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
          inAsyncCall: inProgress,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: profilePicUrl != "null" && profilePicUrl != ""
                            ? FadeInImage(
                                image: NetworkImage(profilePicUrl),
                                placeholder:
                                    AssetImage('assets/images/placeholder.png'),
                              )
                            : Icon(
                                Icons.supervised_user_circle,
                                size: 120,
                                color: Colors.green[700],
                              ),
                      ),
                    ),
                  ),
                  Container(
                      child: Center(
                    child: Text(
                      doctorName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  )),
                  Center(
                    child: Text(speciality != "" ? speciality : 'Doctor'),
                  ),
                  SizedBox(height: 50),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(width: 16),
                        Icon(Icons.phone),
                        SizedBox(width: 4),
                        Container(
                          child: Text('Phone Number : '),
                        ),
                        Container(
                          child: Text(phone),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      minLines: 4,
                      maxLines: null,
                      controller: textEditingController,
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey, width: 5.0),
                        ),
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                        hintText: 'Description of Medical Problem',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 13),
                      child: Container(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(40)),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: StadiumBorder()),
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                          showTitleActions: true,
                                          minTime: new DateTime.now(),
                                          maxTime: DateTime(2024, 6, 7),
                                          onChanged: (date) {
                                    print('change $date');
                                  }, onConfirm: (date) {
                                    print('confirm $date');
                                  },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en)
                                      .then((date) {
                                    dateTime = date;
                                    setState(() {});
                                    print(dateTime);
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      dateTime == null
                                          ? 'Pick a date'
                                          : dateFormat.format(dateTime),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Icon(Icons.date_range),
                                  ],
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(40)),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    minimumSize: const Size.fromHeight(50),
                                    shape: StadiumBorder()),
                                onPressed: () {
                                  if (dateTime == null)
                                    BotToast.showSimpleNotification(
                                        title:
                                            'Please pick a date to proceed!');
                                  else {
                                    pushData();
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
