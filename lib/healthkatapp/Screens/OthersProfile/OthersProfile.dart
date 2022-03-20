import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/healthkatapp/Screens/NewAppointment/NewAppointment.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import '../../Components/SearchBar.dart';
import '../../current_user.dart';

class OthersProfile extends StatefulWidget {
  final String id;
  OthersProfile(this.id);
  @override
  _ProfileState createState() => _ProfileState();
}

bool notifications = true;

class _ProfileState extends State<OthersProfile> {
  String profilePicUrl = "",
      name = "",
      phone = "",
      age = "",
      speciality = "",
      address = "";
  bool _loading = false;
  bool loading_ = false;
  bool isDoctor = false;

  getThisUserInfo() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("uid", isEqualTo: widget.id)
        .get();
    name = "${querySnapshot.docs[0]["displayName"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profile"]}";
    address = "${querySnapshot.docs[0]["address"]}";
    phone = "${querySnapshot.docs[0]["phone"]}";
    isDoctor = "${querySnapshot.docs[0]["isDoctor"]}".toLowerCase() == 'true';
    age = "${querySnapshot.docs[0]["age"]}";
    speciality = "${querySnapshot.docs[0]["speciality"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loading_ = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<CurrentUser>(context, listen: false).getInfo();
      setState(() {
        loading_ = false;
      });
    });
  }

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
                    onPressed: () => Navigator.pop(context)),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              backgroundColor: Colors.white,
              body: Container(
                child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[
                      Container(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child:
                                profilePicUrl != "null" && profilePicUrl != ""
                                    ? FadeInImage(
                                        image: NetworkImage(profilePicUrl),
                                        placeholder: AssetImage(
                                            'assets/images/placeholder.png'),
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
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      )),
                      Center(
                        child: Text(isDoctor == true
                            ? speciality != ""
                                ? speciality
                                : 'Doctor'
                            : 'Patient'),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: Row(
                          children: [
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
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          children: [
                            Icon(Icons.home),
                            SizedBox(width: 4),
                            Container(
                              child: Text('Address : '),
                            ),
                            Container(
                              child: Text(address),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 200),
                      Text("More Actions",
                          style: TextStyle(color: Colors.grey)),
                      isDoctor == true
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            NewAppointment(widget.id)));
                              },
                              child: Center(child: Text('+ New Appointment')))
                          : SizedBox(
                              height: 10,
                            ),
                      Divider(),
                      Text("Privacy", style: TextStyle(color: Colors.grey)),
                      TextButton(
                          style: TextButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            final snackBar = SnackBar(
                                content: notifications
                                    ? Text("Notifications for " +
                                        name +
                                        " turned off")
                                    : Text("Notifications for " +
                                        name +
                                        " turned on"));
                            setState(() {
                              notifications = !notifications;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Notifications",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal)),
                                Row(children: [
                                  Text(notifications == true ? "On" : "Off"),
                                  Icon(notifications == true
                                      ? Icons.notifications
                                      : Icons.notifications_off)
                                ]),
                              ])),
                      Divider()
                    ]),
              ),
            )));
  }
}
