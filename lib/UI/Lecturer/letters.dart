import 'package:flutter/material.dart';
import 'letter_list.dart';

class Letters extends StatefulWidget {
  @override
  _LettersState createState() => _LettersState();
}

class _LettersState extends State<Letters> {
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
                            tag: 'letter',
                            child: Text(
                              'Letters  ',
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
                            tag: 'fileIcon',
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
                          'You can view letters uploaded by\n students for leave of absence.',
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
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child: DropDownButton(
                            hintText: 'Category',
                            updatedValue: selectedCategory,
                            dropdownValues: [
                              'All',
                              'Technical',
                              'Cultural',
                              'Sports'
                            ],
                            onChanged: (String newValue) {
                              setState(() {
                                selectedCategory = newValue;
                              });
                            }),
                      )
                    ],
                  ),
                ),
              ),
              Hero(
                tag: 'letterButton',
                child: RaisedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.description,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Check Letters',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      if (selectedDept != null &&
                          selectedYear != null &&
                          selectedSection != null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentList(
                                    year: selectedYear,
                                    department: selectedDept,
                                    section: selectedSection,
                                    category: selectedCategory,
                                  )),
                        );
                      else {
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
