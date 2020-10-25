// To parse this JSON data, do
//
//     final testCaseFields = testCaseFieldsFromMap(jsonString);

import 'dart:convert';

TestCaseFields testCaseFieldsFromMap(String str) =>
    TestCaseFields.fromMap(json.decode(str));

String testCaseFieldsToMap(TestCaseFields data) => json.encode(data.toMap());

class TestCaseFields {
  TestCaseFields({
    this.category,
    this.outcome,
    this.title,
    this.url,
    this.usn,
    this.from,
    this.to,
  });

  String category;
  String outcome;
  String title;
  String url;
  List<String> usn;
  DateTime from;
  DateTime to;

  factory TestCaseFields.fromMap(Map<String, dynamic> json) => TestCaseFields(
        category: json["category"] == null ? null : json["category"],
        outcome: json["outcome"] == null ? null : json["outcome"],
        title: json["title"] == null ? null : json["title"],
        url: json["url"] == null ? null : json["url"],
        usn: json["usn"] == null
            ? null
            : List<String>.from(json["usn"].map((x) => x)),
        from: json["from"] == null ? null : DateTime.parse(json["from"]),
        to: json["to"] == null ? null : DateTime.parse(json["to"]),
      );

  Map<String, dynamic> toMap() => {
        "category": category == null ? null : category,
        "outcome": outcome == null ? null : outcome,
        "title": title == null ? null : title,
        "url": url == null ? null : url,
        "usn": usn == null ? null : List<dynamic>.from(usn.map((x) => x)),
        "from": from == null ? null : from.toIso8601String(),
        "to": to == null ? null : to.toIso8601String(),
      };
}
