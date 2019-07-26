import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomPaint(
          painter: ShapesPainter(),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Center(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Text(
                  'Sign in as a',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 120.0, bottom: 50.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                  color: Colors.blue,
                  child: Text(
                    'Student',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                color: Color(0xFF2755B7),
                child: Text(
                  'Lecturer',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.blue;
    var center = Offset(size.width / 2, 0);
    canvas.drawCircle(center, 380.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
