import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pointy_flutter/create-room-screen.dart';

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
  
  void onAuthenticationComplete() {
    Firestore.instance
        .collection('rooms')
        .add({'name': 'Test Room 2 Again', 'creator': name}).then((doc) {
      print('Saved doc: ${doc.documentID}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle buttonStyle = Theme.of(context).textTheme.display3.copyWith(color: Colors.blueAccent);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 60,),
            Image.asset('assets/finger1.png', width: 400, ),
            Text('Pointy', style: Theme.of(context).textTheme.display4.copyWith(color: Colors.black, )),
            SizedBox(height: 40,),
            FlatButton(child: Text('Create', style: buttonStyle), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRoomScreen())
              );
            },),
            SizedBox(height: 40,),
            FlatButton(child: Text('Join', style: buttonStyle), onPressed: () {},)
          ],
        ),
      ),
    );
  }
}
