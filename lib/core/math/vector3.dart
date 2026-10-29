import 'dart:math' as math;

class Vector3 {
  final double x;
  final double y;
  final double z;

  const Vector3(this.x, this.y, this.z);

  const Vector3.zero() : x = 0.0, y = 0.0, z = 0.0;
  const Vector3.all(double value) : x = value, y = value, z = value;

  Vector3 operator+ (Vector3 other) => Vector3(x + other.x, y + other.y, z + other.z);
  Vector3 operator- (Vector3 other) => Vector3(x - other.x, y - other.y, z - other.z);
  Vector3 operator- () => Vector3(-x, -y, -z);

  Vector3 operator* (double scalar) => Vector3(x * scalar, y * scalar, z * scalar);
  Vector3 operator/ (double scalar) => Vector3(x / scalar, y / scalar, z / scalar);

  double get lengthSquared => x * x + y * y + z * z;
  double get length => math.sqrt(lengthSquared);

  Vector3 get normalized {
    final len = length;
    if(len == 0.0) return const Vector3.zero();
    return this / len;
  }

  double dot(Vector3 other) => x * other.x + y * other.y + z * other.z;

  Vector3 cross (Vector3 other) => Vector3(
    y * other.z - z * other.y,
    z * other.x - x * other.z,
    x * other.y - y * other.x
  );

  Vector3 multiplyComponents(Vector3 other) => Vector3(x * other.x, y * other.y, z * other.z);

  Vector3 reflect(Vector3 normal) {
    return this - normal * (2.0 * dot(normal));
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is Vector3 && 
      runtimeType == other.runtimeType &&
      x == other.x &&
      y == other.y &&
      z == other.z;

  @override
  int get hashCode => Object.hash(x, y, z);

  @override
  String toString() => 'Vector3($x, $y, $z)';
}