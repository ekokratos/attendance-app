import 'package:flutter/material.dart';
import 'UI/welcome_page.dart';
import 'UI/Student/student_login.dart';
import 'UI/Student/student_homepage.dart';
import 'UI/Lecturer/lecturer_login.dart';
import 'UI/Lecturer/lecturer_homepage.dart';
import 'UI/Lecturer/letters.dart';
import 'UI/Lecturer/letter_list.dart';
import 'UI/Lecturer/broadcast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomePage(),
        '/studentLogin': (context) => StudentLogin(),
        '/lecturerLogin': (context) => LecturerLogin(),
        '/studentHome': (context) => StudentHome(),
        '/lecturerHome': (context) => LecturerHome(),
        '/letters': (context) => Letters(),
        '/letters_list': (context) => LetterList(),
        '/broadcast': (context) => Broadcast(),
      },
    );
  }
}
