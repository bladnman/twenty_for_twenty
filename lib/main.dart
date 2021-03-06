import 'package:flutter/material.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/DotSelection.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/Simple.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/Animated.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/AnimatedDrop.dart';
import 'package:twenty_for_twenty/screens/touch-swarm/SimpleChain.dart';

final drawerItems = [
  new DrawerItem("Simple Chain", Icons.touch_app, SimpleChain()),
  new DrawerItem("DotSelection", Icons.touch_app, DotSelection()),
  new DrawerItem("Drop", Icons.arrow_downward, AnimatedDrop()),
  new DrawerItem("Animated", Icons.donut_large, Animated()),
  new DrawerItem("Simple", Icons.blur_circular, Simple()),
];

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
      home: HomePage(),
    );
  }
}

class DrawerItem {
  String title;
  IconData icon;
  var page;
  DrawerItem(this.title, this.icon, this.page);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: new Icon(d.icon),
        title: new Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(drawerItems[_selectedDrawerIndex].title),
      ),
      body: drawerItems[_selectedDrawerIndex].page,
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Experiments',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
    );
  }
}
