import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/vote-screen.dart';
import 'data-types/member.dart';
import 'data-types/room.dart';

class RoomPage extends StatefulWidget {
  final String roomId;
  final String userId;

  RoomPage({Key key, @required this.roomId, @required this.userId})
      : super(key: key);

  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  // Widget buildFromRoomId(String roomId) {
  //   FutureBuilder()
  // }

  Room room;
  String roomName = "Pointing Session";
  Map<String, Member> members = Map();

  @override
  Widget build(BuildContext context) {
    var roomId = widget.roomId;

    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: StreamBuilder<Room>(
            stream: Room.getDocumentStream(Firestore.instance, "rooms/$roomId"),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('Loading Room...',
                    style: Theme.of(context).textTheme.display1);
              }

              // Ok so we have a room
              return getRoomBody(snapshot, roomId);
            }),
      ),
    );
  }

  Column getRoomBody(AsyncSnapshot<Room> snapshot, String roomId) {
    var room = snapshot.data;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Room: ${room.name}',
            style: Theme.of(context).textTheme.display1,
          ),
          Expanded(
            child: new MemberList(
              roomId: roomId,
              showVotes: room.isShowing,
            ),
          ),
          getVotingButtons(room: room),
          getAdminButtons(room: room)
        ]);
  }

  Widget getAdminButtons({Room room}) {
    if (isAdmin(room)) {
      var showHideText = room.isShowing ? "Hide Votes" : "Show Votes";
      return ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text(showHideText),
            onPressed: () async {
              print('toggling');
              await Firestore.instance
                  .document("rooms/${room.id}")
                  .setData({"isShowing": !room.isShowing}, merge: true);
            },
          ),
          RaisedButton(
            child: Text('Clear Votes'),
            onPressed: () async {
              var users = await Firestore.instance
                  .collection("rooms/${room.id}/users")
                  .getDocuments();
              print("Got ${users.documents.length} users");
              users.documents
                  .map((d) => Member.fromMap(d.documentID, d.data))
                  .forEach((m) async => await Firestore.instance
                      .document("rooms/${room.id}/users/${m.id}")
                      .setData({'vote': 0}, merge: true));
            },
          ),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  bool isAdmin(Room room) {
    return widget.userId == room.ownerId;
  }

  Widget getVotingButtons({Room room}) {
    return ButtonBar(
      children: <Widget>[
        RaisedButton(
          child: Text('Vote!'),
          onPressed: () async {
            var result = await Navigator.of(context)
                .push<int>(MaterialPageRoute(builder: (c) => VoteScreen()));
            print("Got result of $result");

            Firestore.instance
                .document("rooms/${widget.roomId}/users/${widget.userId}")
                .setData({'vote': result}, merge: true);
          },
        )
      ],
    );
  }
}

class MemberList extends StatelessWidget {
  const MemberList({Key key, @required this.roomId, @required this.showVotes})
      : super(key: key);

  final String roomId;
  final bool showVotes;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, Member>>(
        stream: Member.getCollectionStream(
            Firestore.instance, 'rooms/$roomId/users'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('No users');
          }

          var members = snapshot.data;
          var tiles = members.values
              .map((m) => MemberTile(member: m, showVote: showVotes))
              .toList();

          return Wrap(
            children: tiles,
          );
        });
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({
    Key key,
    @required this.member,
    @required this.showVote,
  }) : super(key: key);

  final Member member;
  final bool showVote;

  @override
  Widget build(BuildContext context) {
    // return Text(member.name);
    String initial = member.name.toUpperCase().substring(0, 1) ?? "?";
    if (member.vote > 0 && !showVote) initial = "✔";

    String vote = member.vote == 0 ? initial : member.vote.toString();
    String textToShow = showVote ? vote : initial;

    // if (showVote) {
    //     if(member.vote != 0)
    //      //  initial = member.vote.toString();
    // } else {

    // }

    return InkWell(
      onTap: () {
        final snackBar = SnackBar(content: Text(member.name));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          radius: 50,
          child: Text(
            textToShow,
            style: Theme.of(context)
                .textTheme
                .display3
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
