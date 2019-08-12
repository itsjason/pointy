import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final self = this;

    var roomId = widget.roomId;
    Room.getDocumentStream(Firestore.instance, "rooms/$roomId").forEach((r) => 
      self.setState(() {
        this.room = r;
      })
    );

    return Container(
      child: Column(children: [Text('Room: ${room.name}')]),
    );
  }
}
