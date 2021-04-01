// To parse this JSON data, do
//
//     final stripeTokenModel = stripeTokenModelFromJson(jsonString);

import 'dart:convert';

StripeTokenModel stripeTokenModelFromJson(String str) => StripeTokenModel.fromJson(json.decode(str));

String stripeTokenModelToJson(StripeTokenModel data) => json.encode(data.toJson());

class StripeTokenModel {
  String id;
  String object;
  Card card;
  String clientIp;
  int created;
  bool livemode;
  String type;
  bool used;

  StripeTokenModel({
    this.id,
    this.object,
    this.card,
    this.clientIp,
    this.created,
    this.livemode,
    this.type,
    this.used,
  });

  factory StripeTokenModel.fromJson(Map<String, dynamic> json) => StripeTokenModel(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    card: json["card"] == null ? null : Card.fromJson(json["card"]),
    clientIp: json["client_ip"] == null ? null : json["client_ip"],
    created: json["created"] == null ? null : json["created"],
    livemode: json["livemode"] == null ? null : json["livemode"],
    type: json["type"] == null ? null : json["type"],
    used: json["used"] == null ? null : json["used"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "card": card == null ? null : card.toJson(),
    "client_ip": clientIp == null ? null : clientIp,
    "created": created == null ? null : created,
    "livemode": livemode == null ? null : livemode,
    "type": type == null ? null : type,
    "used": used == null ? null : used,
  };
}

class Card {
  String id;
  String object;
  String addressCity;
  String addressCountry;
  String addressLine1;
  String addressLine1Check;
  String addressLine2;
  String addressState;
  String addressZip;
  String addressZipCheck;
  String brand;
  String country;
  String cvcCheck;
  dynamic dynamicLast4;
  int expMonth;
  int expYear;
  String funding;
  String last4;
  Metadata metadata;
  String name;
  dynamic tokenizationMethod;

  Card({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.funding,
    this.last4,
    this.metadata,
    this.name,
    this.tokenizationMethod,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    addressCity: json["address_city"] == null ? null : json["address_city"],
    addressCountry: json["address_country"] == null ? null : json["address_country"],
    addressLine1: json["address_line1"] == null ? null : json["address_line1"],
    addressLine1Check: json["address_line1_check"] == null ? null : json["address_line1_check"],
    addressLine2: json["address_line2"] == null ? null : json["address_line2"],
    addressState: json["address_state"] == null ? null : json["address_state"],
    addressZip: json["address_zip"] == null ? null : json["address_zip"],
    addressZipCheck: json["address_zip_check"] == null ? null : json["address_zip_check"],
    brand: json["brand"] == null ? null : json["brand"],
    country: json["country"] == null ? null : json["country"],
    cvcCheck: json["cvc_check"] == null ? null : json["cvc_check"],
    dynamicLast4: json["dynamic_last4"],
    expMonth: json["exp_month"] == null ? null : json["exp_month"],
    expYear: json["exp_year"] == null ? null : json["exp_year"],
    funding: json["funding"] == null ? null : json["funding"],
    last4: json["last4"] == null ? null : json["last4"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    name: json["name"] == null ? null : json["name"],
    tokenizationMethod: json["tokenization_method"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "address_city": addressCity == null ? null : addressCity,
    "address_country": addressCountry == null ? null : addressCountry,
    "address_line1": addressLine1 == null ? null : addressLine1,
    "address_line1_check": addressLine1Check == null ? null : addressLine1Check,
    "address_line2": addressLine2 == null ? null : addressLine2,
    "address_state": addressState == null ? null : addressState,
    "address_zip": addressZip == null ? null : addressZip,
    "address_zip_check": addressZipCheck == null ? null : addressZipCheck,
    "brand": brand == null ? null : brand,
    "country": country == null ? null : country,
    "cvc_check": cvcCheck == null ? null : cvcCheck,
    "dynamic_last4": dynamicLast4,
    "exp_month": expMonth == null ? null : expMonth,
    "exp_year": expYear == null ? null : expYear,
    "funding": funding == null ? null : funding,
    "last4": last4 == null ? null : last4,
    "metadata": metadata == null ? null : metadata.toJson(),
    "name": name == null ? null : name,
    "tokenization_method": tokenizationMethod,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}
