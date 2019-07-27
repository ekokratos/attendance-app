import 'package:flutter/material.dart';

class LecturerHome extends StatefulWidget {
  @override
  _LecturerHomeState createState() => _LecturerHomeState();
}

class _LecturerHomeState extends State<LecturerHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0x0E004D99),
          brightness: Brightness.dark,
          elevation: 0,
          leading: IconButton(
              icon: Icon(Icons.exit_to_app),
              iconSize: 36,
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/lecturerLogin', (Route<dynamic> route) => false);
              }),
        ),
        backgroundColor: Color(0xDF004D99),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Hero(
                            tag: 'broadcastText',
                            child: Text(
                              'Broadcast',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.volume_up,
                                color: Colors.black,
                              ),
                              onPressed: null)
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'You can broadcast a message or notification to a particular class.',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      RaisedButton(
                          child: Text(
                            'Send Broadcast',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.lightBlueAccent,
                          onPressed: () {
                            Navigator.pushNamed(context, '/broadcast');
                          })
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Letters',
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 20),
                          ),
                          IconButton(
                              icon: Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              onPressed: () {})
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'You can view letters uploaded by students for leave of absense, permissions, etc.',
                          style: TextStyle(color: Colors.black38),
                        ),
                      ),
                      RaisedButton(
                          child: Text(
                            'Check Letters',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Colors.lightBlueAccent,
                          onPressed: () {
                            Navigator.pushNamed(context, '/letters');
                          })
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
