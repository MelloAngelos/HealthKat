import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../current_user.dart';
import '../Chat/Chat.dart';
import '../Login/Login.dart';
import '../Profile/Profile.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<Discover> {
  bool loading_ = false;
  bool isSearching = false;
  bool isEmpty = true;
  String myUid, myName;
  Stream usersStream;
  final FocusNode searchFocus = FocusNode();
  var searchUsernameEditingController = TextEditingController();

  String placeholderText = 'Contact your doctor now!';
  String speciality = '';
  String currentText = '';

  Color c1 = Colors.grey;
  Color c2 = Colors.grey;
  Color activeC = Colors.greenAccent[700];
  Color inactiveC = Colors.grey;
  double selectedBoxWidth1 = 1;
  double selectedBoxWidth2 = 1;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loading_ = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var uid = await Provider.of<CurrentUser>(context, listen: false)
          .getCurrentUser();
      setState(() {
        myUid = uid;
        loading_ = false;
      });
    });
  }

  getChatRoomIdByUids(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  onSearchBtnClick(bool isDoctor) async {
    print("Is Doctor?");
    print(isDoctor);
    print("Current text is: ");
    print(currentText);
    if(isDoctor) {

      if(speciality == 'false') {
        usersStream = await FirebaseFirestore.instance
            .collection("users")
            .where("indexList", arrayContains: currentText)
            .snapshots();
        setState(() {});
      } else if(speciality == 'true'){
        usersStream = await FirebaseFirestore.instance
            .collection("users")
            .where("specialityIndex", arrayContains: currentText)
            .snapshots();
        setState(() {});
      }

    } else {
      if(speciality == 'false') {
        usersStream = await FirebaseFirestore.instance
            .collection("users")
            .where("isDoctor", isEqualTo: true)
            .where("indexList", arrayContains: currentText)
            .snapshots();
        setState(() {});
      } else if(speciality == 'true'){
        usersStream = await FirebaseFirestore.instance
            .collection("users")
            .where("isDoctor", isEqualTo: true)
            .where("specialityIndex", arrayContains: currentText)
            .snapshots();
        setState(() {});
      }
    }
  }

  createChatRoom(String chatRoomId, Map chatRoomInfoMap) async {
    final snapShot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Widget searchListUserTile(
      {String myUid, String myName, String uid, name, profileUrl}) {
    return GestureDetector(
      onTap: () {
        var chatRoomId = getChatRoomIdByUids(myUid, uid);
        Map<String, dynamic> chatRoomInfoMap = {
          "users": [myUid, uid],
          "lastMessage": "",
          "lastMessageSendTs": "",
          "lastMessageSendBy": ""
        };
        print(chatRoomId);
        createChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(uid, name, profileUrl)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: profileUrl != null && profileUrl != ""
                  ? Image.network(
                profileUrl,
                height: 40,
                width: 40,
              ) : Image.asset(
                "assets/images/placeholder.png",
                width: 50.0,
                height: 50.0,
              ),
            ),
            SizedBox(width: 12),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(name)])
          ],
        ),
      ),
    );
  }

  Widget searchUsersList({String myUid, String myName}) {
    return StreamBuilder(
      stream: usersStream,
      builder: (context, snapshot) {
        print(myUid);
        print("Search Snap has data?");
        print(snapshot.hasData);
        print(c1);
        print(c2);
        if(usersStream == null)
          return Center(
            child: Text(
              '$placeholderText',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: Colors.green[900],
                /* letterSpacing: 0.0, */
              ),
            ),
          );

        return snapshot.hasData
            ? (snapshot.data.docs.length != 0
            ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return searchListUserTile(
              myUid: myUid,
              myName: myName,
              uid: ds["uid"],
              name: ds["displayName"],
              profileUrl: ds["profile"] != null ? ds["profile"] : "",
            );
          },
          ) : Center(
              child: Text(
                '$placeholderText',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  color: Colors.green[900],
                  /* letterSpacing: 0.0, */
                ),
              ),
            )
        ) : Center(
          child: Text(
            '$placeholderText',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w700,
              color: Colors.green[900],
              /* letterSpacing: 0.0, */
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ModalProgressHUD(
          inAsyncCall: loading_,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context)),
              title: Text(
                'Discover',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Helvetica Neue',
                  letterSpacing: 0.2,
                  color:Colors.black,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SafeArea(
              child: Consumer<CurrentUser>(
                builder: (context, userData, child) {
                  var myUid = userData.uid;
                  var myName = userData.displayName;
                  var isDoctor = userData.isDoctor;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Container(
                          height: 45.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.shade200,
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Icon(Icons.search),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: TextField(
                                    focusNode: searchFocus,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search'),
                                    onChanged: (value) {
                                      setState(() {
                                        currentText = value.toLowerCase();
                                        if (value != "" ) {
                                          isSearching = true;
                                          onSearchBtnClick(isDoctor);
                                          placeholderText = 'Select Doctor or Speciality!';
                                          isEmpty = false;
                                        } else{
                                          speciality = '';
                                          c1 = inactiveC;
                                          c2 = inactiveC;
                                          selectedBoxWidth1 = 1;
                                          selectedBoxWidth2 = 1;
                                          isSearching = false;
                                          isEmpty = true;
                                        }
                                      });
                                    },
                                    style: TextStyle(
                                      color: Colors.green[900],
                                    )),
                              )
                            ],
                          ),
                        ),
                        isSearching ? Padding(
                          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (c1 == activeC) {
                                        c1 = inactiveC;
                                        selectedBoxWidth1 = 1;
                                        speciality = '';
                                        placeholderText = 'Select Speciality or Doctor!';
                                        usersStream = null;
                                      } else {
                                        c1 = activeC;
                                        c2 = inactiveC;
                                        selectedBoxWidth1 = 5;
                                        selectedBoxWidth2 = 1;
                                        speciality = 'false';
                                        placeholderText = 'No doctor found!';
                                        onSearchBtnClick(isDoctor);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        isDoctor ? 'Person' : 'Doctor',
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: c1,
                                        width: selectedBoxWidth1,
                                      ),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (c2 == activeC) {
                                        c2 = inactiveC;
                                        speciality = '';
                                        selectedBoxWidth2 = 1;
                                        placeholderText = 'Select Speciality or Doctor!';
                                        usersStream = null;
                                      } else {
                                        c1 = inactiveC;
                                        c2 = activeC;
                                        speciality = 'true';
                                        selectedBoxWidth2 = 5;
                                        selectedBoxWidth1 = 1;
                                        placeholderText ='No speciality found!';
                                        onSearchBtnClick(isDoctor);
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        'Speciality',
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      border:  Border.all(
                                        color: c2,
                                        width: selectedBoxWidth2,
                                      ),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        )
                            : SizedBox(),
                        SizedBox(
                          height: 30,
                        ),
                        (isEmpty) ? Center(
                            child: Text(
                              'Contact your doctor now!',
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.05,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w700,
                                color: Colors.green[900],
                                /* letterSpacing: 0.0, */
                              ),
                            )) : (
                            (c1 == inactiveC && c2 == inactiveC) ?
                            Center(
                                child: Text(
                                  'Select Doctor or Speciality!',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.05,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green[900],
                                    /* letterSpacing: 0.0, */
                                  ),
                                )) : searchUsersList(myUid: myUid, myName: myName)
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
