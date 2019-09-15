import 'package:attendance_app/UI/Common/dev_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class StudentNotificationPage extends StatefulWidget {
  final FirebaseMessaging firebaseMessaging;
  StudentNotificationPage({this.firebaseMessaging});
  @override
  _StudentNotificationPageState createState() =>
      _StudentNotificationPageState();
}

class _StudentNotificationPageState extends State<StudentNotificationPage> {
  List<NotificationCard> notifications = new List<NotificationCard>();

  @override
  void initState() {
    super.initState();

    widget.firebaseMessaging.subscribeToTopic("4BCSE");

    widget.firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        setState(() {
          notifications.add(NotificationCard(
            title: message['data']['title'],
            lecturerName: "Lecturer Name",
            messageBody: message['data']['body'],
          ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        setState(() {
          notifications.add(NotificationCard(
            title: message['data']['title'],
            lecturerName: "Lecturer Name",
            messageBody: message['data']['body'],
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        setState(() {
          notifications.add(NotificationCard(
            title: message['data']['title'],
            lecturerName: "Lecturer Name",
            messageBody: message['data']['body'],
          ));
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DevScaffold(
        title: 'NOTIFICATIONS',
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        body: Hero(
          tag: 'notifications',
          child: Scaffold(
            backgroundColor: Color(0xFF24323F),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, int index) {
                    notifications[index].deleteFunction = () {
                      setState(() {
                        notifications.removeAt(index);
                      });
                    };
                    return notifications[index];
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String messageBody;
  final String lecturerName;
  Function deleteFunction;
  NotificationCard({this.title, this.messageBody, this.lecturerName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text("$title - $lecturerName",
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.0),
                Text(messageBody)
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: deleteFunction,
          )
        ],
      ),
    );
  }
}
