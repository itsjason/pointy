import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/room-screen.dart';
import 'package:progress_dialog/progress_dialog.dart';

class CreateRoomScreen extends StatefulWidget {
  final String userId;

  CreateRoomScreen({Key key, this.userId}) : super(key: key);

  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final textEditingController = TextEditingController();
  final scaffoldKey = GlobalKey();

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
            controller: textEditingController,
            decoration: InputDecoration(hintText: 'What is your name?'),
            autofocus: true,
            style: Theme.of(context).textTheme.display1,
          ),
          SizedBox(height: 30),
          new CreateRoomButton(
              textEditingController: textEditingController, widget: widget)
        ],
      ),
    );
  }
}

class CreateRoomButton extends StatelessWidget {
  const CreateRoomButton({
    Key key,
    @required this.textEditingController,
    @required this.widget,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final CreateRoomScreen widget;

  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);

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
              progressDialog.show();
              var createRoomResult = await CloudFunctions.instance
                  .getHttpsCallable(functionName: 'createRoom')
                  .call({
                'userName': userName
              }); //Actually ignoring the name param for now?
              progressDialog.hide();
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
