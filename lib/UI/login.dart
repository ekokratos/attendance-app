import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF007DB4),
                            const Color(0xFF26CDFE)
                          ], // whitish to gray
                        ),
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
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 32, horizontal: 20),
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'USN',
                                  suffixIcon: Icon(Icons.person)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16.0, left: 20, right: 20, bottom: 64),
                            child: TextField(
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
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 110),
                            color: Colors.blue,
                            child: Text(
                              'Sign In',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          )
                        ],
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
