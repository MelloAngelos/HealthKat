import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../current_user.dart';
import '../OthersProfile/OthersProfile.dart';
import '../Profile/Profile.dart';

class Chat extends StatefulWidget {
  final String chatWithUid, name, profilePic;
  Chat(this.chatWithUid, this.name, this.profilePic);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<Chat> {
  bool loading_ = false;
  String chatRoomId, messageId = "";
  Stream messageStream;
  String myProfilePic, myUid;
  TextEditingController messageTextEdittingController = TextEditingController();

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

  addMessage(
      {String myUid,
      String myProfilePic,
      String chatRoomId,
      bool sendClicked}) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      var lastMessageTs = DateTime.now();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUid,
        "ts": lastMessageTs,
        "imgUrl": myProfilePic
      };

      //messageId
      if (messageId == "") {
        messageId = randomAlphaNumeric(12);
      }

      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .collection("chats")
          .doc(messageId)
          .set(messageInfoMap)
          .then((value) {
        Map<String, dynamic> lastMessageInfoMap = {
          "lastMessage": message,
          "lastMessageSendTs": lastMessageTs,
          "lastMessageSendBy": myUid
        };

        DocumentReference docRef = FirebaseFirestore.instance
                                  .collection("chatrooms")
                                  .doc(chatRoomId);
        
        if(docRef.snapshots().contains("lastMessage") == true) {
          print("Already exists");
          docRef.update(lastMessageInfoMap);
        } else {
          docRef.set(lastMessageInfoMap);
        };

        if (sendClicked) {
          // remove the text in the message input field
          messageTextEdittingController.text = "";
          // make message id blank to get regenerated on next message send
          messageId = "";
        }
      });
    }
  }

  Widget chatMessageTile(String message, bool sendByMe) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  bottomRight:
                      sendByMe ? Radius.circular(0) : Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft:
                      sendByMe ? Radius.circular(24) : Radius.circular(0),
                ),
                color: sendByMe ? Colors.green[500] : Colors.grey[200],
              ),
              padding: EdgeInsets.all(20),
              child: Text(
                message,
                style: TextStyle(color: sendByMe ? Colors.white : Colors.black),
              )),
        ),
      ],
    );
  }

  Widget chatMessages(String myUid) {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? (snapshot.data.docs.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.only(bottom: 70, top: 16),
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];
                      return chatMessageTile(
                          ds["message"], myUid == ds["sendBy"]);
                    })
                : Center(
                    child: Text(
                      'Send a message now!',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                        color: Colors.green[900],
                        /* letterSpacing: 0.0, */
                      ),
                    ),
                  ))
            : Center(
                child: Text(
                  'Send a message now!',
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

  getAndSetMessages(chatRoomId) async {
    messageStream = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("ts", descending: true)
        .snapshots();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: widget.profilePic != "" &&
                                widget.profilePic != "null"
                            ? FadeInImage(
                                image: NetworkImage(widget.profilePic),
                                placeholder:
                                    AssetImage('assets/images/placeholder.png'),
                              )
                            : Image.asset('assets/images/placeholder.png'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(widget.name),
                    Spacer(), // I just added one line
                    IconButton(
                        icon: Icon(Icons.info_outline_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OthersProfile(widget.chatWithUid)));
                        }),
                  ],
                ),
              ),
            ),
            body: SafeArea(child:
                Consumer<CurrentUser>(builder: (context, userData, child) {
              var myUid = userData.uid;
              var myProfilePic = userData.photoUrl;
              var chatRoomId = getChatRoomIdByUids(widget.chatWithUid, myUid);
              getAndSetMessages(chatRoomId);
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  child: Stack(children: [
                    chatMessages(myUid),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
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
                              Icon(Icons.dehaze_rounded),
                              SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Type new message'),
                                    onSubmitted: (value) {
                                      addMessage(
                                          myUid: myUid,
                                          myProfilePic: myProfilePic,
                                          chatRoomId: chatRoomId,
                                          sendClicked: true);
                                    },
                                    controller: messageTextEdittingController,
                                    style: TextStyle(
                                      color: Colors.green[900],
                                    )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  addMessage(
                                      myUid: myUid,
                                      myProfilePic: myProfilePic,
                                      chatRoomId: chatRoomId,
                                      sendClicked: true);
                                },
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
            }))));
  }
}
