import 'package:flutter/material.dart';

class StudentAttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF24323F),
        appBar: AppBar(
          backgroundColor: Color(0xFF24323F),
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('ATTENDANCE'),
        ),
      ),
    );
  }
}
