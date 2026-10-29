import 'package:flutter/material.dart';
import 'package:mobile_virtual_lab/core/math/vector3.dart';
import 'package:mobile_virtual_lab/core/math/ray.dart';
import 'package:mobile_virtual_lab/features/interactive_lab/presentation/renderers/ray_tracing_painter.dart';

class InteractiveRayTracingScreen extends StatefulWidget {
  const InteractiveRayTracingScreen({super.key});

  @override
  State<InteractiveRayTracingScreen> createState() => _InteractiveRayTracingScreenState();
}

class _InteractiveRayTracingScreenState extends State<InteractiveRayTracingScreen> {
  Vector3 _rayOrigin = const Vector3(-4.0, 2.0, 0.0);
  Vector3 _targetPoint = const Vector3(0.0, 0.0, 0.0);
  Vector3 _sphereCenter = const Vector3(1.0, 0.0, 0.0);
  final double _sphereRadius = 2.0;
  final double _scale = 40.0;

  String? _dragTarget;

  void _onPanStart(Offset position, Size size) {
    final touch = RayTracingPainter.screenToMath(position, size, _scale);

    final distOrigin = (touch - _rayOrigin).length;
    final distTarget = (touch - _targetPoint).length;
    final distSphere = (touch - _sphereCenter).length;

    if (distOrigin < 1.2) {
      _dragTarget = 'origin';
    } else if (distTarget < 1.2) {
      _dragTarget = 'target';
    } else if (distSphere < _sphereRadius) {
      _dragTarget = 'sphere';
    } else {
      _dragTarget = null;
    }
  }

  void _onPanUpdate(Offset position, Size size) {
    if (_dragTarget == null) return;

    final touch = RayTracingPainter.screenToMath(position, size, _scale);

    setState(() {
      if (_dragTarget == 'origin') {
        _rayOrigin = touch;
      } else if (_dragTarget == 'target') {
        _targetPoint = touch;
      } else if (_dragTarget == 'sphere') {
        _sphereCenter = touch;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rayDir = (_targetPoint - _rayOrigin).normalized;
    final ray = Ray(origin: _rayOrigin, direction: rayDir);
    final hit = intersectRaySphere(ray, _sphereCenter, _sphereRadius);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 248),
      appBar: AppBar(
        title: const Text('2D Ray Tracing Simulation'),
        backgroundColor: const Color.fromARGB(255, 95, 18, 73),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              GestureDetector(
                onPanStart: (details) => _onPanStart(details.localPosition, canvasSize),
                onPanUpdate: (details) => _onPanUpdate(details.localPosition, canvasSize),
                child: CustomPaint(
                  size: canvasSize,
                  painter: RayTracingPainter(
                    rayOrigin: _rayOrigin,
                    rayDirection: rayDir,
                    sphereCenter: _sphereCenter,
                    sphereRadius: _sphereRadius,
                    scale: _scale,
                  ),
                ),
              ),

              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hit != null ? 'Состояние: ПОПАДАНИЕ (Hit)' : 'Состояние: ПРОМАХ (Miss)',
                        style: TextStyle(
                          color: hit != null ? Colors.greenAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      if (hit != null) ...[
                        Text('Расстояние t: ${hit.t.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white70)),
                        Text('Нормаль N: (${hit.normal.x.toStringAsFixed(2)}, ${hit.normal.y.toStringAsFixed(2)})',
                            style: const TextStyle(color: Colors.greenAccent)),
                      ] else ...[
                        const Text('Перетаскивайте желтый источник или сферу',
                            style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}