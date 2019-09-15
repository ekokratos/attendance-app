import 'package:attendance_app/UI/Common/dev_scaffold.dart';
import 'package:attendance_app/bloc/config/config_bloc.dart';
import 'package:attendance_app/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'letter_details.dart';
import 'package:attendance_app/firebase/db.dart';
//import 'package:attendance_app/model/letters.dart';

// -----------------------------------------------------------------------------
class StudentLetterPage extends StatefulWidget {
  Firestore firestore;
  final String usn;
  final String year;
  final String branch;
  final String section;
  StudentLetterPage(
      {this.firestore,
      this.branch = 'CS',
      this.year = '3',
      this.section = 'B',
      this.usn = '4SF16CS091'});
  @override
  _StudentLetterPageState createState() => _StudentLetterPageState();
}

class _StudentLetterPageState extends State<StudentLetterPage> {
  /// --------------------------------------------------------------------------
  List<bool> isUsnListVisible = [false];
  List<bool> isTextFormVisible = [false];
  List<TextEditingController> controller = [TextEditingController()];

  // ---------------------------------------------------------------------------
  /// StreamBuilder used to build the cards
  /// Collection = widget.branch + '-' + widget.year + '-' + widget.section
  /// Eg: CS-3-B
  @override
  Widget build(BuildContext context) {
    widget.firestore =
        widget.firestore == null ? Firestore.instance : widget.firestore;
    return SafeArea(
      child: DevScaffold(
        leading: IconButton(
            icon: Icon(
              Icons.clear,
              size: 32,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: 'LETTERS',
        body: Hero(
          tag: 'letters',
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor:
                ConfigBloc().darkModeOn ? Colors.grey[900] : Colors.white,
            floatingActionButton: RaisedButton(
              shape: CircleBorder(),
              color: ConfigBloc().darkModeOn
                  ? kFABDarkModeColor
                  : kFABLightModeColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LetterDetails(
                      firestore: widget.firestore,
                      branch: widget.branch,
                      year: widget.year,
                      section: widget.section,
                      usn: widget.usn,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Icon(
                  Icons.add,
                  color: ConfigBloc().darkModeOn
                      ? kIconDarkModeColor
                      : kIconLightModeColor,
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: widget.firestore
                  .collection(
                      widget.branch + '-' + widget.year + '-' + widget.section)
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
                    final fromDate = message.data['from'];
                    final toDate = message.data['to'];
                    final category = message.data['category'];
                    final outcome = message.data['outcome'];
                    final usnList = message.data['usn'];

                    final card = buildCard(
                        index: i,
                        context: context,
                        title: title,
                        url: url,
                        from: fromDate,
                        to: toDate,
                        category: category,
                        outcome: outcome,
                        usnList: usnList,
                        instance: widget.firestore,
                        documentId: message.documentID);
                    cardWidgets.add(card);
                    isTextFormVisible.add(false);
                    isUsnListVisible.add(false);
                    controller.add(TextEditingController());
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
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  /// Building the body of the card
  Padding buildCard(
      {int index,
      BuildContext context,
      String title,
      String url,
      Firestore instance,
      String documentId,
      String from,
      String to,
      List usnList,
      String category,
      String outcome}) {
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
          color: ConfigBloc().darkModeOn ? Colors.black : Colors.white,
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
                          icon: Icon(Icons.edit),

                          /// Launch the url using the Google Docs
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LetterDetails(
                                          firestore: widget.firestore,
                                          branch: widget.branch,
                                          year: widget.year,
                                          section: widget.section,
                                          usn: widget.usn,
                                          cardTitle: text.data,
                                          isEditing: true,
                                        )));
                          },
                        ),

                        /// While deleting the card we have to delete both PDF file in storage
                        /// and the document in Firestore
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            /// PDF is stored in database as eg. 4SF16CS091-Cognit
                            /// [widget.usn] = '4SF16CS091' and [text.data] = 'Cognit'

                            if (usnList.isEmpty) {
                              RegExp regex =
                                  RegExp('[0-9]SF[0-9]{2}[A-Z]{2}[0-9]{3}');
                              final String deleteUsn = regex.stringMatch(url);
                              StorageReference deleteRef = FirebaseStorage
                                  .instance
                                  .ref()
                                  .child(deleteUsn + '-' + text.data);

                              /// The naming convention for document in the Firestore and
                              /// FireBase is same
                              deleteRef.delete();
                            }
                            for (var usn in usnList) {
                              instance
                                  .collection(widget.branch +
                                      '-' +
                                      widget.year +
                                      '-' +
                                      widget.section)
                                  .document(usn + '-' + text.data)
                                  .updateData({
                                'title': text.data,
                                'url': url,
                                // Update the [usnList] by removing the USN
                                'usn': FieldValue.arrayRemove([widget.usn])
                              });
                            }
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
                            if (isUsnListVisible[index]) {
                              setState(() {
                                isUsnListVisible[index] = false;
                              });
                            } else {
                              setState(() {
                                isUsnListVisible[index] = true;
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
                  visible: isUsnListVisible[index],
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

                                      for (var usn in usnList) {
                                        instance
                                            .collection(widget.branch +
                                                '-' +
                                                widget.year +
                                                '-' +
                                                widget.section)
                                            .document(usn + '-' + text.data)
                                            .updateData({
                                          'title': text.data,
                                          'url': url,
                                          // Update the [usnList] by removing the USN
                                          'usn': FieldValue.arrayRemove(
                                              [usnText.data])
                                        });
                                      }

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

                /// TextFormField to enter the USN
                Visibility(
                  visible: isTextFormVisible[index],
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: controller[index],
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            hintText: 'Enter the USN',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () {
                          setState(() {
                            controller[index].clear();
                            isTextFormVisible[index] = false;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text(
                          'Add USN',
                          style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? kSubmitDarkModeColor
                                  : kSubmitLightModeColor,
                              fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            isTextFormVisible[index] = true;
                          });
                        },
                      ),
                      RaisedButton(
                        color: ConfigBloc().darkModeOn
                            ? kSubmitDarkModeColor
                            : kSubmitLightModeColor,
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              color: ConfigBloc().darkModeOn
                                  ? kSubmitTextDarkModeColor
                                  : kSubmitTextLightModeColor),
                        ),
                        onPressed: () async {
                          /// Regex to match the USN entered
                          RegExp regex =
                              RegExp('^[0-9]SF[0-9]{2}[A-Z]{2}[0-9]{3}\$');

                          /// If there's no match a Snackbar will be displayed
                          /// When the user enters the USN we have to update the [usnList]
                          /// and we have to add the particular letter.
                          if (regex.hasMatch(controller[index].value.text)) {
                            /// Following calculated to get the year and branch of the
                            /// entered USN
                            final int year = DateTime.now().year -
                                int.parse('20' +
                                    controller[index]
                                        .value
                                        .text
                                        .substring(3, 5));
                            final String branch =
                                controller[index].value.text.substring(5, 7);

                            /// To add the letter to the new USN
                            instance
                                .collection(branch +
                                    '-' +
                                    year.toString() +
                                    '-' +
                                    widget.section)
                                .document(controller[index].value.text +
                                    '-' +
                                    text.data)
                                .setData({
                              'title': text.data,
                              'url': url,
                              'from': from,
                              'to': to,
                              'category': category,
                              'outcome': outcome,
                              'usn': FieldValue.arrayUnion([widget.usn])
                            });

                            // ----------------------------------------------------------------
                            /// When we add a particular USN the [usnList] of all the students
                            /// should get updated. This is done in the following section.
                            ///
                            /// [message] contains the snapshot of user USN
                            final DocumentSnapshot message = await widget
                                .firestore
                                .collection(
                                    '${widget.branch}-${widget.year}-${widget.section}')
                                .document('${widget.usn}-${text.data}')
                                .get();

                            /// [retrievedUsnList] contains all the USN in [usnList] of user USN.
                            final List retrievedUsnList = message['usn'];
                            final updatedList = [controller[index].value.text];
                            for (var outerUsn in retrievedUsnList) {
                              final updatedList = [
                                controller[index].value.text
                              ];
                              for (var usn in retrievedUsnList) {
                                updatedList.add(usn);
                              }
                              updatedList.remove(outerUsn);
                              instance
                                  .collection(branch +
                                      '-' +
                                      year.toString() +
                                      '-' +
                                      widget.section)
                                  .document(outerUsn + '-' + text.data)
                                  .updateData({
                                'usn': FieldValue.arrayUnion(updatedList)
                              });
                              updatedList.clear();
                            }

                            for (var usn in retrievedUsnList) {
                              updatedList.add(usn);
                            }
                            updatedList.remove(controller[index].value.text);
                            instance
                                .collection(branch +
                                    '-' +
                                    year.toString() +
                                    '-' +
                                    widget.section)
                                .document(controller[index].value.text +
                                    '-' +
                                    text.data)
                                .updateData({
                              'usn': FieldValue.arrayUnion(updatedList)
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
                              'usn': FieldValue.arrayUnion(
                                  [controller[index].value.text])
                            });
                            setState(() {
                              controller[index].clear();
                              isTextFormVisible[index] = false;
                            });
                          } else {
                            final snackBar =
                                SnackBar(content: Text('Enter valid USN'));
                            Scaffold.of(context).showSnackBar(snackBar);
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

// -----------------------------------------------------------------------------
