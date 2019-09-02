import 'package:json_annotation/json_annotation.dart';

part 'letters.g.dart';

@JsonSerializable()
class LetterDetails {
  final String category;
  final DateTime from;
  final DateTime to;
  final String outcome;
  final String title;
  final String url;
  final List<String> usn;
  LetterDetails(
      {this.category,
      this.from,
      this.to,
      this.outcome,
      this.title,
      this.usn,
      this.url});

  factory LetterDetails.fromJson(Map<String, dynamic> json) =>
      _$LetterDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$LetterDetailsToJson(this);
}
