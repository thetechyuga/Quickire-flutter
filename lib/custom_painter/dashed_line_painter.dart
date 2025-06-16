import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final Color strokeColor;

  DashedLinePainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 2.5, startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }

    var dotPaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, size.height), 5, dotPaint);
  }

  @override
  bool shouldRepaint(DashedLinePainter oldDelegate) => false;
}
