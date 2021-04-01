// To parse this JSON data, do
//
//     final stripeSourceModel = stripeSourceModelFromJson(jsonString);

import 'dart:convert';

StripeSourceModel stripeSourceModelFromJson(String str) => StripeSourceModel.fromJson(json.decode(str));

String stripeSourceModelToJson(StripeSourceModel data) => json.encode(data.toJson());

class StripeSourceModel {
  String id;
  String object;
  dynamic amount;
  Card card;
  String clientSecret;
  int created;
  dynamic currency;
  String flow;
  bool livemode;
  Metadata metadata;
  Owner owner;
  dynamic statementDescriptor;
  String status;
  String type;
  String usage;

  StripeSourceModel({
    this.id,
    this.object,
    this.amount,
    this.card,
    this.clientSecret,
    this.created,
    this.currency,
    this.flow,
    this.livemode,
    this.metadata,
    this.owner,
    this.statementDescriptor,
    this.status,
    this.type,
    this.usage,
  });

  factory StripeSourceModel.fromJson(Map<String, dynamic> json) => StripeSourceModel(
    id: json["id"] == null ? null : json["id"],
    object: json["object"] == null ? null : json["object"],
    amount: json["amount"],
    card: json["card"] == null ? null : Card.fromJson(json["card"]),
    clientSecret: json["client_secret"] == null ? null : json["client_secret"],
    created: json["created"] == null ? null : json["created"],
    currency: json["currency"],
    flow: json["flow"] == null ? null : json["flow"],
    livemode: json["livemode"] == null ? null : json["livemode"],
    metadata: json["metadata"] == null ? null : Metadata.fromJson(json["metadata"]),
    owner: json["owner"] == null ? null : Owner.fromJson(json["owner"]),
    statementDescriptor: json["statement_descriptor"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    usage: json["usage"] == null ? null : json["usage"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "object": object == null ? null : object,
    "amount": amount,
    "card": card == null ? null : card.toJson(),
    "client_secret": clientSecret == null ? null : clientSecret,
    "created": created == null ? null : created,
    "currency": currency,
    "flow": flow == null ? null : flow,
    "livemode": livemode == null ? null : livemode,
    "metadata": metadata == null ? null : metadata.toJson(),
    "owner": owner == null ? null : owner.toJson(),
    "statement_descriptor": statementDescriptor,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "usage": usage == null ? null : usage,
  };
}

class Card {
  int expMonth;
  int expYear;
  String last4;
  String country;
  String brand;
  String addressLine1Check;
  String addressZipCheck;
  String cvcCheck;
  String funding;
  String threeDSecure;
  dynamic name;
  dynamic tokenizationMethod;
  dynamic dynamicLast4;

  Card({
    this.expMonth,
    this.expYear,
    this.last4,
    this.country,
    this.brand,
    this.addressLine1Check,
    this.addressZipCheck,
    this.cvcCheck,
    this.funding,
    this.threeDSecure,
    this.name,
    this.tokenizationMethod,
    this.dynamicLast4,
  });

  factory Card.fromJson(Map<String, dynamic> json) => Card(
    expMonth: json["exp_month"] == null ? null : json["exp_month"],
    expYear: json["exp_year"] == null ? null : json["exp_year"],
    last4: json["last4"] == null ? null : json["last4"],
    country: json["country"] == null ? null : json["country"],
    brand: json["brand"] == null ? null : json["brand"],
    addressLine1Check: json["address_line1_check"] == null ? null : json["address_line1_check"],
    addressZipCheck: json["address_zip_check"] == null ? null : json["address_zip_check"],
    cvcCheck: json["cvc_check"] == null ? null : json["cvc_check"],
    funding: json["funding"] == null ? null : json["funding"],
    threeDSecure: json["three_d_secure"] == null ? null : json["three_d_secure"],
    name: json["name"],
    tokenizationMethod: json["tokenization_method"],
    dynamicLast4: json["dynamic_last4"],
  );

  Map<String, dynamic> toJson() => {
    "exp_month": expMonth == null ? null : expMonth,
    "exp_year": expYear == null ? null : expYear,
    "last4": last4 == null ? null : last4,
    "country": country == null ? null : country,
    "brand": brand == null ? null : brand,
    "address_line1_check": addressLine1Check == null ? null : addressLine1Check,
    "address_zip_check": addressZipCheck == null ? null : addressZipCheck,
    "cvc_check": cvcCheck == null ? null : cvcCheck,
    "funding": funding == null ? null : funding,
    "three_d_secure": threeDSecure == null ? null : threeDSecure,
    "name": name,
    "tokenization_method": tokenizationMethod,
    "dynamic_last4": dynamicLast4,
  };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
  );

  Map<String, dynamic> toJson() => {
  };
}

class Owner {
  Address address;
  dynamic email;
  String name;
  dynamic phone;
  dynamic verifiedAddress;
  dynamic verifiedEmail;
  dynamic verifiedName;
  dynamic verifiedPhone;

  Owner({
    this.address,
    this.email,
    this.name,
    this.phone,
    this.verifiedAddress,
    this.verifiedEmail,
    this.verifiedName,
    this.verifiedPhone,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => Owner(
    address: json["address"] == null ? null : Address.fromJson(json["address"]),
    email: json["email"],
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"],
    verifiedAddress: json["verified_address"],
    verifiedEmail: json["verified_email"],
    verifiedName: json["verified_name"],
    verifiedPhone: json["verified_phone"],
  );

  Map<String, dynamic> toJson() => {
    "address": address == null ? null : address.toJson(),
    "email": email,
    "name": name == null ? null : name,
    "phone": phone,
    "verified_address": verifiedAddress,
    "verified_email": verifiedEmail,
    "verified_name": verifiedName,
    "verified_phone": verifiedPhone,
  };
}

class Address {
  String city;
  String country;
  String line1;
  String line2;
  String postalCode;
  String state;

  Address({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postalCode,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    city: json["city"] == null ? null : json["city"],
    country: json["country"] == null ? null : json["country"],
    line1: json["line1"] == null ? null : json["line1"],
    line2: json["line2"] == null ? null : json["line2"],
    postalCode: json["postal_code"] == null ? null : json["postal_code"],
    state: json["state"] == null ? null : json["state"],
  );

  Map<String, dynamic> toJson() => {
    "city": city == null ? null : city,
    "country": country == null ? null : country,
    "line1": line1 == null ? null : line1,
    "line2": line2 == null ? null : line2,
    "postal_code": postalCode == null ? null : postalCode,
    "state": state == null ? null : state,
  };
}
