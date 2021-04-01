// To parse this JSON data, do
//
//     final releatedProducts = releatedProductsFromJson(jsonString);

import 'dart:convert';

import 'product_model.dart';

ReleatedProductsModel releatedProductsFromJson(String str) => ReleatedProductsModel.fromJson(json.decode(str));

class ReleatedProductsModel {
  List<Product> relatedProducts;
  List<Product> upsellProducts;
  List<Product> crossProducts;

  ReleatedProductsModel({
    this.relatedProducts,
    this.upsellProducts,
    this.crossProducts,
  });

  factory ReleatedProductsModel.fromJson(Map<String, dynamic> json) => ReleatedProductsModel(
    relatedProducts: json["relatedProducts"] == null ? null : List<Product>.from(json["relatedProducts"].map((x) => Product.fromJson(x))),
    upsellProducts: json["upsellProducts"] == null ? null : List<Product>.from(json["upsellProducts"].map((x) => Product.fromJson(x))),
    crossProducts: json["crossProducts"] == null ? null : List<Product>.from(json["crossProducts"].map((x) => Product.fromJson(x))),
  );
}