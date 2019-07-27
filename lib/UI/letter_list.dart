import 'package:flutter/material.dart';

class LetterList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: Icon(Icons.close, size: 36),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
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
        body: Column(
          children: <Widget>[
            letterCard(context),
            letterCard(context),
            letterCard(context)
          ],
        ),
      ),
    );
  }

  Padding letterCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Container(
          height: 160,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Card(
            elevation: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Letter for SIH 2019',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    'Jehad (4SF16CS091)',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  Text(
                    'VIEW',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xDF004D99),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
