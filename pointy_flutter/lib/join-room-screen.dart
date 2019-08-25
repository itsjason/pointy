import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/room-screen.dart';

class JoinRoomScreen extends StatefulWidget {
  final String userId;
  JoinRoomScreen({Key key, this.userId}) : super(key: key);

  _JoinRoomScreenState createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final roomNameController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
            border: Border.all(
          color: Colors.black,
          width: 2,
        )),
        child: Column(
          children: <Widget>[
            Text('Join Room',
                style: Theme.of(context).textTheme.display3.copyWith(
                      color: Colors.black,
                    )),
            SizedBox(height: 30),
            TextField(
                autofocus: true,
                style: Theme.of(context).textTheme.display1,
                controller: roomNameController,
                decoration: InputDecoration(hintText: 'Room Name')),
            TextField(
                autofocus: true,
                style: Theme.of(context).textTheme.display1,
                controller: userNameController,
                decoration: InputDecoration(hintText: 'Your Name')),
            RaisedButton(
              color: Colors.blue,
              child: Text("Join"),
              onPressed: () async {
                var roomName = roomNameController.value.text;
                var userName = userNameController.value.text;
                print("Joining room $roomName");
                var createRoomResult = await CloudFunctions.instance
                    .getHttpsCallable(functionName: 'joinRoom')
                    .call({
                  'roomName': roomName,
                  'userName': userName
                }); //Actually ignoring the name param for now?
                print("Got result: $createRoomResult");
                Map<dynamic, dynamic> returnValue = createRoomResult.data;
                String roomId = returnValue['roomId'];
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) => new RoomPage(roomId: roomId, userId: widget.userId,)));
              },
            )
          ],
        ),
      ),
    );
  }
}
