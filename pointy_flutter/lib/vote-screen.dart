import 'package:flutter/material.dart';

class VoteScreen extends StatefulWidget {
  VoteScreen({Key key}) : super(key: key);

  _VoteScreenState createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  static const VotingOptions = [1, 1, 2, 3, 5, 8, 13];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vote'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
              child: Text("What is Your Vote",
                  style: Theme.of(context).textTheme.display1)),
          Wrap(
            alignment: WrapAlignment.center,
            children: VotingOptions.map((o) => InkWell(
                  onTap: () {
                    Navigator.of(context).pop(o);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 50,
                      child: Text(
                        o.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .display3
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                )).toList(),
          ),
        ],
      ),
    );
  }
}
