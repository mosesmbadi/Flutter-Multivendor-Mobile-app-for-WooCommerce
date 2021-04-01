// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

List<CountryModel> countryModelFromJson(String str) => List<CountryModel>.from(json.decode(str).map((x) => CountryModel.fromJson(x)));

String countryModelToJson(List<CountryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryModel {
  String label;
  String value;
  List<Region> regions;

  CountryModel({
    this.label,
    this.value,
    this.regions,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
    regions: json["regions"] == null ? null : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
    "regions": regions == null ? null : List<dynamic>.from(regions.map((x) => x.toJson())),
  };
}

class Region {
  String label;
  String value;

  Region({
    this.label,
    this.value,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
  };
}
