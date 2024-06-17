import 'package:flutter/material.dart';
import 'view/screens/lecturer_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Course System',
      home: LecturerListScreen(),
    );
  }
}
