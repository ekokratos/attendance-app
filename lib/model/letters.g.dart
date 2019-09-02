// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterDetails _$LetterDetailsFromJson(Map<String, dynamic> json) {
  return LetterDetails(
    category: json['category'] as String,
    from: json['from'] == null ? null : DateTime.parse(json['from'] as String),
    to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
    outcome: json['outcome'] as String,
    title: json['title'] as String,
    usn: (json['usn'] as List)?.map((e) => e as String)?.toList(),
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$LetterDetailsToJson(LetterDetails instance) =>
    <String, dynamic>{
      'category': instance.category,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'outcome': instance.outcome,
      'title': instance.title,
      'url': instance.url,
      'usn': instance.usn,
    };
