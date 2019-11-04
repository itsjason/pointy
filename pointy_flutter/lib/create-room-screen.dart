import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/room-screen.dart';

class CreateRoomScreen extends StatefulWidget {
  final String userId;

  CreateRoomScreen({Key key, this.userId}) : super(key: key);

  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final textEditingController = TextEditingController();
  final scaffoldKey = GlobalKey();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Create A New Room',
        ),
      ),
      body: Center(
        child: getBody(context),
      ),
    );
  }

  Widget getBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            enabled: !isLoading,
            controller: textEditingController,
            decoration: InputDecoration(hintText: 'What is your name?'),
            autofocus: true,
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 30),
          isLoading
              ? _loadingButton()
              : CreateRoomButton(
                  textEditingController: textEditingController,
                  widget: widget,
                  onLoading: () => setState(() => isLoading = true),
                )
        ],
      ),
    );
  }

  Widget _loadingButton() => Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Colors.blueAccent,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Creating the room',
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(width: 10,),
                  CircularProgressIndicator()
                ],
              ),
              onPressed: null,
            ),
          ),
        ],
      );
}

class CreateRoomButton extends StatelessWidget {
  final Function onLoading;

  const CreateRoomButton(
      {Key key,
      @required this.textEditingController,
      @required this.widget,
      @required this.onLoading})
      : super(key: key);

  final TextEditingController textEditingController;
  final CreateRoomScreen widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: RaisedButton(
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              'Create That Room!',
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontSize: 20, color: Colors.white),
            ),
            onPressed: () async {
              var userName = textEditingController.value.text;

              if (userName.length < 2) {
                final snackBar = SnackBar(
                    content: Text(
                        "Come on, your name is only ${userName.length} letters long??"));
                Scaffold.of(context).showSnackBar(snackBar);
                return;
              }

              onLoading();
              var createRoomResult = await CloudFunctions.instance
                  .getHttpsCallable(functionName: 'createRoom')
                  .call({
                'userName': userName
              }); //Actually ignoring the name param for now?
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
    );
  }
}
