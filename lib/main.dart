import 'package:app_english/screens/main_page/home_screen.dart';
import 'package:app_english/screens/main_page/main_scaffold.dart';
import 'package:app_english/screens/welcome_screen.dart';
import 'package:app_english/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App English',
      theme: lightMode,
      home: const MainPage(),
    );
  }
}
