import 'dart:core';
import 'package:flutter/material.dart';
import 'package:fuser/pages/gallery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fuser',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Color(0xffeaeaea),
      ),
      home: Gallery(),
    );
  }
}
