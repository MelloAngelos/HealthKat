import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentTile extends StatefulWidget {
  final String userName;
  final String content;
  final String docId;
  final String uid;
  final int index;
  final String status;
  final bool changeStatus;
  final bool cancelAp;
  final String dateTime;
  Function onPress;

  AppointmentTile({
    this.userName,
    this.content,
    this.dateTime,
    //this.location,
    this.docId,
    this.uid,
    this.index,
    this.status,
    this.changeStatus,
    this.cancelAp,
    this.onPress,
  });

  @override
  _AppointmentTileState createState() => _AppointmentTileState();
}

class _AppointmentTileState extends State<AppointmentTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Patient Name: ${widget.userName}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.1),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'When: ${widget.dateTime}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.1),
                  ),
                  SizedBox(height: 5),
                  Text(
                    widget.status != "Done" ? 'Status: ${widget.status}' : "",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.1,
                      color: Colors.pink,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Visibility(
                  visible: widget.content != null ? true : false,
                  child: Row(children: [
                    Text(
                      'Description: ',
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.15,
                        height: 1.3,
                      ),
                    ),
                    Text(
                      '${widget.content}',
                      style: TextStyle(
                        fontSize: 17,
                        letterSpacing: 0.15,
                        height: 1.3,
                      ),
                    ),
                  ])),
              SizedBox(
                height: 4,
              ),
              Visibility(
                visible: widget.changeStatus,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.green),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          Text(
                            'Approve',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        DocumentReference doctorRef = FirebaseFirestore.instance
                            .doc('appointments/' + widget.docId);

                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot freshSnap1 =
                              await transaction.get(doctorRef);

                          await transaction.update(freshSnap1.reference, {
                            'appointmentStatus': 'Approved',
                          });
                        });
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.red),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          Text(
                            'Reject',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        DocumentReference doctorRef = FirebaseFirestore.instance
                            .doc('appointments/' + widget.docId);

                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot freshSnap1 =
                              await transaction.get(doctorRef);

                          await transaction.update(freshSnap1.reference, {
                            'appointmentStatus': 'Rejected',
                          });
                        });
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(primary: Colors.orange),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          Text(
                            'Forward',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.cancelAp,
                child: TextButton(
                  style: TextButton.styleFrom(primary: Colors.red),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    try {
                      DocumentReference ref = FirebaseFirestore.instance
                          .doc('appointments/' + widget.docId);
                      await FirebaseFirestore.instance
                          .runTransaction((Transaction myTransaction) async {
                        await myTransaction.delete(ref);
                      });
                    } catch (e) {
                      BotToast.showSimpleNotification(
                          title: 'Something went wrong :(');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 0.5,
                color: Colors.black26,
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
