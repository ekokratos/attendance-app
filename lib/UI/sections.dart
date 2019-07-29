import 'package:flutter/material.dart';

class AttendanceDetail {
  const AttendanceDetail({
    this.subject,
    this.subjectCode,
    this.numOfClasses,
    this.attendedClasses,
    this.percentage,
  });
  final String subject;
  final String subjectCode;
  final int numOfClasses;
  final int attendedClasses;
  final double percentage;
}

class MarksDetail {
  const MarksDetail({
    this.subject,
    this.firstIA,
    this.secondIA,
    this.thirdIA,
    this.average,
  });
  final String subject;
  final int firstIA;
  final int secondIA;
  final int thirdIA;
  final double average;
}

class LetterDetail {
  const LetterDetail({this.title, this.imageUrl});
  final String title;
  final String imageUrl;
}

class Section {
  const Section({
    this.title,
    this.leftColor,
    this.rightColor,
    this.details,
  });
  final String title;
  final Color leftColor;
  final Color rightColor;
  final List details;

  @override
  bool operator ==(Object other) {
    if (other is! Section) return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

const AttendanceDetail subjectDetail1 = AttendanceDetail(
    subject: 'Python Application Programming',
    subjectCode: '15CS61',
    numOfClasses: 30,
    attendedClasses: 21,
    percentage: (26 / 30) * 100);

const AttendanceDetail subjectDetail2 = AttendanceDetail(
    subject: 'Computer Networks',
    subjectCode: '15CS62',
    numOfClasses: 30,
    attendedClasses: 14,
    percentage: (14 / 30) * 100);

const AttendanceDetail subjectDetail3 = AttendanceDetail(
    subject: '.NET',
    subjectCode: '15CS63',
    numOfClasses: 30,
    attendedClasses: 29,
    percentage: (29 / 30) * 100);

const MarksDetail marksDetail1 = MarksDetail(
    subject: 'Computer Organisation',
    firstIA: 13,
    secondIA: 7,
    thirdIA: 13,
    average: 13);

const MarksDetail marksDetail2 = MarksDetail(
    subject: 'Machine Learning',
    firstIA: 13,
    secondIA: -1,
    thirdIA: -1,
    average: 7);

const LetterDetail letterDetail1 = LetterDetail(
    title: 'Letter for SIH 2019',
    imageUrl:
        'https://firebasestorage.googleapis.com/v0/b/cloud-messaging-b6180.appspot.com/o/Melwin%2Fcheck_1.pdf?alt=media&token=ffe65276-82ce-4ca6-a6b9-c030fb4dd3be');

final List<Section> allSections = <Section>[
  const Section(
    title: 'ATTENDANCE',
    leftColor: Color(0xFF8266D4),
    rightColor: Color(0xFF3B5F8F),
    details: <AttendanceDetail>[subjectDetail1, subjectDetail2, subjectDetail3],
  ),
  const Section(
    title: 'MARKS',
    leftColor: Color(0xFFF95B57),
    rightColor: Color(0xFF8266D4),
    details: <MarksDetail>[marksDetail1, marksDetail2],
  ),
  const Section(
    title: 'LETTERS',
    leftColor: Color(0xFFF3A646),
    rightColor: Color(0xFFF95B57),
    details: <LetterDetail>[letterDetail1],
  ),
  const Section(
    title: 'FACULTY',
    leftColor: Colors.white,
    rightColor: Color(0xFFF95B57),
    details: <AttendanceDetail>[],
  ),
];
