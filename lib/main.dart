import 'package:flutter/material.dart';
import 'UI/welcome_page.dart';
import 'UI/login.dart';
import 'UI/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/login': (context) => Login(),
        '/home': (context) => HomePage()
      },
    );
  }
}
