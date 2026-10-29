import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mobile_virtual_lab/core/math/vector3.dart';

class VectorPainter extends CustomPainter {
  final Vector3 vector;
  final double scale;

  VectorPainter({
    required this.vector,
    this.scale = 40.0,
  });

  Offset _mathToScreen(double x, double y, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    return Offset(
      centerX + x * scale,
      centerY - y * scale,
    );
  }

  static Vector3 screenToMath(Offset screenPos, Size size, double scale) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return Vector3(
      (screenPos.dx - centerX) / scale,
      (centerY - screenPos.dy) / scale,
      0.0,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);
    _drawAxes(canvas, size);
    _drawVector(canvas, size, vector, const Color.fromARGB(255, 63, 2, 41));
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color.fromARGB(255, 198, 187, 187)
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for(double x = centerX % scale; x < size.width; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for(double y = centerY % scale; y < size.height; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawAxes(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = const Color.fromARGB(255, 6, 5, 5)
      ..strokeWidth = 2.0;

    final origin = _mathToScreen(0, 0, size);

    canvas.drawLine(Offset(0, origin.dy), Offset(size.width, origin.dy), axisPaint);
    canvas.drawLine(Offset(origin.dx, 0), Offset(origin.dx, size.height), axisPaint);
  }

  void _drawVector(Canvas canvas, Size size, Vector3 v, Color color) {
    final start = _mathToScreen(0, 0, size);
    final end = _mathToScreen(v.x, v.y, size);

    final vectorPaint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    
    canvas.drawLine(start, end, vectorPaint);

    final angle = math.atan2(start.dy - end.dy, start.dx - end.dx);
    const arrowSize = 12.0;
    const arrowAngle = 0.4;

    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx + arrowSize * math.cos(angle + arrowAngle),
        end.dy + arrowSize * math.sin(angle + arrowAngle),
      )
      ..lineTo(
        end.dx + arrowSize * math.cos(angle - arrowAngle),
        end.dy + arrowSize * math.sin(angle - arrowAngle),
      )
      ..close();

    canvas.drawPath(arrowPath, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant VectorPainter oldDelegate) {
    return oldDelegate.vector != vector || oldDelegate.scale != scale;
  }
}