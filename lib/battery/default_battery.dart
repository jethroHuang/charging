import 'package:charging/battery/battery_control.dart';
import 'package:flutter/material.dart';

class DefaultBattery extends StatefulWidget {
  final BatteryControl control;

  const DefaultBattery(this.control);

  @override
  _DefaultBatteryState createState() => _DefaultBatteryState();
}

class _DefaultBatteryState extends State<DefaultBattery> {
  double _quantity;

  void initState() {
    super.initState();
    _quantity = widget.control.value;
    widget.control.setListener((value) {
      setState(() {
        _quantity = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: DefaultBatteryPainter(Colors.green),
      ),
    );
  }
}

class DefaultBatteryPainter extends CustomPainter {
  final Color _bodyColor; // 电量得颜色
  static const double _padding = 2; // 电量和边框得边距
  static const double _topWidth = 6; // 电池冒得宽度
  static const double _strokeWidth = 4; // 电池得宽度

  const DefaultBatteryPainter(this._bodyColor);

  @override
  void paint(Canvas canvas, Size size) {
    var strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;

    double height = size.width * 0.5;
    double width = size.width;
    Rect strokeRect = Rect.fromLTWH(
        0 + _strokeWidth / 2,
        0 + _strokeWidth / 2 - height / 2,
        width - _strokeWidth - _topWidth,
        height);
    RRect rRect = RRect.fromRectAndRadius(strokeRect, Radius.circular(8));
    canvas.drawRRect(rRect, strokePaint);

    double _topHeight = height * 0.3;

    double dx = width - _strokeWidth / 2 + (_topWidth-_strokeWidth);
    canvas.drawLine(
        Offset(dx, 0-_topHeight),
        Offset(dx, _topHeight),
        strokePaint);
  }

  @override
  bool shouldRepaint(DefaultBatteryPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DefaultBatteryPainter oldDelegate) => false;
}
