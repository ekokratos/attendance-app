import 'package:attendance_app/UI/Lecturer/broadcast.dart';
import 'package:attendance_app/UI/Lecturer/lecturer_homepage.dart';
import 'package:attendance_app/UI/Lecturer/lecturer_login.dart';
import 'package:attendance_app/UI/Lecturer/letter_list.dart';
import 'package:attendance_app/UI/Lecturer/letters.dart';
import 'package:attendance_app/UI/Lecturer/report.dart';
import 'package:attendance_app/UI/Student/student_homepage.dart';
import 'package:attendance_app/UI/Student/student_letters.dart';
import 'package:attendance_app/UI/Student/student_login.dart';
import 'package:attendance_app/UI/timetable.dart';
import 'package:attendance_app/UI/welcome_page.dart';
import 'package:attendance_app/utils/attendence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'index.dart';

class ConfigPage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  ConfigBloc configBloc;

  @override
  void initState() {
    super.initState();
    setupApp();
  }

  setupApp() {
    configBloc = ConfigBloc();
    configBloc.darkModeOn =
        Attendance.prefs.getBool(Attendance.darkModePref) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => configBloc,
      child: BlocBuilder<ConfigBloc, ConfigState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Google Devfest',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              //* Custom Google Font
              fontFamily: Attendance.google_sans_family,
              primarySwatch: Colors.red,
              primaryColor: configBloc.darkModeOn ? Colors.black : Colors.white,
              disabledColor: Colors.grey,
              cardColor: configBloc.darkModeOn ? Colors.black : Colors.white,
              canvasColor:
                  configBloc.darkModeOn ? Colors.black : Colors.grey[50],
              brightness:
                  configBloc.darkModeOn ? Brightness.dark : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                  colorScheme: configBloc.darkModeOn
                      ? ColorScheme.dark()
                      : ColorScheme.light()),
              appBarTheme: AppBarTheme(
                elevation: 0.0,
              ),
            ),
            initialRoute: '/studentLogin',
            routes: {
              '/': (context) => WelcomePage(),
              '/studentLogin': (context) => StudentLogin(),
              '/lecturerLogin': (context) => LecturerLogin(),
              '/studentHome': (context) => StudentHome(),
              '/lecturerHome': (context) => LecturerHome(),
              '/letters': (context) => Letters(),
              '/letters_list': (context) => LetterList(),
              '/broadcast': (context) => Broadcast(),
              '/studentLetters': (context) => StudentLetterPage(),
              '/report': (context) => Report(),
              '/timetable': (context) => Timetable()
            },
          );
        },
      ),
    );
  }
}
