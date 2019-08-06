import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:attendance_app/UI/date_time_picker.dart';

class LetterDetails extends StatefulWidget {
  Firestore firestore;
  final String usn;
  final String year;
  final String branch;
  final String section;
  final bool isEditing;
  final String cardTitle;

  LetterDetails(
      {this.firestore,
      this.branch = 'CS',
      this.year = '3',
      this.section = 'B',
      this.usn = '4SF16CS091',
      this.cardTitle,
      this.isEditing = false});

  @override
  _LetterDetailsState createState() => _LetterDetailsState();
}

class _LetterDetailsState extends State<LetterDetails> {
  final titleController = TextEditingController();
  final outcomeController = TextEditingController();
  Future<String> filePath;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now();
  String fileName = '';
  bool _isFileNameVisible = false;
  String selectedCategory;
  String retrievedCategory;
  String retrievedTitle;
  String retrievedOutcome;
  String retrievedUrl;
  String retrievedFromDate;
  String retrievedToDate;
  String updatedOutcome;
  List<dynamic> retrievedUsnList;
  bool isLoading = true;

  DateTime formattedFromDate;
  DateTime formattedToDate;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.isEditing) {
      retrieveData();
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    outcomeController.dispose();
    super.dispose();
  }

  void retrieveData() async {
    final DocumentSnapshot message = await widget.firestore
        .collection('${widget.branch}-${widget.year}-${widget.section}')
        .document('${widget.usn}-${widget.cardTitle}')
        .get();

    setState(() {
      isLoading = false;
    });

    retrievedCategory = message.data['category'];
    retrievedTitle = message.data['title'];
    retrievedOutcome = message.data['outcome'];
    retrievedUrl = message.data['url'];
    retrievedFromDate = message.data['from'];
    retrievedToDate = message.data['to'];
    retrievedUsnList = message.data['usn'];

    RegExp dateRegex = RegExp('([0-9]+)-[0-9]+');
    String fromDate = dateRegex.firstMatch(retrievedFromDate).group(1);
    String toDate = dateRegex.firstMatch(retrievedToDate).group(1);

    RegExp regex = RegExp('[0-9]+-([0-9]+)');
    String fromMonth = regex.firstMatch(retrievedFromDate).group(1);
    String toMonth = regex.firstMatch(retrievedToDate).group(1);

    RegExp yearRegex = RegExp('-[0-9]+([0-9]{2})\$');
    String year = yearRegex.firstMatch(retrievedFromDate).group(1);

    if (fromDate.length < 2) {
      fromDate = fromDate.padLeft(2, '0');
    }
    if (toDate.length < 2) {
      toDate = toDate.padLeft(2, '0');
    }
    if (fromMonth.length < 2) {
      fromMonth = fromMonth.padLeft(2, '0');
    }
    if (toMonth.length < 2) {
      toMonth = toMonth.padLeft(2, '0');
    }
    formattedFromDate = DateTime.parse('20$year$fromMonth$fromDate');
    formattedToDate = DateTime.parse('20$year$toMonth$toDate');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xFF24323F),
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
          title: Text('ADD LETTER'),
        ),
        body: (isLoading && widget.isEditing)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                canvasColor: Color(0xFF24323F),
                              ),
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text(
                                  'Select a category',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white24),
                                ),
                                value: selectedCategory,
                                disabledHint: widget.isEditing
                                    ? Text(
                                        retrievedCategory,
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : null,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                icon: Icon(Icons.keyboard_arrow_down),
                                onChanged: widget.isEditing
                                    ? null
                                    : (String newValue) {
                                        setState(() {
                                          selectedCategory = newValue;
                                        });
                                      },
                                items: [
                                  'Technical',
                                  'Cultural',
                                  'Sports'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller:
                                widget.isEditing ? null : titleController,
                            cursorColor: Colors.white,
                            initialValue:
                                widget.isEditing ? retrievedTitle : null,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Title',
                              hintText: 'Title can\'t be changed later',
                              hintStyle: TextStyle(color: Colors.white24),
                              labelStyle: TextStyle(
                                  color: Colors.white,
                                  decorationColor: Colors.white),
                            ),
                            enabled: (!widget.isEditing),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Title can\'t be empty';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: DateTimePicker(
                                    labelText: 'Date',
                                    selectedDate: widget.isEditing
                                        ? formattedFromDate
                                        : _fromDate,
                                    selectDate: (DateTime date) {
                                      setState(() {
                                        _fromDate = date;
                                        if (widget.isEditing) {
                                          formattedFromDate = date;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: DateTimePicker(
                                    labelText: 'Date',
                                    selectedDate: widget.isEditing
                                        ? formattedToDate
                                        : _toDate,
                                    selectDate: (DateTime date) {
                                      setState(() {
                                        _toDate = date;
                                        if (widget.isEditing) {
                                          formattedToDate = date;
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            maxLines: 5,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            controller:
                                widget.isEditing ? null : outcomeController,
                            cursorColor: Colors.white,
                            initialValue:
                                widget.isEditing ? retrievedOutcome : null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Outcomes',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            onSaved: (value) {
                              updatedOutcome = value;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Visibility(
                                      visible: _isFileNameVisible,
                                      child: OutlineButton(
                                        color: Colors.black,
                                        child: Text(
                                          fileName,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                    RaisedButton(
                                      child: Text('Select a file'),
                                      color: Colors.grey[300],
                                      onPressed: () async {
                                        filePath = FilePicker.getFilePath(
                                            type: FileType.CUSTOM,
                                            fileExtension: 'pdf');
                                        RegExp regex =
                                            RegExp('/([a-zA-Z0-9_]+.pdf)\$');
                                        fileName = regex
                                            .firstMatch(await filePath)
                                            .group(1);
                                        setState(() {
                                          _isFileNameVisible = true;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: widget.isEditing,
                                child: IconButton(
                                    icon: Icon(Icons.open_in_new),
                                    color: Colors.white,
                                    onPressed: () {
                                      _launchURL(
                                          'http://docs.google.com/viewer?url=$retrievedUrl');
                                    }),
                              )
                            ],
                          ),
                          Center(
                            child: RaisedButton(
                              child:
                                  Text(widget.isEditing ? 'Update' : 'Submit'),
                              color: Colors.orange,
                              onPressed: widget.isEditing
                                  ? () async {
                                      _formKey.currentState.save();
                                      String url;

                                      if (fileName.isNotEmpty) {
                                        final StorageReference storageRef =
                                            FirebaseStorage.instance
                                                .ref()
                                                .child(widget.usn +
                                                    '-' +
                                                    widget.cardTitle);
                                        storageRef.delete();
                                        final StorageUploadTask uploadTask =
                                            storageRef
                                                .putFile(File(await filePath));
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
                                        url = (await downloadUrl.ref
                                            .getDownloadURL());
                                      }

                                      for (var usn in retrievedUsnList) {
                                        widget.firestore
                                            .collection(widget.branch +
                                                '-' +
                                                widget.year.toString() +
                                                '-' +
                                                widget.section)
                                            .document(
                                                usn + '-' + widget.cardTitle)
                                            .updateData({
                                          'category': retrievedCategory,
                                          'title': retrievedTitle,
                                          'from': (_fromDate.day ==
                                                      DateTime.now().day &&
                                                  _fromDate.month ==
                                                      DateTime.now().month)
                                              ? formattedFromDate.day
                                                      .toString() +
                                                  '-' +
                                                  formattedFromDate.month
                                                      .toString() +
                                                  '-' +
                                                  formattedFromDate.year
                                                      .toString()
                                              : _fromDate.day.toString() +
                                                  '-' +
                                                  _fromDate.month.toString() +
                                                  '-' +
                                                  _fromDate.year.toString(),
                                          'to': (_toDate.day ==
                                                      DateTime.now().day &&
                                                  _toDate.month ==
                                                      DateTime.now().month)
                                              ? formattedToDate.day.toString() +
                                                  '-' +
                                                  formattedToDate.month
                                                      .toString() +
                                                  '-' +
                                                  formattedToDate.year
                                                      .toString()
                                              : _toDate.day.toString() +
                                                  '-' +
                                                  _toDate.month.toString() +
                                                  '-' +
                                                  _toDate.year.toString(),
                                          'outcome': updatedOutcome,
                                          'url': fileName.isEmpty
                                              ? retrievedUrl
                                              : url,
                                          'usn': FieldValue.arrayUnion([])
                                        });
                                      }

                                      widget.firestore
                                          .collection(widget.branch +
                                              '-' +
                                              widget.year.toString() +
                                              '-' +
                                              widget.section)
                                          .document(widget.usn +
                                              '-' +
                                              widget.cardTitle)
                                          .updateData({
                                        'category': retrievedCategory,
                                        'title': retrievedTitle,
                                        'from': (_fromDate.day ==
                                                    DateTime.now().day &&
                                                _fromDate.month ==
                                                    DateTime.now().month)
                                            ? formattedFromDate.day.toString() +
                                                '-' +
                                                formattedFromDate.month
                                                    .toString() +
                                                '-' +
                                                formattedFromDate.year
                                                    .toString()
                                            : _fromDate.day.toString() +
                                                '-' +
                                                _fromDate.month.toString() +
                                                '-' +
                                                _fromDate.year.toString(),
                                        'to': (_toDate.day ==
                                                    DateTime.now().day &&
                                                _toDate.month ==
                                                    DateTime.now().month)
                                            ? formattedToDate.day.toString() +
                                                '-' +
                                                formattedToDate.month
                                                    .toString() +
                                                '-' +
                                                formattedToDate.year.toString()
                                            : _toDate.day.toString() +
                                                '-' +
                                                _toDate.month.toString() +
                                                '-' +
                                                _toDate.year.toString(),
                                        'outcome': updatedOutcome,
                                        'url': fileName.isEmpty
                                            ? retrievedUrl
                                            : url,
                                        'usn': retrievedUsnList
                                      });
                                    }
                                  : () async {
                                      if (_formKey.currentState.validate()) {
                                        if (selectedCategory == null) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please select a category')));
                                        } else if (fileName.isEmpty) {
                                          _scaffoldKey.currentState
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Please select a file')));
                                        } else {
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
                                            'category': selectedCategory,
                                            'title': titleController.value.text,
                                            'from': _fromDate.day.toString() +
                                                '-' +
                                                _fromDate.month.toString() +
                                                '-' +
                                                _fromDate.year.toString(),
                                            'to': _toDate.day.toString() +
                                                '-' +
                                                _toDate.month.toString() +
                                                '-' +
                                                _toDate.year.toString(),
                                            'outcome':
                                                outcomeController.value.text,
                                            'url': url,
                                            'usn': []
                                          });
                                          titleController.clear();
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
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
