import 'package:flutter/material.dart';
import 'package:attendance_app/config/index.dart';
import 'package:smart_flare/smart_flare.dart';

class DevScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const DevScaffold({Key key, @required this.body, this.title = ""})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      color: ConfigBloc().darkModeOn ? Colors.black : Color(0xFF24323F),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:
                ConfigBloc().darkModeOn ? Colors.black : Color(0xFF24323F),
            title: Text(title),
            leading: IconButton(
                icon: Icon(Icons.exit_to_app),
                iconSize: 36,
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                }),
            actions: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    height: 10,
                    width: 50,
                    child: ConfigBloc().darkModeOn
                        ? SmartFlareActor(
                            filename: 'assets/animations/day-night.flr',
                            startingAnimation: 'night_idle')
                        : SmartFlareActor(
                            filename: 'assets/day-night.flr',
                            startingAnimation: 'day_idle'),
                  ),
                ),
                onTap: () {
                  ConfigBloc()
                      .dispatch(DarkModeEvent(!ConfigBloc().darkModeOn));
                },
              )
            ],
          ),
          body: body,
        ),
      ),
    );
  }
}
