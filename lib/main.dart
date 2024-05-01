// Define a class to represent each function template
import 'package:flutter/material.dart';
import 'package:scripter/scripting_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Writing Software',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScriptingPage(),
    );
  }
}
