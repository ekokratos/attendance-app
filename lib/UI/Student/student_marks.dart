import 'package:attendance_app/UI/Common/dev_scaffold.dart';
import 'package:attendance_app/bloc/config/config_bloc.dart';
import 'package:flutter/material.dart';

class StudentMarksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DevScaffold(
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: 'MARKS',
        body: Hero(
          tag: 'marks',
          child: Scaffold(
            backgroundColor:
                ConfigBloc().darkModeOn ? Colors.black : Color(0xFF24323F),
          ),
        ),
      ),
    );
  }
}
