import 'package:firebase_connection_1/pages/home_page.dart';
import 'package:firebase_connection_1/pages/sign_in_page.dart';
import 'package:firebase_connection_1/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: HomePage(),
    );
  }
}