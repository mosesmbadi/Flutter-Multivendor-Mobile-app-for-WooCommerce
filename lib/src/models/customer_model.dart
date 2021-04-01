// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  int id;
  String email;
  String firstName;
  String lastName;
  String role;
  String username;
  Address billing;
  Address shipping;
  bool isPayingCustomer;
  int ordersCount;
  String totalSpent;
  String avatarUrl;
  List<MetaDatum> metaData;
  String guest;

  Customer({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.role,
    this.username,
    this.billing,
    this.shipping,
    this.isPayingCustomer,
    this.ordersCount,
    this.totalSpent,
    this.avatarUrl,
    this.metaData,
    this.guest
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"] == null ? 0 : json["id"],
    email: json["email"] == null ? null : json["email"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    role: json["role"] == null ? null : json["role"],
    username: json["username"] == null ? null : json["username"],
    billing: json["billing"] == null ? null : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? null : Address.fromJson(json["shipping"]),
    isPayingCustomer: json["is_paying_customer"] == null ? null : json["is_paying_customer"],
    ordersCount: json["orders_count"] == null ? null : json["orders_count"],
    totalSpent: json["total_spent"] == null ? null : json["total_spent"],
    avatarUrl: json["avatar_url"] == null ? null : json["avatar_url"],
    metaData: json["meta_data"] == null ? null : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    guest: json["guest"] == null ? null : json["guest"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "email": email == null ? null : email,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "role": role == null ? null : role,
    "username": username == null ? null : username,
    "billing": billing == null ? null : billing.toJson(),
    "shipping": shipping == null ? null : shipping.toJson(),
    "is_paying_customer": isPayingCustomer == null ? null : isPayingCustomer,
    "orders_count": ordersCount == null ? null : ordersCount,
    "total_spent": totalSpent == null ? null : totalSpent,
    "avatar_url": avatarUrl == null ? null : avatarUrl,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
  };
}

class Address {
  String firstName;
  String lastName;
  String company;
  String address1;
  String address2;
  String city;
  String postcode;
  String country;
  String state;
  String email;
  String phone;

  Address({
    this.firstName,
    this.lastName,
    this.company,
    this.address1,
    this.address2,
    this.city,
    this.postcode,
    this.country,
    this.state,
    this.email,
    this.phone,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    firstName: json["first_name"] == null ? '' : json["first_name"],
    lastName: json["last_name"] == null ? '' : json["last_name"],
    company: json["company"] == null ? '' : json["company"],
    address1: json["address_1"] == null ? '' : json["address_1"],
    address2: json["address_2"] == null ? '' : json["address_2"],
    city: json["city"] == null ? '' : json["city"],
    postcode: json["postcode"] == null ? '' : json["postcode"],
    country: json["country"] == null ? '' : json["country"],
    state: json["state"] == null ? '' : json["state"],
    email: json["email"] == null ? '' : json["email"],
    phone: json["phone"] == null ? '' : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "company": company == null ? null : company,
    "address_1": address1 == null ? null : address1,
    "address_2": address2 == null ? null : address2,
    "city": city == null ? null : city,
    "postcode": postcode == null ? null : postcode,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
  };
}

class MetaDatum {
  int id;
  String key;
  dynamic value;

  MetaDatum({
    this.id,
    this.key,
    this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) => MetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}
