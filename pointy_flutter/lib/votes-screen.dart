// import 'dart:math';

// import 'package:flutter/material.dart';

// class VotesScreen extends StatefulWidget {
//   final Map<int, int> voteCounts;

//   VotesScreen({Key key, @required this.voteCounts}) : super(key: key);

//   _VotesScreenState createState() => _VotesScreenState();
// }

// class User {
//   final String initial;
//   final int vote;

//   User({this.initial, this.vote});
// }

// class _VotesScreenState extends State<VotesScreen> {
//   double left = 50;
//   double top = 50;

//   double placeX = 200;
//   double placeY = 300;

//   bool beCool = false;

//   static const double RADIAN = 57.295779513;

//   double getYPositionList(int count, int index, double diameterTotal) {
//     if (!beCool) return 30;

//     var angle = (360 / 5) * index;
//     var radians = angle / RADIAN;
//     var yPos = diameterTotal * sin(radians);
//     print("Index $index, angle $angle, dia $diameterTotal yPos $yPos");
//     return yPos + placeY;
//   }

//   double getXPositionList(int count, int index, double diameterTotal) {
//     if (!beCool) return index * diameterTotal;

//     var angle = (360 / 5) * index;
//     var radians = angle / RADIAN;
//     var xPos = diameterTotal * cos(radians);
//     print("Index $index, angle $angle, dia $diameterTotal xPos $xPos");
//     return placeX + xPos;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> children = List<Widget>();

//     var dots = widget.voteCounts.keys.map((vote) {
//         final count = widget.voteCounts[vote];
//          return StackDot(
//             label: vote.toString(),
//             number: vote,
//             top: getYPositionList(users.length, users.indexOf(u), 60),
//             left: getXPositionList(users.length, users.indexOf(u), 60),
//           )
//         });

//     children.addAll(dots);

//     final moveButton = Positioned(
//       left: 50,
//       bottom: 50,
//       child: RaisedButton(
//         child: Text('Move'),
//         onPressed: () {
//           setState(() {
//             left -= 50.0;
//             top += 50.0;
//             beCool = !beCool;
//           });
//         },
//       ),
//     );

//     final detector = GestureDetector(
//       onTapUp: (tap) {
//         setState(() {
//           print("tap ${tap.localPosition.dx} ${tap.localPosition.dy}");
//           placeX = tap.localPosition.dx;
//           placeY = tap.localPosition.dy;
//         });
//       },
//     );

//     children.addAll([detector, moveButton]);

//     children.add(Positioned(
//       top: placeY,
//       left: placeX,
//       child: Container(
//         width: 10,
//         height: 10,
//         color: Colors.green,
//       ),
//     ));

//     return Container(
//         color: Colors.white,
//         child: Stack(fit: StackFit.expand, children: children));
//   }
// }

// class StackDot extends StatelessWidget {
//   const StackDot({
//     Key key,
//     @required this.label,
//     @required this.number,
//     @required this.left,
//     @required this.top,
//   }) : super(key: key);

//   final String label;
//   final int number;
//   final double left;
//   final double top;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedPositioned(
//       child: Dot(label: label, number: number),
//       height: 50,
//       left: left,
//       top: top,
//       duration: Duration(seconds: 1),
//       curve: Curves.easeInOutCubic,
//     );
//   }
// }

// class Dot extends StatelessWidget {
//   final String label;
//   final int number;
//   Dot({Key key, @required this.label, this.number}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       width: 50,
//       child: CircleAvatar(
//         child: Text(
//           label,
//           style: Theme.of(context).textTheme.display1,
//         ),
//         radius: 50,
//       ),
//     );
//   }
// }
