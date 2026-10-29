import 'package:flutter/material.dart';
import 'features/interactive_lab/presentation/screens/interactive_vector_screen.dart';

void main() {
  runApp(const MobileLabApp());
}

class MobileLabApp extends StatelessWidget {
  const MobileLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Mobile Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const InteractiveVectorScreen(),
    );
  }
}
