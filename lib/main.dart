import 'package:flutter/material.dart';
import 'package:charging/battery/default_battery.dart';
import 'package:charging/battery/battery_control.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '无线充电',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BatteryControl control;

  void initState() {
    super.initState();
    control = new BatteryControl();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 200),
        width: MediaQuery.of(context).size.width * 0.7,
        child: DefaultBattery(control),
      ),
    );
  }
}
