import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
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
                    Navigator.pushNamed(context, '/studentLogin');
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 110),
                color: Color(0xD0004D99),
                child: Text(
                  'Lecturer',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/lecturerLogin');
                },
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
    Rect rect = new Rect.fromCircle(
      center: new Offset(165.0, 55.0),
      radius: 380.0,
    );

    final Gradient gradient = new LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        const Color(0xC00093E9),
        const Color(0xF580D0C7),
      ],
    );

    // create the Shader from the gradient and the bounding square
    final Paint paint = new Paint()..shader = gradient.createShader(rect);

    var center = Offset(size.width / 2, 0);
    canvas.drawCircle(center, 380.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
