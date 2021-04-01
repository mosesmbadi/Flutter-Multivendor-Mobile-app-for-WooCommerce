// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

List<StoreModel> storeModelFromJson(String str) => List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

class StoreModel {
  int id;
  String name;
  String icon;
  String banner;
  Address address;
  String description;
  String latitude;
  String longitude;
  double averageRating;
  int ratingCount;
  int productsCount;

  StoreModel({
    this.id,
    this.name,
    this.icon,
    this.banner,
    this.address,
    this.description,
    this.latitude,
    this.longitude,
    this.averageRating,
    this.ratingCount,
    this.productsCount,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    icon: (json["icon"] == null || json["icon"] == false) ? '' : json["icon"],
    banner: (json["icon"] == null || json["icon"] == false) ? '' : json["banner"],
    //address: json["address"] == null ? null : Address.fromJson(json["address"]),
    description: json["description"] == null ? null : json["description"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    averageRating: json["average_rating"] == null ? null : json["average_rating"].toDouble(),
    ratingCount: json["rating_count"] == null ? null : json["rating_count"],
    productsCount: json["products_count"] == null ? null : json["products_count"],
  );

}

class Address {
  String street1;
  String street2;
  String city;
  String zip;
  String country;
  String state;

  Address({
    this.street1,
    this.street2,
    this.city,
    this.zip,
    this.country,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street1: json["street_1"] == null ? null : json["street_1"],
    street2: json["street_2"] == null ? null : json["street_2"],
    city: json["city"] == null ? null : json["city"],
    zip: json["zip"] == null ? null : json["zip"],
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
  );

}
