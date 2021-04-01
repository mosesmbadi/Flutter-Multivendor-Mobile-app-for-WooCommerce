// To parse this JSON data, do
//
//     final category = categoryFromJson(jsonString);

import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

class Category {
  int id;
  String name;
  String description;
  int parent;
  int count;
  String image;

  Category({
    this.id,
    this.name,
    this.description,
    this.parent,
    this.count,
    this.image,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    parent: json["parent"] == null ? null : json["parent"],
    count: json["count"] == null ? null : json["count"],
    image: json["image"] == null || json["image"] == false ? '' : json["image"],
  );
}