import 'package:flutter/material.dart';
import 'package:extended_math/extended_math.dart';
import 'package:twenty_for_twenty/screens/CircleFun.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  doCalc() {
    for (var blockCount = 365; blockCount <= 366; blockCount++) {
      final q = QuadraticEquation(b: 1, c: -2 * blockCount);
      print('[$blockCount] ${q.calculate()}');
    }
  }

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
