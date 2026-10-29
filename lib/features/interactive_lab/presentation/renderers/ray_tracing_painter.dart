import 'package:flutter/material.dart';
import 'package:mobile_virtual_lab/core/math/vector3.dart';
import 'package:mobile_virtual_lab/core/math/ray.dart';

class RayTracingPainter extends CustomPainter {
  final Vector3 rayOrigin;
  final Vector3 rayDirection;
  final Vector3 sphereCenter;
  final double sphereRadius;
  final double scale;

  RayTracingPainter({
    required this.rayOrigin,
    required this.rayDirection,
    required this.sphereCenter,
    required this.sphereRadius,
    this.scale = 40.0,
  });

  Offset _mathToScreen(double x, double y, Size size) {
    return Offset(
      size.width / 2 + x * scale,
      size.height / 2 - y * scale,
    );
  }

  static Vector3 screenToMath(Offset screenPos, Size size, double scale) {
    return Vector3(
      (screenPos.dx - size.width / 2) / scale,
      (size.height / 2 - screenPos.dy) / scale,
      0.0,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawGrid(canvas, size);

    final ray = Ray(origin: rayOrigin, direction: rayDirection);
    final hit = intersectRaySphere(ray, sphereCenter, sphereRadius);

    _drawSphere(canvas, size);

    if (hit != null) {
      _drawLine(canvas, size, ray.origin, hit.point, Colors.yellowAccent, 2.5);

      final hitScreen = _mathToScreen(hit.point.x, hit.point.y, size);
      canvas.drawCircle(hitScreen, 6.0, Paint()..color = Colors.redAccent);

      final normalEnd = hit.point + hit.normal * 1.2;
      _drawLine(canvas, size, hit.point, normalEnd, Colors.greenAccent, 2.0);

      final reflectedDir = ray.direction.reflect(hit.normal);
      final reflectedRay = Ray(origin: hit.point, direction: reflectedDir);
      final reflectEnd = reflectedRay.pointAt(5.0);
      _drawLine(canvas, size, hit.point, reflectEnd, Colors.cyanAccent, 2.0);
    //} else {
    //  final missEnd = ray.pointAt(15.0);
    //  _drawLine(canvas, size, ray.origin, missEnd, Colors.yellowAccent.withOpacity(0.5), 2.0);
    }

    final originScreen = _mathToScreen(rayOrigin.x, rayOrigin.y, size);
    canvas.drawCircle(originScreen, 8.0, Paint()..color = Colors.orangeAccent);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (double x = centerX % scale; x < size.width; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = centerY % scale; y < size.height; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawSphere(Canvas canvas, Size size) {
    final center = _mathToScreen(sphereCenter.x, sphereCenter.y, size);
    final radiusPx = sphereRadius * scale;

    final spherePaint = Paint()
      ..color = Colors.indigo
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.indigoAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radiusPx, spherePaint);
    canvas.drawCircle(center, radiusPx, strokePaint);
  }

  void _drawLine(Canvas canvas, Size size, Vector3 start, Vector3 end, Color color, double width) {
    final p1 = _mathToScreen(start.x, start.y, size);
    final p2 = _mathToScreen(end.x, end.y, size);
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(covariant RayTracingPainter oldDelegate) {
    return oldDelegate.rayOrigin != rayOrigin ||
        oldDelegate.rayDirection != rayDirection ||
        oldDelegate.sphereCenter != sphereCenter;
  }
}