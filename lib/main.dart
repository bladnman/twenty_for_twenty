import 'package:flutter/material.dart';
import 'package:extended_math/extended_math.dart';
// import 'package:twenty_for_twenty/screens/touch-swarm/immediate/CircleFun.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/animated-first/CircleFun.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CircleFun(),
    );
  }
}
