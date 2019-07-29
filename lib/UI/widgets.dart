import 'package:flutter/material.dart';
import 'sections.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class LetterSectionDetailView extends StatefulWidget {
  final Firestore firestore;
  LetterSectionDetailView({this.firestore});
  @override
  _LetterSectionDetailViewState createState() =>
      _LetterSectionDetailViewState();
}

class _LetterSectionDetailViewState extends State<LetterSectionDetailView> {
  List<List<TextFormField>> textFields = [[]];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: widget.firestore.collection('Student').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        final messages = snapshot.data.documents.reversed;

        List<Padding> cardWidgets = [];
        int i = 0;
        for (var message in messages) {
          final title = message.data['title'];
          final url = message.data['url'];

          final card = buildPadding(
              outIndex: i,
              context: context,
              title: title,
              url: url,
              instance: widget.firestore,
              documentId: message.documentID);
          cardWidgets.add(card);
          textFields.add([]);
          i = i + 1;
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

  Padding buildPadding(
      {int outIndex,
      BuildContext context,
      String title,
      String url,
      Firestore instance,
      String documentId}) {
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
                    PopupMenuButton(
                      onSelected: (value) async {
                        StorageReference deleteRef =
                            FirebaseStorage.instance.ref().child(text.data);
                        if (value == 'Open') {
                          _launchURL('http://docs.google.com/viewer?url=$url');
                        }
                        if (value == 'Delete') {
                          print('Delete');
                          deleteRef.delete();
                          instance
                              .collection('Student')
                              .document(text.data)
                              .delete();
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        const PopupMenuItem(
                          value: 'Open',
                          child: Text('Open'),
                        ),
                        const PopupMenuItem(
                          value: 'Delete',
                          child: Text('Delete'),
                        )
                      ],
                    )
                  ],
                ),
                ListView.builder(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: textFields[outIndex].length,
                    itemBuilder: (context, int index) {
                      return textFields[outIndex][index];
                    }),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: GestureDetector(
                    child: Text(
                      'Add USN',
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                    onTap: () {
                      setState(() {
                        textFields[outIndex].add(
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'USN',
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.orange)),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    textFields[outIndex].removeLast();
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      });
                    },
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

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
