import 'package:flutter/material.dart';
import 'package:mobile_virtual_lab/core/math/vector3.dart';
import 'package:mobile_virtual_lab/features/interactive_lab/presentation/renderers/vector_painter.dart';

class InteractiveVectorScreen extends StatefulWidget {
  const InteractiveVectorScreen({super.key});

  @override
  State<InteractiveVectorScreen> createState() => _InteractiveVectorScreenState();
}

class _InteractiveVectorScreenState extends State<InteractiveVectorScreen> {
  Vector3 _currentVector = const Vector3(3.0, 4.0, 0.0);
  final double _scale = 40.0;

  void _updateVectorFromScreen(Offset localPosition, Size canvasSize) {
    setState(() {
      _currentVector = VectorPainter.screenToMath(localPosition, canvasSize, _scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 247, 248),
      appBar: AppBar(
        title: const Text('2D Vector Visualizer'),
        backgroundColor: const Color.fromARGB(255, 95, 18, 73),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final canvasSize = Size(constraints.maxWidth, constraints.maxHeight);

          return Stack(
            children: [
              GestureDetector(
                onPanStart: (details) => _updateVectorFromScreen(details.localPosition, canvasSize),
                onPanUpdate: (details) => _updateVectorFromScreen(details.localPosition, canvasSize),
                child: CustomPaint(
                  size: canvasSize,
                  painter: VectorPainter(
                    vector: _currentVector,
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
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Вектор: V(${_currentVector.x.toStringAsFixed(2)}, ${_currentVector.y.toStringAsFixed(2)})',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Длина |V|: ${_currentVector.length.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 14),
                      ),
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