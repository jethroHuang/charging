import 'package:charging/battery/battery_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class DefaultBattery extends StatefulWidget {
  final BatteryControl control;

  const DefaultBattery(this.control);

  @override
  _DefaultBatteryState createState() => _DefaultBatteryState();
}

class _DefaultBatteryState extends State<DefaultBattery>
    with TickerProviderStateMixin {
  double _quantity;
  AnimationController _controller;
  double _animationQuantity = 0;

  void initState() {
    super.initState();
    _quantity = widget.control.value;
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    Animation<double> doubleAnim;

    _controller..addListener(() {
      if (doubleAnim != null) {
        _animationQuantity = doubleAnim.value;
      }
      setState(() {});
    })..addStatusListener((status){
      if(status==AnimationStatus.forward){
        widget.control.setState(ChargingState.charging);
      }else if(status==AnimationStatus.dismissed){
        widget.control.setState(ChargingState.chargingEnd);
      }
    });

    widget.control.setListener((value) {
      doubleAnim = Tween(begin: _quantity,end: value).animate(
        CurvedAnimation(parent: _controller,curve: Curves.easeIn)
      );
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CustomPaint(
        painter: DefaultBatteryPainter(Colors.red, _animationQuantity),
      ),
    );
  }
}

class DefaultBatteryPainter extends CustomPainter {
  final Color _bodyColor; // 电量得颜色
  final double _amount;
  static const double _padding = 3; // 电量和边框的边距
  static const double _topWidth = 6; // 电池冒的宽度
  static const double _strokeWidth = 4; // 电池边框的宽度

  const DefaultBatteryPainter(this._bodyColor, this._amount)
      : assert(_amount >= 0 && _amount <= 1);

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制电池边框
    var strokePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    double height = size.width * 0.5;
    double width = size.width;
    Rect strokeRect = Rect.fromLTWH(
        _strokeWidth / 2,
        _strokeWidth / 2 - height / 2,
        width - _strokeWidth - _topWidth,
        height);
    RRect rRect;
    rRect = RRect.fromRectAndRadius(strokeRect, const Radius.circular(8));
    canvas.drawRRect(rRect, strokePaint);

    // 绘制电池冒
    double _topHeight = height * 0.3;
    double dx = width - _strokeWidth / 2 + (_topWidth - _strokeWidth - 1);
    strokePaint.strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(dx, 0 - _topHeight), Offset(dx, _topHeight), strokePaint);

    //绘制电量
    double dleft = _strokeWidth + _padding; // 左上角的点
    double dtop = -height / 2 + _strokeWidth + _padding;
    double dwidth =
        size.width - _strokeWidth * 2 - _padding * 2 - _topWidth; //宽度
    dwidth = dwidth * _amount; //依据电量百分比来计算宽度
    double dheight = height - _strokeWidth - _padding * 2; //高度
    Paint dPaint = Paint()
      ..color = _bodyColor
      ..style = PaintingStyle.fill;
    Rect drect = Rect.fromLTWH(dleft, dtop, dwidth, dheight);
    RRect dRRect;
    if (_amount == 1) {
      dRRect = RRect.fromRectAndRadius(drect, const Radius.circular(4));
    } else {
      dRRect = RRect.fromRectAndCorners(drect,
          topLeft: Radius.circular(4),
          bottomLeft: const Radius.circular(4),
          topRight: Radius.circular(2),
          bottomRight: const Radius.circular(2));
    }
    canvas.drawRRect(dRRect, dPaint);
  }

  @override
  bool shouldRepaint(DefaultBatteryPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(DefaultBatteryPainter oldDelegate) => false;
}
