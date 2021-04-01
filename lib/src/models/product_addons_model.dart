// To parse this JSON data, do
//
//     final productAddons = productAddonsFromJson(jsonString);

import 'dart:convert';

List<ProductAddonsModel> productAddonsFromJson(String str) => List<ProductAddonsModel>.from(json.decode(str).map((x) => ProductAddonsModel.fromJson(x)));

class ProductAddonsModel {
  ProductAddonsModel({
    this.id,
    this.name,
    this.priority,
    this.restrictToCategories,
    this.fields,
  });

  int id;
  String name;
  int priority;
  Map<String, String> restrictToCategories;
  List<AddonField> fields;

  factory ProductAddonsModel.fromJson(Map<String, dynamic> json) {
    try{
      return ProductAddonsModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        priority: json["priority"] == null ? null : json["priority"],
        restrictToCategories: json["restrict_to_categories"] == null
            ? null
            : (json["restrict_to_categories"] as Map).cast<String, String>(),
        fields: json["fields"] == null ? null : List<AddonField>.from(
            json["fields"].map((x) => AddonField.fromJson(x))),
      );
    } catch (e, s) {
      return ProductAddonsModel(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        priority: json["priority"] == null ? null : json["priority"],
        restrictToCategories: {},
        fields: json["fields"] == null ? null : List<AddonField>.from(
            json["fields"].map((x) => AddonField.fromJson(x))),
      );
    }
  }
}

class AddonField {
  AddonField({
    this.name,
    this.description,
    this.type,
    this.display,
    this.position,
    this.options,
    this.required,
  });

  String name;
  String description;
  String type;
  String display;
  int position;
  List<AddonOption> options;
  int required;

  factory AddonField.fromJson(Map<String, dynamic> json) => AddonField(
    name: json["name"] == null ? null : json["name"],
    description: json["description"] == null ? null : json["description"],
    type: json["type"] == null ? null : json["type"],
    display: json["display"] == null ? 'radiobutton' : json["display"],
    position: json["position"] == null ? null : json["position"],
    options: json["options"] == null ? null : List<AddonOption>.from(json["options"].map((x) => AddonOption.fromJson(x))),
    required: json["required"] == null ? null : json["required"],
  );

}

class AddonOption {
  AddonOption({
    this.label,
    this.price,
    this.min,
    this.max,
  });

  String label;
  String price;
  int min;
  int max;

  factory AddonOption.fromJson(Map<String, dynamic> json) => AddonOption(
    label: json["label"] == null ? null : json["label"],
    price: json["price"] == null ? null : json["price"],
    min: (json["min"] == null || json["min"] == '') ? 100 : int.parse(json["min"]),
    max: (json["max"] == null || json["max"] == '') ? 1000 : int.parse(json["max"]),
  );

}
