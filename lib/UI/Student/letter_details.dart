import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:attendance_app/UI/date_time_picker.dart';

class LetterDetails extends StatefulWidget {
  Firestore firestore;
  final String usn;
  final String year;
  final String branch;
  final String section;

  LetterDetails(
      {this.firestore,
      this.branch = 'CS',
      this.year = '3',
      this.section = 'B',
      this.usn = '4SF16CS091'});

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

  @override
  void dispose() {
    titleController.dispose();
    outcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
                          style: TextStyle(fontSize: 18, color: Colors.white24),
                        ),
                        value: selectedCategory,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        icon: Icon(Icons.keyboard_arrow_down),
                        onChanged: (String newValue) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        },
                        items: ['Technical', 'Cultural', 'Sports']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                          color: Colors.white, decorationColor: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: DateTimePicker(
                            labelText: 'Date',
                            selectedDate: _fromDate,
                            selectDate: (DateTime date) {
                              setState(() {
                                _fromDate = date;
                                print(_fromDate);
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
                            selectedDate: _toDate,
                            selectDate: (DateTime date) {
                              setState(() {
                                _toDate = date;
                                print(_toDate);
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
                    controller: outcomeController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Outcomes',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText:
                            'Please enter the achievements and outcomes here',
                        hintStyle: TextStyle(color: Colors.white24)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                type: FileType.CUSTOM, fileExtension: 'pdf');
                            RegExp regex = RegExp('/([a-zA-Z0-9_]+.pdf)\$');
                            print(regex.firstMatch(await filePath).group(1));
                            fileName =
                                regex.firstMatch(await filePath).group(1);
                            setState(() {
                              _isFileNameVisible = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: RaisedButton(
                      child: Text('Submit'),
                      color: Colors.orange,
                      onPressed: () async {
                        Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.lightBlueAccent,
                        ));
                        final StorageReference storageRef =
                            FirebaseStorage.instance.ref().child(
                                widget.usn + '-' + titleController.value.text);
                        final StorageUploadTask uploadTask =
                            storageRef.putFile(File(await filePath));
                        uploadTask.events.listen((event) {}).onError((error) {
                          final snackBar = SnackBar(
                              content: Text('Oops! Something went wrong'));
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                        StorageTaskSnapshot downloadUrl =
                            (await uploadTask.onComplete);
                        final String url =
                            (await downloadUrl.ref.getDownloadURL());
                        widget.firestore
                            .collection(widget.branch +
                                '-' +
                                widget.year.toString() +
                                '-' +
                                widget.section)
                            .document(
                                widget.usn + '-' + titleController.value.text)
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
                          'outcome': outcomeController.value.text,
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
        ),
      ),
    );
  }
}
