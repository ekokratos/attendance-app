import 'package:flutter/material.dart';

const Color _mariner = Color(0xFFFEC601);
const Color _mediumPurple = Color(0xFFFFB70F);
const Color _tomato = Color(0xFF084887);
const Color _mySin = Color(0xFF2CA8FF);

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

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
  final List<AttendanceDetail> details;

  @override
  bool operator ==(Object other) {
    if (other is! Section) return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}

// TODO(hansmuller): replace the SectionDetail images and text. Get rid of
// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

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

const AttendanceDetail subjectDetail4 = AttendanceDetail(
    subject: 'Machine Learning',
    subjectCode: '15CS64',
    numOfClasses: 30,
    attendedClasses: 24,
    percentage: (28 / 30) * 100);

const AttendanceDetail subjectDetail5 = AttendanceDetail(
    subject: 'Computer Organisation',
    subjectCode: '15CS65',
    numOfClasses: 30,
    attendedClasses: 18,
    percentage: (18 / 30) * 100);

const MarksDetail MarksDetail1 = MarksDetail(
    subject: 'Computer Organisation',
    firstIA: 13,
    secondIA: 7,
    thirdIA: 13,
    average: 13);

const MarksDetail MarksDetail2 = MarksDetail(
    subject: 'Computer Organisation',
    firstIA: 13,
    secondIA: -1,
    thirdIA: -1,
    average: 7);

final List<Section> allSections = <Section>[
  const Section(
    title: 'ATTENDANCE',
    leftColor: Color(0xFF8266D4),
    rightColor: Color(0xFF3B5F8F),
    details: <AttendanceDetail>[
      subjectDetail1,
      subjectDetail2,
      subjectDetail3,
      subjectDetail4,
      subjectDetail5,
    ],
  ),
  const Section(
    title: 'MARKS',
    leftColor: Color(0xFFF95B57),
    rightColor: Color(0xFF8266D4),
    details: <AttendanceDetail>[],
  ),
  const Section(
    title: 'LETTERS',
    leftColor: Color(0xFFF3A646),
    rightColor: Color(0xFFF95B57),
    details: <AttendanceDetail>[],
  ),
  const Section(
    title: 'FACULTY',
    leftColor: Colors.white,
    rightColor: Color(0xFFF95B57),
    details: <AttendanceDetail>[],
  ),
];
