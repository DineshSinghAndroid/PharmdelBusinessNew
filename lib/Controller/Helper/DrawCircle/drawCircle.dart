import 'package:flutter/cupertino.dart';

class DrawCircle extends CustomPainter {
  Paint? _paint;
  double? height;
  Offset? offset;

  // DrawCircle(Paint paint, double screenHeight, Offset offset) {
  //   this._paint = paint;
  //   this.height = screenHeight;
  //   this.offset = offset;
  // }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    canvas.drawCircle(offset!, height!, _paint!);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}