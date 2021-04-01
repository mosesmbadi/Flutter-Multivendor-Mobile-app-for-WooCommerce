// To parse this JSON data, do
//
//     final addToCartErrorModel = addToCartErrorModelFromJson(jsonString);

import 'dart:convert';

AddToCartErrorModel addToCartErrorModelFromJson(String str) => AddToCartErrorModel.fromJson(json.decode(str));

String addToCartErrorModelToJson(AddToCartErrorModel data) => json.encode(data.toJson());

class AddToCartErrorModel {
  bool success;
  AddToCartErrorData data;

  AddToCartErrorModel({
    this.success,
    this.data,
  });

  factory AddToCartErrorModel.fromJson(Map<String, dynamic> json) => AddToCartErrorModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : AddToCartErrorData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
  };
}

class AddToCartErrorData {
  bool error;
  String productUrl;
  String notice;

  AddToCartErrorData({
    this.error,
    this.productUrl,
    this.notice,
  });

  factory AddToCartErrorData.fromJson(Map<String, dynamic> json) => AddToCartErrorData(
    error: json["error"] == null ? null : json["error"],
    //productUrl: json["product_url"] == null ? null : json["product_url"],
    notice: json["notice"] == null ? null : json["notice"],
  );

  Map<String, dynamic> toJson() => {
    "error": error == null ? null : error,
    "product_url": productUrl == null ? null : productUrl,
    "notice": notice == null ? null : notice,
  };
}
