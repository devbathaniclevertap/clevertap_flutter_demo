// To parse this JSON data, do
//
//     final nudgesEntity = nudgesEntityFromJson(jsonString);

import 'dart:convert';

List<NudgesEntity> nudgesEntityFromJson(String str) => List<NudgesEntity>.from(
    json.decode(str).map((x) => NudgesEntity.fromJson(x)));

String nudgesEntityToJson(List<NudgesEntity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NudgesEntity {
  String key;
  String value;

  NudgesEntity({
    required this.key,
    required this.value,
  });

  factory NudgesEntity.fromJson(Map<String, dynamic> json) => NudgesEntity(
        key: json["key"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
      };
}
