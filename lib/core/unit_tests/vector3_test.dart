import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_virtual_lab/core/math/vector3.dart';

void main() {
  group('Vector3 Arithmetic', () {
    test('Addition, subtraction and negation', () {
      const v1 = Vector3(1.0, 2.0, 3.0);
      const v2 = Vector3(4.0, 5.0, 6.0);

      expect(v1 + v2, equals(Vector3(5.0, 7.0, 9.0)));
      expect(v2 - v1, equals(Vector3(3.0, 3.0, 3.0)));
      expect(-v1, equals(Vector3(-1.0, -2.0, -3.0)));
    });

    test('Scalar multiplication and division', () {
      const v = Vector3(2.0, -4.0, 8.0);

      expect(v * 2.0, Vector3(4.0, -8.0, 16.0));
      expect(v / 2.0, Vector3(1.0, -2.0, 4.0));
    });
  });

  group('Vector3 Geometry', () {
    test('Length and normalization', () {
      const v = Vector3(0.0, 3.0, 4.0);

      expect(v.lengthSquared, equals(25.0));
      expect(v.length, equals(5.0));
      expect(v.normalized, equals(const Vector3(0.0, 0.6, 0.8)));
    });

    test('Dot product', () {
      const v1 = Vector3(1.0, 2.0, 3.0);
      const v2 = Vector3(4.0, -5.0, 6.0);

      expect(v1.dot(v2), equals(12.0));
    });

    test('Cross product', () {
      const i = Vector3(1.0, 0.0, 0.0);
      const j = Vector3(0.0, 1.0, 0.0);

      expect(i.cross(j), equals(const Vector3(0.0, 0.0, 1.0)));
    });

    test('Vector reflection', () {
      const ray = Vector3(1.0, -1.0, 0.0);
      const normal = Vector3(0.0, 1.0, 0.0);

      expect(ray.reflect(normal), equals(const Vector3(1.0, 1.0, 0.0)));
    });
  });
}