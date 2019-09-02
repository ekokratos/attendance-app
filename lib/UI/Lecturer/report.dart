import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final GlobalKey _snackbarKey = GlobalKey<FormState>();

  String selectedYear;
  String selectedSection;
  String selectedDept;
  String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            key: _snackbarKey,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Hero(
                            tag: 'report',
                            child: Text(
                              'Report  ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                fontFamily: "Roboto",
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'reportIcon',
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.clear,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Generate the report of letters uploaded by students for leave of absense, permissions, etc.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Divider(
                        height: 64,
                        color: Colors.black,
                      ),
                      Text(
                        'Select the Class',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: DropDownButton(
                                  hintText: 'Year',
                                  updatedValue: selectedYear,
                                  dropdownValues: ['1', '2', '3', '4'],
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedYear = newValue;
                                    });
                                  }),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: DropDownButton(
                                  hintText: 'Section',
                                  updatedValue: selectedSection,
                                  dropdownValues: ['A', 'B', 'C'],
                                  onChanged: (String newValue) {
                                    setState(() {
                                      selectedSection = newValue;
                                    });
                                  }),
                            )
                          ],
                        ),
                      ),
                      DropDownButton(
                          hintText: 'Department',
                          updatedValue: selectedDept,
                          dropdownValues: ['CS', 'IS', 'CV', 'ME', 'EC'],
                          onChanged: (String newValue) {
                            setState(() {
                              selectedDept = newValue;
                            });
                          }),
                    ],
                  ),
                ),
              ),
              Hero(
                tag: 'reportButton',
                child: RaisedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.receipt,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Check Reports',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () async {
                      if (selectedDept != null &&
                          selectedYear != null &&
                          selectedSection != null) {
                        _launchURL(
                            'https://us-central1-cloud-messaging-b6180.cloudfunctions.net/generateReport?classAndSection=$selectedDept-$selectedYear-$selectedSection');
                      } else {
                        Scaffold.of(_snackbarKey.currentContext).showSnackBar(
                          SnackBar(
                            content: Text('Please enter all details.'),
                          ),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class DropDownButton extends StatelessWidget {
  final String hintText;
  final String updatedValue;
  final Function onChanged;
  final List<String> dropdownValues;

  DropDownButton(
      {this.hintText, this.updatedValue, this.onChanged, this.dropdownValues});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text(
        hintText,
        style: TextStyle(fontSize: 18),
      ),
      value: updatedValue,
      icon: Icon(Icons.keyboard_arrow_down),
      onChanged: onChanged,
      items: dropdownValues.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
