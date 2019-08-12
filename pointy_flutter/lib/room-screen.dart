import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    var roomId = widget.roomId;

StreamTransformer.fromHandlers(handleData: (QuerySnapshot snapshot, EventSink sink) {

      var result = Map<String, Reward>();

      snapshot.documents.forEach((doc) {

        result[doc.documentID] = Reward.fromMap(doc.documentID, doc.data);

      });

      sink.add(result);

    })
    var room = Firestore.instance.document('rooms/$roomId').snapshots().transform(Room.getTransformer());

    return Container(
      child: Column(children: [Text('Room: [Room Name]')]),
    );
  }
}
