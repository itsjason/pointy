import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/room-screen.dart';
import 'package:pointy_flutter/preferences.dart';

class JoinRoomScreen extends StatefulWidget {
  final String userId;
  JoinRoomScreen({Key key, this.userId}) : super(key: key);

  _JoinRoomScreenState createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final roomNameController = TextEditingController();
  final userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Preferences.getLatestUserName().then((userName) {
      if (userName != null)
        setState(() {
          userNameController.text = userName;
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Join Room')),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            Text('Join Room',
                style: Theme.of(context).textTheme.display1),
            TextField(
                autofocus: true,
                style: Theme.of(context).textTheme.display1.copyWith(fontSize: 28),
                controller: roomNameController,
                decoration: InputDecoration(hintText: 'Room Name')),
            TextField(
                autofocus: true,
                style: Theme.of(context).textTheme.display1.copyWith(fontSize: 28),
                controller: userNameController,
                decoration: InputDecoration(hintText: 'Your Name')),
                SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      'Join Room',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 20, color: Colors.white),
                    ),
                    onPressed: () async {
                      var roomName = roomNameController.value.text;
                      var userName = userNameController.value.text;
                      Preferences.setLatestUserName(userName);
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
                          builder: (c) => new RoomPage(
                                roomId: roomId,
                                userId: widget.userId,
                              )));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
