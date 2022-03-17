import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class CurrentUser extends ChangeNotifier {
  User loggedInUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;

  String displayName;
  String photoUrl;
  String phoneNumber;
  String address;
  bool isDoctor;
  String speciality;

  List<User_profile> requests = [];

  Future getCurrentUser() async {
    try {
      var user = await auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        displayName = loggedInUser.displayName;
        await getInfo();
      }
    } catch (e) {
      print("Error while getting current user!");
      print(e);
    }
  }

  Future getInfo({bool update}) async {
    print('updating..');
    displayName = loggedInUser.displayName;
    await firestore
        .collection('users')
        .doc(loggedInUser.uid)
        .get()
        .then((document) {
      displayName = document.data()['displayName'];
      photoUrl = document.data()['profile'];
      isDoctor = document.data()['isDoctor'];
      phoneNumber = document.data()['phone'];
      address = document.data()['address'];
      speciality = document.data()['speciality'];
      notifyListeners();
    });
  }

  Future getRequests() async {
    requests.clear();
    await firestore
        .collection('users')
        .where('isVerified', isEqualTo: false)
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> document) async {
      document.docs.forEach((DocumentSnapshot<Map<String, dynamic>> request) {
        print(request.data);
        requests.add(User_profile(
          name: request.data()['displayName'],
          photoUrl: request.data()['profile'],
          uid: request.data()['uid'],
          isDoctor: request.data()['isDoctor'],
        ));
      });
    });
    notifyListeners();
  }

  Future acceptRequest(uid, index) async {
    DocumentReference doctorRef =
        FirebaseFirestore.instance.doc('users/' + uid);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot freshSnap1 = await transaction.get(doctorRef);

      await transaction.update(freshSnap1.reference, {
        'isVerified': true,
      });
    });

    requests.removeAt(index);
    notifyListeners();
  }

  Future declineRequest(uid, index) async {
    DocumentReference doctorRef =
        FirebaseFirestore.instance.doc('users/' + uid);

    await firestore.runTransaction((transaction) async {
      DocumentSnapshot freshSnap1 = await transaction.get(doctorRef);

      await transaction.update(freshSnap1.reference, {
        'isVerified': null,
      });
    });

    requests.removeAt(index);
    notifyListeners();
  }
}
