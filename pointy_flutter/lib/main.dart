import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pointy_flutter/create-room-screen.dart';
import 'package:pointy_flutter/join-room-screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PointyApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Pointy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String name;
  bool enabled = false;
  String userId;

  _MyHomePageState() {}

  void login() {
    FirebaseAuth.instance.signInAnonymously().then((value) {
      print("FIREBASE: $value");
      if (value != null) {
        setState(() {
          enabled = true;
          userId = value.uid;
        });
      }
    });
  }

  @override
  void initState() {
    login();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle buttonStyle =
        Theme.of(context).textTheme.display3.copyWith(color: Colors.blueAccent);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/finger1.png',
                width: 400,
              ),
              Text('Pointy',
                  style: Theme.of(context).textTheme.display4.copyWith(
                        color: Colors.black,
                      )),
              FlatButton(
                child: Text('Create', style: buttonStyle),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateRoomScreen(
                                userId: userId,
                              )));
                },
              ),
              FlatButton(
                  child: Text('Join', style: buttonStyle),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => JoinRoomScreen(
                                  userId: userId,
                                )));
                  })
            ],
          ),
        ),
      ),
    );
  }
}
