import 'package:flutter/material.dart';

class LecturerLogin extends StatefulWidget {
  @override
  _LecturerLoginState createState() => _LecturerLoginState();
}

class _LecturerLoginState extends State<LecturerLogin> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xDF004D99),
                      ),
                      child: Center(
                        child: Container(
                          height: 140,
                          width: 140,
                          child: Card(
                            child: Icon(
                              Icons.school,
                              color: Colors.blue,
                              size: 80,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      color: Colors.white,
                    )
                  ],
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: MediaQuery.of(context).size.width * 0.05,
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextField(
                              decoration: InputDecoration(
                                  labelText: 'UID',
                                  suffixIcon: Icon(Icons.person)),
                            ),
                            TextField(
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      setState(() {
                                        if (obscureText)
                                          obscureText = false;
                                        else
                                          obscureText = true;
                                      });
                                    },
                                  )),
                            ),
                            Hero(
                              tag: 'lecturerButton',
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(
                                    vertical: 18, horizontal: 95),
                                color: Color(0xDF004D99),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/lecturerHome');
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
