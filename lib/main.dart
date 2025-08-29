import 'package:flutter/material.dart';
import 'package:idea_flow/App/Pages/home_page.dart';
import 'package:idea_flow/App/Pages/test_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.light),
      home: const Homepage(),
    );
  }
}
