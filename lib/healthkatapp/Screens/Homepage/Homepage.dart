import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/helpers/transform/transform.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import '../../chatroomListTile.dart';
import '../../current_user.dart';
import '../Chat/Chat.dart';
import '../Discover/Discover.dart';
import '../Login/Login.dart';
import '../Profile/Profile.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageScreenState createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<Homepage> {
  bool loading_ = false;
  String myUid, myName;
  Stream chatRoomsStream;


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
        getChatRooms(myUid);
      });
    });
  }

  getChatRooms(String myUid) async {
    chatRoomsStream = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("users", arrayContains: myUid)
        .orderBy("lastMessageSendTs", descending: true)
        .snapshots();

    setState(() {});
  }

  getChatRoomIdByUids(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
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

  Widget chatRoomsList({String myUid, String myName}) {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshotChat) {
          print(myUid);
          print("Snap has data?");
          print(snapshotChat.hasData);

          return snapshotChat.hasData
              ? (snapshotChat.data.docs.length != 0
                  ? ListView.builder(
                      itemCount: snapshotChat.data.docs.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshotChat.data.docs[index];

                          return ChatRoomListTile(
                            ds["lastMessage"], ds.id, myUid
                          );
                      })
                  : Center(
                      child: Text(
                      'You have no messages',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        color: Colors.green[900],
                        /* letterSpacing: 0.0, */
                      ),
                    )))
              : Center(
                  child: Text(
                  'You have no messages yet!',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    color: Colors.green[900],
                    /* letterSpacing: 0.0, */
                  ),
                ));
        });
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
              leading: TransformHelper.rotate(
                a: 1.00,
                b: 0.00,
                c: -0.00,
                d: 1.00,
                child: Container(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
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
                // overflow menu
              ],
            ),
            body: SafeArea(
              child: Consumer<CurrentUser>(
                builder: (context, userData, child) {
                  var photo = userData.photoUrl;
                  var myUid = userData.uid;
                  var myName = userData.displayName;
                  var isDoctor = userData.isDoctor;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            CircleAvatar(
                                radius: 24,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: photo != null
                                        ? IconButton(
                                            padding: EdgeInsets.all(0),
                                            icon: FadeInImage(
                                              image: NetworkImage(photo),
                                              placeholder: AssetImage(
                                                  'assets/images/placeholder.png'),
                                            ),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile())))
                                        : IconButton(
                                            padding: EdgeInsets.all(0),
                                            focusColor: Colors.white,
                                            icon: Image.asset(
                                                'assets/images/placeholder.png'),
                                            onPressed: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile()))))),
                            SizedBox(
                              width: 40,
                            ),
                            Text(
                              'Contacts',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Helvetica Neue',
                                letterSpacing: 0.2,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search'),
                                    onTap:() => Navigator.push( context, MaterialPageRoute(
                                                              builder: (context) => Discover())
                                    ),
                                    style: TextStyle(
                                      color: Colors.green[900],
                                    ),
                                    readOnly: true,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        chatRoomsList(myUid: myUid, myName: myName),
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
