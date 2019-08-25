// This is likely all your InheritedWidget will ever need.
import 'package:flutter/material.dart';

class AppState extends InheritedWidget {
  // The data is whatever this widget is passing down.
  final String userId;

  // InheritedWidgets are always just wrappers.
  // So there has to be a child,
  // Although Flutter just knows to build the Widget thats passed to it
  // So you don't have have a build method or anything.
  AppState({
    Key key,
    @required this.userId,
    @required Widget child,
  }) : super(key: key, child: child);

  // This is a better way to do this, which you'll see later.
  // But basically, Flutter automatically calls this method when any data
  // in this widget is changed.
  // You can use this method to make sure that flutter actually should
  // repaint the tree, or do nothing.
  // It helps with performance.
  @override
  bool updateShouldNotify(AppState old) => true;
}