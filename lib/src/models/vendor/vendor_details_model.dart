// To parse this JSON data, do
//
//     final vendorDetails = vendorDetailsFromJson(jsonString);

import 'dart:convert';

import '../blocks_model.dart';
import '../product_model.dart';

VendorDetailsModel vendorDetailsModelFromJson(String str) => VendorDetailsModel.fromJson(json.decode(str));

class VendorDetailsModel {
  Store store;
  List<Block> blocks;
  List<Product> recentProducts;



  VendorDetailsModel({
    this.store,
    this.blocks,
    this.recentProducts,
  });

  factory VendorDetailsModel.fromJson(Map<String, dynamic> json) => VendorDetailsModel(
    store: json["store"] == null ? null : Store.fromJson(json["store"]),
    blocks: json["blocks"] == null ? null : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    recentProducts: json["recentProducts"] == null ? null : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),

  );

}

class Store {
  int id;
  String name;
  String icon;
  String banner;
  List<Banner> banners;
  String video;
  Address address;
  Social social;
  String email;
  String phone;
  String description;
  String latitude;
  String longitude;
  double averageRating;
  int ratingCount;
  int productsCount;

  Store({
    this.id,
    this.name,
    this.icon,
    this.banner,
    this.banners,
    this.video,
    this.address,
    this.social,
    this.email,
    this.description,
    this.latitude,
    this.longitude,
    this.averageRating,
    this.ratingCount,
    this.productsCount,
    this.phone
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? '' : json["name"],
    icon: json["icon"] == null ? null : json["icon"],
    banner: json["banner"] == null || json["banner"] == false ? null : json["banner"],
    video: json["video"] == null ? null : json["video"],
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    social: json["social"] == null ? null : Social.fromJson(json["social"]),
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    description: json["description"] == null ? null : json["description"],
    latitude: json["latitude"] == null ? '0' : json["latitude"],
    longitude: json["longitude"] == null ? '0' : json["longitude"],
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

  Map<String, dynamic> toJson() => {
    "street_1": street1 == null ? null : street1,
    "street_2": street2 == null ? null : street2,
    "city": city == null ? null : city,
    "zip": zip == null ? null : zip,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
  };
}

class Banner {
  String image;
  String link;

  Banner({
    this.image,
    this.link,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
    image: json["image"] == null ? null : json["image"],
    link: json["link"] == null ? null : json["link"],
  );

  Map<String, dynamic> toJson() => {
    "image": image == null ? null : image,
    "link": link == null ? null : link,
  };
}

class Social {
  String twitter;
  String fb;
  String instagram;
  String youtube;
  String linkedin;
  String gplus;
  String snapchat;
  String pinterest;
  String googleplus;
  String facebook;

  Social({
    this.twitter,
    this.fb,
    this.instagram,
    this.youtube,
    this.linkedin,
    this.gplus,
    this.snapchat,
    this.pinterest,
    this.googleplus,
    this.facebook,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
    twitter: json["twitter"] == null ? null : json["twitter"],
    fb: json["fb"] == null ? null : json["fb"],
    instagram: json["instagram"] == null ? null : json["instagram"],
    youtube: json["youtube"] == null ? null : json["youtube"],
    linkedin: json["linkedin"] == null ? null : json["linkedin"],
    gplus: json["gplus"] == null ? null : json["gplus"],
    snapchat: json["snapchat"] == null ? null : json["snapchat"],
    pinterest: json["pinterest"] == null ? null : json["pinterest"],
    googleplus: json["googleplus"] == null ? null : json["googleplus"],
    facebook: json["facebook"] == null ? null : json["facebook"],
  );

  Map<String, dynamic> toJson() => {
    "twitter": twitter == null ? null : twitter,
    "fb": fb == null ? null : fb,
    "instagram": instagram == null ? null : instagram,
    "youtube": youtube == null ? null : youtube,
    "linkedin": linkedin == null ? null : linkedin,
    "gplus": gplus == null ? null : gplus,
    "snapchat": snapchat == null ? null : snapchat,
    "pinterest": pinterest == null ? null : pinterest,
    "googleplus": googleplus == null ? null : googleplus,
    "facebook": facebook == null ? null : facebook,
  };
}

