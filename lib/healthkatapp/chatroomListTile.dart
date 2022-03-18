import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Screens/Chat/Chat.dart';

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage, chatRoomId, myUid;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.myUid);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String profilePicUrl = "", name = "", uid = "";

  getThisUserInfo() async {
    uid = widget.chatRoomId.split("_")[1];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                                  .collection("users")
                                  .where("uid", isEqualTo: uid)
                                  .get()
                                  ;
    name = "${querySnapshot.docs[0]["displayName"]}";
    profilePicUrl = "${querySnapshot.docs[0]["profile"]}";
    setState(() {});
  }

  @override
  void initState() {
    getThisUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(uid, name)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: profilePicUrl != "" ? FadeInImage(
                  image: NetworkImage(profilePicUrl),
                  placeholder: AssetImage('assets/images/placeholder.png'),
                ):Image.asset('assets/images/placeholder.png'),
              ),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 3),
                Text(widget.lastMessage)
              ],
            )
          ],
        ),
      ),
    );
  }
}