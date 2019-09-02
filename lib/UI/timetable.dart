import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Timetable extends StatefulWidget {
  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  static Color kCol1 = Color(0xFF33658A);
  static Color kCol2 = Color(0xFFA799B7);
  static Color kCol3 = Color(0xFF979B8D);
  static Color kCol4 = Color(0xFF8FC0A9);
  static Color kCol5 = Color(0xFF68B0AB);
  static Color kCol6 = Color(0xFF8DA9C4);

  List<List<String>> subjects = [
    ['aa', '', '', '', '', '', ''],
    ['', '', '', '', '', '', ''],
    ['', '', '', '', '', '', ''],
    ['', '', '', '', '', '', ''],
    ['', '', '', '', '', '', ''],
    ['', '', '', '', '', '', ''],
    ['', '', '', '', '', '', '']
  ];
  List<Color> tileColor = [kCol1, kCol2, kCol3, kCol4, kCol5, kCol6];
  List<String> days = ['Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'];
  String sub;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < 6; i++)
                    Column(
                      children: <Widget>[
                        DayTile(
                          color: tileColor[i],
                          text: days[i],
                        ),
                        for (int j = 0; j < 7; j++)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            TextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  sub = value;
                                                });
                                              },
                                              maxLength: 6,
                                              decoration: InputDecoration(
                                                  labelText: 'Subject'),
                                            ),
                                            RaisedButton(
                                                child: Text('SAVE'),
                                                onPressed: () {
                                                  subjects[i][j] = sub;
                                                  Navigator.of(context).pop();
                                                }),
                                          ]),
                                    );
                                  });
                            },
                            child: SubjectTile(
                                color: tileColor[i], text: subjects[i][j]),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DayTile extends StatelessWidget {
  final Color color;
  final String text;

  @override
  DayTile({this.color = Colors.deepOrangeAccent, this.text = ' '});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FittedBox(
          fit: BoxFit.contain,
          child: Container(
            margin: EdgeInsets.all(2),
            color: color,
            width: 50.0,
            height: 50.0,
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SubjectTile extends StatelessWidget {
  SubjectTile({
    @required this.color,
    @required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Container(
        margin: EdgeInsets.all(2),
        color: color.withOpacity(0.5),
        width: 50.0,
        height: 50.0,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}

//SubjectTile(color: color, text: subjects[0]),
//SubjectTile(color: color, text: subjects[1]),
//SubjectTile(color: color, text: subjects[2]),
//SubjectTile(color: color, text: subjects[3]),
//SubjectTile(color: color, text: subjects[4]),
//SubjectTile(color: color, text: subjects[5]),
//SubjectTile(color: color, text: subjects[6]),
