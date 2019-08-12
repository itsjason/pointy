import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'data-types/member.dart';
import 'data-types/room.dart';

class RoomPage extends StatefulWidget {
  final String roomId;

  RoomPage({Key key, this.roomId}) : super(key: key);

  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  // Widget buildFromRoomId(String roomId) {
  //   FutureBuilder()
  // }

  Room room;
  String roomName = "UNKNOEN";
  Map<String, Member> members = Map();

  @override
  Widget build(BuildContext context) {
    final self = this;

    var roomId = widget.roomId;
    Room.getDocumentStream(Firestore.instance, "rooms/$roomId").forEach((r) =>
        self.setState(() {
          this.room = r;
          this.roomName = r.name;
          Member.getCollectionStream(Firestore.instance, 'rooms/$roomId/users')
              .forEach((memberList) => setState(() => members = memberList));
        }));

    return Scaffold(
      appBar: AppBar(title: Text(roomName),),
      body: Column(children: [
        Text('Room: $room'),
        ListView.builder(
            itemCount: members.length,
            itemBuilder: (c, i) => Text(members.entries.toList()[i].value.uid),
            shrinkWrap: true)
      ]),
    );
  }
}
