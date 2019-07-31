import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'student_letters.dart';
import 'student_attendance.dart';
import 'student_marks.dart';
import 'student_notifications.dart';

class StudentHome extends StatelessWidget {
  final String usn;
  final String section;
  StudentHome({this.usn = '4SF16CS091', this.section = 'B'});

  final _firestore = Firestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List notifications = List();

  Future<String> filePath;

  @override
  Widget build(BuildContext context) {
    int year = DateTime.now().year - int.parse('20' + usn.substring(3, 5));
    String branch = usn.substring(5, 7);
    _firebaseMessaging.subscribeToTopic("4BCSE");
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF24323F),
        appBar: AppBar(
          backgroundColor: Color(0xFF24323F),
          leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 36,
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/studentLogin', (Route<dynamic> route) => false);
              }),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.calendar_today,
                size: 32,
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildCard(
                    beginColor: Color(0xFFFE7649),
                    endColor: Color(0xFFF4336E),
                    text: 'ATTENDANCE',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentAttendance()));
                    }),
                buildCard(
                    beginColor: Color(0xFF45C7FF),
                    endColor: Color(0xFF1250F4),
                    text: 'MARKS',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentMarks()));
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildCard(
                    beginColor: Color(0xFF45C7FF),
                    endColor: Color(0xFF1250F4),
                    text: 'LETTERS',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LetterSectionDetailView(
                                firestore: _firestore,
                                usn: usn,
                                branch: branch,
                                year: year.toString(),
                                section: section)),
                      );
                    }),
                buildCard(
                    beginColor: Color(0xFFFE7649),
                    endColor: Color(0xFFF4336E),
                    text: 'NOTIFICATIONS',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NotificationSectionDetailView(
                                    firebaseMessaging: _firebaseMessaging,
                                  )));
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector buildCard(
      {Color beginColor, Color endColor, String text, Function onTap}) {
    return GestureDetector(
      child: Container(
        height: 240,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                beginColor,
                endColor,
              ]),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
