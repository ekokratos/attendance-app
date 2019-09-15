import 'package:attendance_app/UI/Common/dev_scaffold.dart';
import 'package:attendance_app/bloc/config/config_bloc.dart';
import 'package:attendance_app/utils/custom_navigation.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'student_letters.dart';
import 'student_attendance.dart';
import 'student_marks.dart';
import 'student_notifications.dart';

class StudentHome extends StatefulWidget {
  final String usn;
  final String section;

  StudentHome({this.usn = '4SF16CS091', this.section = 'B'});

  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  bool onFABPressed = false;

  String animation = "day_idle";

  final _firestore = Firestore.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List notifications = List();

  Future<String> filePath;

  @override
  Widget build(BuildContext context) {
    int year =
        DateTime.now().year - int.parse('20' + widget.usn.substring(3, 5));
    String branch = widget.usn.substring(5, 7);
    _firebaseMessaging.subscribeToTopic("4BCSE");
    return SafeArea(
      child: DevScaffold(
        leading: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 36,
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            }),
        body: Scaffold(
          backgroundColor:
              ConfigBloc().darkModeOn ? Colors.black : Color(0xFF24323F),
          body: Stack(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: buildCard(
                              beginColor: Color(0xFFFE7649),
                              endColor: Color(0xFFF4336E),
                              text: 'ATTENDANCE',
                              tag: 'attendance',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentAttendancePage()));
                              }),
                        ),
                        if (onFABPressed)
                          SizedBox(
                            width: 10,
                          ),
                        Expanded(
                          child: buildCard(
                              beginColor: Color(0xFF45C7FF),
                              endColor: Color(0xFF1250F4),
                              text: 'MARKS',
                              tag: 'marks',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentMarksPage()));
                              }),
                        ),
                      ],
                    ),
                  ),
                  if (onFABPressed)
                    SizedBox(
                      height: 10,
                    ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: buildCard(
                              beginColor: Color(0xFF45C7FF),
                              endColor: Color(0xFF1250F4),
                              text: 'LETTERS',
                              tag: 'letters',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudentLetterPage(
                                          firestore: _firestore,
                                          usn: widget.usn,
                                          branch: branch,
                                          year: year.toString(),
                                          section: widget.section)),
                                );
                              }),
                        ),
                        if (onFABPressed)
                          SizedBox(
                            width: 10,
                          ),
                        Expanded(
                          child: buildCard(
                              beginColor: Color(0xFFFE7649),
                              endColor: Color(0xFFF4336E),
                              text: 'NOTIFICATIONS',
                              tag: 'notifications',
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentNotificationPage(
                                              firebaseMessaging:
                                                  _firebaseMessaging,
                                            )));
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Draggable(
                  onDragStarted: () {
                    setState(() {
                      onFABPressed = true;
                    });
                  },
                  feedback: FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(Icons.add),
                      onPressed: () {}),
                  childWhenDragging: Container(),
                  onDragEnd: (position) {
                    setState(() {
                      onFABPressed = false;
                    });
                    DraggableNavigation(
                        context: context,
                        position: position,
                        firebaseMessaging: _firebaseMessaging);
                  },
                  child: FloatingActionButton(
                    backgroundColor: Colors.black,
                    child: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        if (onFABPressed)
                          onFABPressed = false;
                        else
                          onFABPressed = true;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildCard(
      {Color beginColor,
      Color endColor,
      String text,
      Function onTap,
      String tag}) {
    return GestureDetector(
      child: Hero(
        tag: tag,
        child: Container(
          decoration: BoxDecoration(
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
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}

class DraggableNavigation {
  final DraggableDetails position;
  final BuildContext context;
  final FirebaseMessaging firebaseMessaging;
  DraggableNavigation({this.position, this.context, this.firebaseMessaging}) {
    if (position.offset.dx < (MediaQuery.of(context).size.width * 0.5) &&
        position.offset.dy < (MediaQuery.of(context).size.height * 0.5)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StudentAttendancePage()));
    }
    if (position.offset.dx > (MediaQuery.of(context).size.width * 0.5) &&
        position.offset.dy < (MediaQuery.of(context).size.height * 0.5)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StudentMarksPage()));
    }
    if (position.offset.dx < (MediaQuery.of(context).size.width * 0.5) &&
        position.offset.dy > (MediaQuery.of(context).size.height * 0.5)) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StudentLetterPage()));
    }
    if (position.offset.dx > (MediaQuery.of(context).size.width * 0.5) &&
        position.offset.dy > (MediaQuery.of(context).size.height * 0.5)) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentNotificationPage(
                    firebaseMessaging: firebaseMessaging,
                  )));
    }
  }
}
