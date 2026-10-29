import 'dart:math' as math;
import 'vector3.dart';

class Ray {
  final Vector3 origin;
  final Vector3 direction;

  Ray({required this.origin, required Vector3 direction})
    : direction = direction.normalized;

  Vector3 pointAt(double t) => origin + direction * t;
}

class HitRecord {
  final double t;
  final Vector3 point;
  final Vector3 normal;

  HitRecord({
    required this.t,
    required this.point,
    required this.normal
  });
}

HitRecord? intersectRaySphere(Ray ray, Vector3 sphereCenter, double radius) {
  final oc = ray.origin - sphereCenter;
  final a = ray.direction.dot(ray.direction);
  final b = 2.0 * oc.dot(ray.direction);
  final c = oc.dot(oc) - radius * radius;

  final discriminant = b * b - 4.0 * a * c;

  if(discriminant < 0) return null;

  final t = (-b - math.sqrt(discriminant)) / (2.0 * a);

  if(t > 0.001) {
    final hitPoint = ray.pointAt(t);
    final normal = (hitPoint - sphereCenter).normalized;
    
    return HitRecord(t: t, point: hitPoint, normal: normal);
  }

  return null;
}