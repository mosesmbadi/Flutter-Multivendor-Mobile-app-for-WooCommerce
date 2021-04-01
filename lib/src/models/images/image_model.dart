// To parse this JSON data, do
//
//     final picture = pictureFromJson(jsonString);

import 'dart:convert';

Picture pictureFromJson(String str) => Picture.fromJson(json.decode(str));

String pictureToJson(Picture data) => json.encode(data.toJson());

class Picture {
  int id;
  String src;
  String name;
  String alt;
  int position;

  Picture({
    this.id,
    this.src,
    this.name,
    this.alt,
    this.position,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    id: json["id"] == null ? null : json["id"],
    src: (json["src"] == null || json["src"] == false) ? null : json["src"],
    name: json["name"] == null ? null : json["name"],
    alt: json["alt"] == null ? null : json["alt"],
    position: json["position"] == null ? null : json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "src": src == null ? null : src,
    "name": name == null ? null : name,
    "alt": alt == null ? null : alt,
    "position": position == null ? null : position,
  };
}
