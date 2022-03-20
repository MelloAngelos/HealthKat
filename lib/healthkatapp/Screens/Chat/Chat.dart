import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isPlayingMsg = false, isRecording = false, isSending = false;
  String recordFilePath;
  AudioPlayer audioPlayer = AudioPlayer();


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
        "imgUrl": myProfilePic,
        "type": "Text"
      };

      messageId = DateTime.now().millisecondsSinceEpoch.toString();

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
        }
      });
    }
  }

  sendAudioMsg(
      String myUid,
      String myProfilePic,
      String chatRoomId,
      String audioMsg) async {

    messageId = DateTime.now().millisecondsSinceEpoch.toString();

    var lastMessageTs = DateTime.now();

    Map<String, dynamic> messageInfoMap = {
      "message": audioMsg,
      "sendBy": myUid,
      "ts": lastMessageTs,
      "imgUrl": myProfilePic,
      "type": "Audio"
    };

    if (audioMsg.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .collection("chats")
          .doc(messageId)
          .set(messageInfoMap)
          .then((value) {
              setState(() {
                isSending = false;
              });
              Map<String, dynamic> lastMessageInfoMap = {
                "lastMessage": "Audio Message",
                "lastMessageSendTs": lastMessageTs,
                "lastMessageSendBy": myUid
              };

            FirebaseFirestore.instance
                .collection("chatrooms")
                .doc(chatRoomId)
                .update(lastMessageInfoMap);
          });
    } else {
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, String type, Timestamp ts) {
    if(type == "Text")
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
      else if(type == "Audio") {
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
                  child: GestureDetector(
                    onTap: () {
                      if(isPlayingMsg == false) {
                        _loadFile(Uri.parse(message));
                      } else {
                        audioPlayer.stop();
                        setState(() {
                          isPlayingMsg = false;
                          print(isPlayingMsg);
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(isPlayingMsg ? Icons.stop : Icons.play_arrow),
                            Text(
                              'Audio-${ts.millisecondsSinceEpoch.toString()}',
                              maxLines: 10,
                            ),
                          ],
                        )],
                    )
                  ),
              )
            ),
          ],
        );

      }
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
                          ds["message"], myUid == ds["sendBy"], ds["type"], ds["ts"]);
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

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord(String myUid,
      String myProfilePic,
      String chatRoomId) async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio(myUid,myProfilePic, chatRoomId);

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      await audioPlayer.play(
          recordFilePath,
      );

    }
  }


  Future _loadFile(Uri url) async {
    final bytes = await readBytes(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;
        isPlayingMsg = true;
        print(isPlayingMsg);
      });
      await play();
      audioPlayer.onPlayerCompletion.listen((event) {
        setState(() {
          isPlayingMsg = false;
        });
      });
    }
  }
  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  uploadAudio(String myUid,
      String myProfilePic,
      String chatRoomId) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child(
        'records/audio_${DateTime.now().millisecondsSinceEpoch.toString()}');

    UploadTask uploadTask = storageReference.putFile(File(recordFilePath));
    await uploadTask.whenComplete(() {
      print('File Uploaded');
      storageReference.getDownloadURL().then((audioURL) async {
        print(audioURL);
        await sendAudioMsg(myUid, myProfilePic, chatRoomId, audioURL);
      });
    }).catchError((onError) {
      print(onError);
    });


  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  showAlertDialog(BuildContext context, String name) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { Navigator.pop(context); },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("No phone provided from $name"),
      content: Text("Send a message to $name now!"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                child: Consumer<CurrentUser>(builder: (context, userData, child) {
                  var phone = userData.phoneNumber;
                  var name = userData.displayName;
                  return Row(
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child:
                      Text(widget.name, maxLines:1, overflow:TextOverflow.fade)
                    ),
                    Spacer(),
                    IconButton(icon: new Icon(Icons.phone),
                        onPressed: () {
                          setState(() {
                            if(phone!= null) {
                              var url = 'tel:+30' + phone;
                              _makePhoneCall(url);
                            } else {
                              showAlertDialog(context, name);
                            }
                          });
                        },
                      ),
                    SizedBox(width:10),
                    IconButton(
                        icon: Icon(Icons.info_outline_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OthersProfile(widget.chatWithUid)));
                        }),
                  ]);
                }
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
                              Container(
                                height: 40,
                                margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: isRecording
                                          ? Colors.white
                                          : Colors.black12,
                                      spreadRadius: 4)
                                ], color: Colors.green[500], shape: BoxShape.circle),
                                child: GestureDetector(
                                  onTap: () {
                                        if(!isRecording) {
                                          startRecord();
                                          setState(() {
                                            isRecording = true;
                                          });
                                        } else {
                                          stopRecord(myUid, myProfilePic, chatRoomId);
                                          setState(() {
                                            isRecording = false;
                                          });
                                        }
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.mic,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                                )),
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
                                    color: Colors.green[500],
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
