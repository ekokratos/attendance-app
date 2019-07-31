import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

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
  final titleController = TextEditingController();
  Future<String> filePath;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  /// StreamBuilder used to build the cards
  /// Collection = widget.branch + '-' + widget.year + '-' + widget.section
  /// Eg: CS-3-B
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF24323F),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      title: Text("Add Letter"),
                      content: Container(
                          height: 230,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    24.0, 20.0, 24.0, 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    TextFormField(
                                      controller: titleController,
                                      decoration:
                                          InputDecoration(labelText: 'Title'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: RaisedButton(
                                        child: Text('Select a file'),
                                        color: Colors.grey[300],
                                        onPressed: () {
                                          filePath = FilePicker.getFilePath(
                                              type: FileType.CUSTOM,
                                              fileExtension: 'pdf');
                                        },
                                      ),
                                    ),
                                    Center(
                                      child: RaisedButton(
                                        child: Text('Submit'),
                                        color: Colors.orange,
                                        onPressed: () async {
                                          Center(
                                              child: CircularProgressIndicator(
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ));
                                          final StorageReference storageRef =
                                              FirebaseStorage.instance
                                                  .ref()
                                                  .child(widget.usn +
                                                      '-' +
                                                      titleController
                                                          .value.text);
                                          final StorageUploadTask uploadTask =
                                              storageRef.putFile(
                                                  File(await filePath));
                                          uploadTask.events
                                              .listen((event) {})
                                              .onError((error) {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    'Oops! Something went wrong'));
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          });
                                          StorageTaskSnapshot downloadUrl =
                                              (await uploadTask.onComplete);
                                          final String url = (await downloadUrl
                                              .ref
                                              .getDownloadURL());
                                          widget.firestore
                                              .collection(widget.branch +
                                                  '-' +
                                                  widget.year.toString() +
                                                  '-' +
                                                  widget.section)
                                              .document(widget.usn +
                                                  '-' +
                                                  titleController.value.text)
                                              .setData({
                                            'title': titleController.value.text,
                                            'url': url,
                                            'usn': []
                                          });
                                          titleController.clear();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Color(0xFF24323F),
          leading: IconButton(
              icon: Icon(
                Icons.clear,
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text('LETTERS'),
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
        ),
      ),
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
