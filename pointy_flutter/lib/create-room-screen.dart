import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/room-screen.dart';

class CreateRoomScreen extends StatefulWidget {
  CreateRoomScreen({Key key}) : super(key: key);

  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final textEditingController = TextEditingController();

  Future onRoomCreated(String roomId) async {
    // var Firestore.instance.document('rooms/$roomId').snapshots();

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (c) => new RoomPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Create Room'),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(hintText: 'Room Name'),
            ),
            RaisedButton(
              child: Text('Create Room'),
              onPressed: () async {
                // Invoke CreateRoom function
                // Parameters: name: stirng
                // Logic: Create room object. Add User to room users list
                // Return: string: Room ID
                var roomName = textEditingController.value.text;
                var createRoomResult = await CloudFunctions.instance
                  .getHttpsCallable(functionName: 'createRoom')
                  .call(roomName);

                  String roomId = createRoomResult.data.roomId;
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => new RoomPage(roomId: roomId)));
              },
            )
          ],
        ),
      ),
    );
  }
}
