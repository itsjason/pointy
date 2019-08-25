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
  String roomName = "UNKNOWN";
  Map<String, Member> members = Map();

  @override
  Widget build(BuildContext context) {
    var roomId = widget.roomId;
    
    return Scaffold(
      appBar: AppBar(title: Text(roomName),),
      body: Container(
        margin: EdgeInsets.all(50),
        child: StreamBuilder<Room>(
          stream: Room.getDocumentStream(Firestore.instance, "rooms/$roomId"),
          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return Text('Loading Room...', style: Theme.of(context).textTheme.display1);
            }
            
            // Ok so we have a room
            var room = snapshot.data;
            return Column(children: [
              Text('Room: ${room.name}'),
              StreamBuilder<Map<String, Member>>(
                stream: Member.getCollectionStream(Firestore.instance, 'rooms/$roomId/users'),
                builder: (context, snapshot) {
                  if(!snapshot.hasData) {
                    return Text('No users');
                  }

                  var members = snapshot.data;

                  return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (c, i) => 
                        Text(
                          members.entries.toList()[i].value.name ?? "NO Name", 
                          style: Theme.of(context).textTheme.display1,
                        ),
                      shrinkWrap: true);
                }
              )
            ]);
          }
        ),
      ),
    );
  }
}
