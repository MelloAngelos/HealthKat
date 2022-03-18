import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

import '../../current_user.dart';

class Chat extends StatefulWidget {
  final String chatWithUid, name;
  Chat(this.chatWithUid, this.name);
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
      await Provider.of<CurrentUser>(context, listen: false).getCurrentUser();
      setState(() {
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

  addMessage({String myUid, String myProfilePic, String chatRoomId, bool sendClicked}) {
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

        FirebaseFirestore.instance
            .collection("chatrooms")
            .doc(chatRoomId)
            .update(lastMessageInfoMap);

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
                color: sendByMe ? Colors.blue : Color(0xfff1f0f0),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
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
            ? (snapshot.data.docs.length != 0 ?
              ListView.builder(
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
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .width * 0.05,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w700,
                      color: Colors.green[900],
                      /* letterSpacing: 0.0, */
                    ),
                  ),
                )
              ) : Center(
                child: Text(
                  'Send a message now!',
                  style: TextStyle(
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * 0.05,
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
      child:Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
        ),
        body: SafeArea(
          child: Consumer<CurrentUser>(
            builder: (context, userData, child) {
            var myUid = userData.uid;
            var myProfilePic = userData.photoUrl;
            var chatRoomId = getChatRoomIdByUids(widget.chatWithUid, myUid);
            getAndSetMessages(chatRoomId);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child:Container(
                child: Stack(
                  children: [
                    chatMessages(myUid),
                    Container(
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 10.0,),
                          Icon(Icons.search),
                          SizedBox(width: 8.0,),
                          Expanded(
                            child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type new message'
                                ),
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
                                )
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              addMessage(
                                  myUid: myUid,
                                  myProfilePic: myProfilePic,
                                  chatRoomId: chatRoomId,
                                  sendClicked: true
                              );
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        )
      )
    );
  }
}