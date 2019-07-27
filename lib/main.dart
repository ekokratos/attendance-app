import 'package:flutter/material.dart';
import 'UI/welcome_page.dart';
import 'UI/student_login.dart';
import 'UI/home_page.dart';
import 'package:attendance_app/UI/LecturerLogin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => WelcomePage(),
        '/studentLogin': (context) => StudentLogin(),
        '/lecturerLogin': (context) => LecturerLogin(),
        '/home': (context) => HomePage()
      },
    );
  }
}
