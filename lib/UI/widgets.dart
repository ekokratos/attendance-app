import 'package:flutter/material.dart';
import 'sections.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

const double kSectionIndicatorWidth = 32.0;

// The card for a single section. Displays the section's gradient and background image.
class SectionCard extends StatelessWidget {
  const SectionCard({Key key, @required this.section})
      : assert(section != null),
        super(key: key);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: section.title,
      button: true,
      child: DecoratedBox(
          decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            section.leftColor,
            section.rightColor,
          ],
        ),
      )),
    );
  }
}

// The title is rendered with two overlapping text widgets that are vertically
// offset a little. It's supposed to look sort-of 3D.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    @required this.section,
    @required this.scale,
    @required this.opacity,
  })  : assert(section != null),
        assert(scale != null),
        assert(opacity != null && opacity >= 0.0 && opacity <= 1.0),
        super(key: key);

  final Section section;
  final double scale;
  final double opacity;

  static const TextStyle sectionTitleStyle = TextStyle(
    fontFamily: 'Raleway',
    inherit: false,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    textBaseline: TextBaseline.alphabetic,
  );

  static final TextStyle sectionTitleShadowStyle = sectionTitleStyle.copyWith(
    color: const Color(0x19000000),
  );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: Transform(
          transform: Matrix4.identity()..scale(scale),
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 4.0,
                child: Text(section.title, style: sectionTitleShadowStyle),
              ),
              Text(section.title, style: sectionTitleStyle),
            ],
          ),
        ),
      ),
    );
  }
}

// Small horizontal bar that indicates the selected section.
class SectionIndicator extends StatelessWidget {
  const SectionIndicator({Key key, this.opacity = 1.0}) : super(key: key);

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: kSectionIndicatorWidth,
        height: 3.0,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

// Display a single SectionDetail.
class AttendanceSectionDetailView extends StatelessWidget {
  final AttendanceDetail detail;
  AttendanceSectionDetailView({this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    detail.subject,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      detail.subjectCode,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    Text(
                      '${detail.percentage.floor().toString()} %',
                      style: TextStyle(
                          color: detail.percentage.floor() > 85
                              ? Colors.green
                              : Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: LinearPercentIndicator(
                    animation: true,
                    lineHeight: 25.0,
                    animationDuration: 2000,
                    percent: detail.percentage / 100,
                    center: Text(
                      '${detail.attendedClasses}/${detail.numOfClasses}',
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    linearGradient: detail.percentage.floor() > 85
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF60FE26),
                              const Color(0xFFB9FF2C)
                            ],
                          )
                        : LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFF0045),
                              const Color(0xFFFF2C71)
                            ],
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MarksSectionDetailView extends StatelessWidget {
  final MarksDetail detail;
  MarksSectionDetailView({this.detail});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    detail.subject,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 160,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'IA1',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          Text(
                            'IA2',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          Text(
                            'IA3',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'Average',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              detail.firstIA != -1
                                  ? detail.firstIA.toString()
                                  : 'AB',
                              style: TextStyle(
                                  color: detail.firstIA != -1
                                      ? Colors.orange
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            Text(
                              detail.secondIA != -1
                                  ? detail.secondIA.toString()
                                  : 'AB',
                              style: TextStyle(
                                  color: detail.secondIA != -1
                                      ? Colors.orange
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                            Text(
                              detail.thirdIA != -1
                                  ? detail.thirdIA.toString()
                                  : 'AB',
                              style: TextStyle(
                                  color: detail.thirdIA != -1
                                      ? Colors.orange
                                      : Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          detail.average != -1
                              ? detail.average.floor().toString()
                              : 'AB',
                          style: TextStyle(
                              color: detail.average != -1 &&
                                      detail.average.floor() > 7
                                  ? Colors.orange
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
class LetterSectionDetailView extends StatefulWidget {
  final Firestore firestore;
  final String usn;
  final String year;
  final String branch;
  final String section;
  LetterSectionDetailView(
      {this.firestore, this.branch, this.year, this.section, this.usn});
  @override
  _LetterSectionDetailViewState createState() =>
      _LetterSectionDetailViewState();
}

class _LetterSectionDetailViewState extends State<LetterSectionDetailView> {
  /// --------------------------------------------------------------------------
  List<List<Row>> textFields = [[]]; // TODO: Shreyas fix these
  List<List<TextEditingController>> textFieldController = [[]];
  List innerIndex = [];

  /// --------------------------------------------------------------------------
  List<bool> isUsnListVisible = [false];

  // ---------------------------------------------------------------------------
  /// StreamBuilder used to build the cards
  /// Collection = widget.branch + '-' + widget.year + '-' + widget.section
  /// Eg: CS-3-B
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firestore
          .collection(widget.branch + '-' + widget.year + '-' + widget.section)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        // Sort the documents from first to last
        final messages = snapshot.data.documents.reversed;

        List<Padding> cardWidgets = [];
        int i = 0;
        for (var message in messages) {
          if (message.documentID.substring(0, 10) == widget.usn) {
            final title = message.data['title'];
            final url = message.data['url'];

            final card = buildCard(
                outIndex: i,
                context: context,
                title: title,
                url: url,
                instance: widget.firestore,
                documentId: message.documentID);
            cardWidgets.add(card);
            textFields.add([]); // TODO
            textFieldController.add([]);
            isUsnListVisible.add(false);
            innerIndex.add(0);
            i = i + 1;
          }
        }
        return Container(
          height: MediaQuery.of(context).size.height - 110,
          child: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: cardWidgets,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  /// Building the body of the card
  Padding buildCard(
      {int outIndex,
      BuildContext context,
      String title,
      String url,
      Firestore instance,
      String documentId}) {
    /// Storing title in [text] to use later
    Text text = Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    text,
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.open_in_new),

                          /// Launch the url using the Google Docs
                          onPressed: () {
                            _launchURL(
                                'http://docs.google.com/viewer?url=$url');
                          },
                        ),

                        /// While deleting the card we have to delete both PDF file in storage
                        /// and the document in Firestore
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            /// PDF is stored in database as eg. 4SF16CS091-Cognit
                            /// [widget.usn] = '4SF16CS091' and [text.data] = 'Cognit'
                            StorageReference deleteRef = FirebaseStorage
                                .instance
                                .ref()
                                .child(widget.usn + '-' + text.data);

                            /// The naming convention for document in the Firestore and
                            /// FireBase is same
                            deleteRef.delete();
                            instance
                                .collection(widget.branch +
                                    '-' +
                                    widget.year +
                                    '-' +
                                    widget.section)
                                .document(widget.usn + '-' + text.data)
                                .delete();
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.keyboard_arrow_down),
                          onPressed: () {
                            if (isUsnListVisible[outIndex]) {
                              setState(() {
                                isUsnListVisible[outIndex] = false;
                              });
                            } else {
                              setState(() {
                                isUsnListVisible[outIndex] = true;
                              });
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),

                // -------------------------------------------------------------

                /// StreamBuilder used to build the USN list inside the card
                Visibility(
                  visible: isUsnListVisible[outIndex],
                  child: StreamBuilder<QuerySnapshot>(
                    stream: widget.firestore
                        .collection(widget.branch +
                            '-' +
                            widget.year +
                            '-' +
                            widget.section)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.lightBlueAccent,
                          ),
                        );
                      }

                      final messages = snapshot.data.documents.reversed;

                      List<Padding> textWidgets = [];
                      for (var message in messages) {
                        /// We need to check [documentID] eg. '4SF16CS091-Cognit' is
                        /// same as [widget.usn] eg. '4SF16CS091' and the [text.data] eg. 'Cognit'
                        /// Here [text.data] is gonna decide that data should be put into particular
                        /// card.
                        if (message.documentID ==
                            widget.usn + '-' + text.data) {
                          /// Each Student has a [studentUsnList] consisting of the USN added by him.
                          final studentUsnList = message.data['usn'];

                          if (studentUsnList.isEmpty) {
                            textWidgets.add(Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Center(
                                child: Text('No USN is added yet'),
                              ),
                            ));
                          }

                          /// Loop through [studentUsnList] and add the text
                          for (String usn in studentUsnList) {
                            /// This is done so later the value can be used for deleting
                            Text usnText = Text(usn);

                            textWidgets.add(Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  usnText,
                                  GestureDetector(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onTap: () {
                                      /// Crop and parse the [usnText] which is stored above to get
                                      /// the [year] and [branch] so we can delete the entry from FireStore.
                                      /// P.S : No need to delete from the FirebaseStorage as the file
                                      /// is not saved for each student.
                                      final int year = DateTime.now().year -
                                          int.parse('20' +
                                              usnText.data.substring(3, 5));
                                      final String branch =
                                          usnText.data.substring(5, 7);

                                      /// This is to update the [usnList] of the student.
                                      instance
                                          .collection(widget.branch +
                                              '-' +
                                              widget.year +
                                              '-' +
                                              widget.section)
                                          .document(
                                              widget.usn + '-' + text.data)
                                          .updateData({
                                        'title': text.data,
                                        'url': url,
                                        // Update the [usnList] by removing the USN
                                        'usn': FieldValue.arrayRemove(
                                            [usnText.data])
                                      });

                                      /// This is to delete the particular letter from Firestore
                                      instance
                                          .collection(branch +
                                              '-' +
                                              year.toString() +
                                              '-' +
                                              widget.section)
                                          .document(
                                              usnText.data + '-' + text.data)
                                          .delete();
                                    },
                                  )
                                ],
                              ),
                            ));
                          }
                        }
                      }
                      return Container(
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: textWidgets,
                        ),
                      );
                    },
                  ),
                ),

                // ----------------------------------------------------------------------

                /// ListView to display the text fields to enter the USN
                // TODO: Needs to be fixed
                ListView.builder(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: textFields[outIndex].length,
                    itemBuilder: (context, int index) {
                      innerIndex[outIndex] = index + 1;
                      return textFields[outIndex][index];
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          'Add USN',
                          style: TextStyle(color: Colors.orange, fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            textFieldController[outIndex]
                                .add(TextEditingController());
                            textFields[outIndex].add(
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextFormField(
                                      controller: textFieldController[outIndex]
                                          [innerIndex[outIndex]],
                                      decoration: InputDecoration(
                                        labelText: 'USN',
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orange)),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        textFields[outIndex].removeLast();
                                      });
                                    },
                                  )
                                ],
                              ),
                            );
                          });
                        },
                      ),
                      RaisedButton(
                        color: Colors.orange,
                        child: Text('Submit'),
                        onPressed: () {
                          List<String> usnList = [];
                          for (List controllerList in textFieldController)
                            for (TextEditingController controller
                                in controllerList) {
                              //TODO: Careful while changing the controllers

                              /// Regex to match the USN entered
                              RegExp regex =
                                  RegExp('^[0-9]SF[0-9]{2}[A-Z]{2}[0-9]{3}\$');

                              /// If there's no match a Snackbar will be displayed
                              /// When the user enters the USN we have to update the [usnList]
                              /// and we have to add the particular letter.
                              if (regex.hasMatch(controller.value.text)) {
                                usnList.add(controller.value.text);

                                /// To get the collection details for the new USN
                                /// Following calculated to get the year and branch of the
                                /// entered USN
                                final int year = DateTime.now().year -
                                    int.parse('20' +
                                        controller.value.text.substring(3, 5));
                                final String branch =
                                    controller.value.text.substring(5, 7);

                                /// To add the letter to the new USN
                                instance
                                    .collection(branch +
                                        '-' +
                                        year.toString() +
                                        '-' +
                                        widget.section)
                                    .document(
                                        controller.value.text + '-' + text.data)
                                    .setData({
                                  'title': text.data,
                                  'url': url,
                                  'usn': []
                                });

                                /// To update the [usnList] of the student
                                instance
                                    .collection(widget.branch +
                                        '-' +
                                        widget.year +
                                        '-' +
                                        widget.section)
                                    .document(widget.usn + '-' + text.data)
                                    .updateData({
                                  'title': text.data,
                                  'url': url,
                                  'usn': FieldValue.arrayUnion(usnList)
                                });

                                //TODO: Currently done as there multiple controllers
                                setState(() {
                                  controller.clear();
                                  textFields.clear();
                                  textFields.add([]);
                                  usnList.clear();
                                });
                              } else {
                                final snackBar = SnackBar(
                                    content: Text('Please enter valid USN'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              }
                            }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Launch the url using the url_launcher package
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// -----------------------------------------------------------------------------
class NotificationSectionDetailView extends StatefulWidget {
  final FirebaseMessaging firebaseMessaging;
  NotificationSectionDetailView({this.firebaseMessaging});
  @override
  _NotificationSectionDetailViewState createState() =>
      _NotificationSectionDetailViewState();
}

class _NotificationSectionDetailViewState
    extends State<NotificationSectionDetailView> {
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
    return Container(
      height: MediaQuery.of(context).size.height - 110,
      padding: EdgeInsets.all(10.0),
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
