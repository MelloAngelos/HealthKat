import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../Components/AppointmentTile.dart';
import '../../current_user.dart';

class AppointmentHistory extends StatefulWidget {
  AppointmentHistory();
  @override
  _ViewHistoryState createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<AppointmentHistory> {
  DateFormat dateFormat = DateFormat("dd/MM/yyyy HH:mm");
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
            inAsyncCall: false,
            child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context)),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                backgroundColor: Colors.white,
                body: Padding(
                  padding: EdgeInsets.only(top: 10, left: 8, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Appointments History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A0E21),
                          fontFamily: 'Helvetica Neue',
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('appointments')
                            // .orderBy('date')
                            .where('doctorID',
                                isEqualTo: Provider.of<CurrentUser>(context,
                                        listen: false)
                                    .loggedInUser
                                    .uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.docs.length == 0) {
                            return Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "We're getting your pending appointment history ready!",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }
                          final windows = snapshot.data.docs;
                          List<AppointmentTile> tiles = [];
                          for (var window in windows) {
                            final name = window["clientName"];
                            final content = window['description'];
                            final windowID = window['doctorID'];
                            String status = window['appointmentStatus'];
                            final docID = window['doctorID'];
                            final dateTime = window['dateTime'].toDate();
                            bool cancelAp;

                            try {
                              cancelAp = (status == "Approval Pending" ||
                                      status.substring(0, 9) == "Forwarded")
                                  ? true
                                  : false;
                            } catch (e) {
                              cancelAp = false;
                            }

                            tiles.add(
                              AppointmentTile(
                                dateTime: dateFormat.format(dateTime),
                                userName: name,
                                content: content,
                                status: status,
                                docId: docID,
                                changeStatus: true,
                                cancelAp: cancelAp,
                              ),
                            );
                          }
                          return Expanded(
                            child: tiles.length != 0
                                ? ListView(
                                    children: tiles,
                                  )
                                : Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text('No appointment windows found'),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ))));
  }
}
