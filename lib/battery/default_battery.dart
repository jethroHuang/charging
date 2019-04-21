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
  Color _color = Colors.red;

  void initState() {
    super.initState();
    _quantity = widget.control.value;
    _controller = AnimationController(
        duration: Duration(milliseconds: 1500), vsync: this);
    Animation<double> doubleAnim;
    Animation<Color> colorAnim;

    _controller
      ..addListener(() {
        setState(() {
          _color = colorAnim.value;
          _animationQuantity = doubleAnim.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.forward) {
          widget.control.setState(ChargingState.charging);
        } else if (status == AnimationStatus.dismissed) {
          widget.control.setState(ChargingState.chargingEnd);
        }
      });

    widget.control.setListener((value) {
      doubleAnim = Tween(begin: _animationQuantity, end: value)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      Color endColor;
      if (value <= 0.2) {
        endColor = Colors.red;
      } else if (value < 0.8) {
        endColor = Colors.yellow;
      } else {
        endColor = Colors.green;
      }
      colorAnim = ColorTween(begin: _color, end: endColor)
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width*0.7;
    var height = width*0.5;
    return Container(
      child: CustomPaint(
        painter: DefaultBatteryPainter(_color, _animationQuantity),
        size: Size(width, height),
      ),
    );
  }
}

class DefaultBatteryPainter extends CustomPainter {
  final Color _bodyColor; // 电量得颜色
  final double _amount; //电量
  static const double _padding = 3; // 电量和边框的边距
  static const double _topWidth = 10; // 电池冒的宽度
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
    double height = size.height;
    double width = size.width;
    Rect strokeRect = Rect.fromLTWH(
        _strokeWidth/2,
        _strokeWidth/2,
        width-_strokeWidth-_topWidth,
        height-_strokeWidth);
    RRect rRect;
    rRect = RRect.fromRectAndRadius(strokeRect, const Radius.circular(8));
    canvas.drawRRect(rRect, strokePaint);

    // // 绘制电池冒
    double _topHeight = height * 0.3;
    double dx = width - _topWidth +_strokeWidth/2+3;
    strokePaint.strokeCap = StrokeCap.round;
    canvas.drawLine(
        Offset(dx, height/2-_topHeight), Offset(dx,height/2+_topHeight ), strokePaint);

    //绘制电量
    double dleft = _strokeWidth + _padding; // 左上角的点
    double dtop =  _strokeWidth + _padding;
    double dwidth =
        size.width - _strokeWidth * 2 - _padding * 2 - _topWidth; //宽度
    dwidth = dwidth * _amount; //依据电量百分比来计算宽度
    double dheight = height - _strokeWidth*2 - _padding * 2; //高度
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
  bool shouldRepaint(DefaultBatteryPainter oldDelegate) =>
      oldDelegate._amount != _amount;

  @override
  bool shouldRebuildSemantics(DefaultBatteryPainter oldDelegate) => false;
}
