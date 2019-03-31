import 'package:flutter/material.dart';
import 'package:charging/battery/default_battery.dart';
import 'package:charging/battery/battery_control.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: '无线充电',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BatteryControl control;
  double dl = 0;

  void initState() {
    super.initState();
    control = new BatteryControl();
  }

  void cd() {
    dl = dl + 0.2;
    if (dl > 1) {
      return;
    }
    control.quantity(dl);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              print('1222');
            },
            child: Container(
            margin: EdgeInsets.only(top: 200),
            width: MediaQuery.of(context).size.width * 0.7,
            child: DefaultBattery(control),
          ),
          )
        ],
      ),
    );
  }
}
