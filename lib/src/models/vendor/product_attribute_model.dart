// To parse this JSON data, do
//
//     final productAttribute = productAttributeFromJson(jsonString);

import 'dart:convert';

List<ProductAttribute> productAttributeFromJson(String str) => List<ProductAttribute>.from(json.decode(str).map((x) => ProductAttribute.fromJson(x)));

String productAttributeToJson(List<ProductAttribute> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductAttribute {
  int id;
  String name;
  String slug;
  String type;
  String orderBy;
  bool hasArchives;
  Links links;

  ProductAttribute({
    this.id,
    this.name,
    this.slug,
    this.type,
    this.orderBy,
    this.hasArchives,
    this.links,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) => ProductAttribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    type: json["type"] == null ? null : json["type"],
    orderBy: json["order_by"] == null ? null : json["order_by"],
    hasArchives: json["has_archives"] == null ? null : json["has_archives"],
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "type": type == null ? null : type,
    "order_by": orderBy == null ? null : orderBy,
    "has_archives": hasArchives == null ? null : hasArchives,
    "_links": links == null ? null : links.toJson(),
  };
}

class Links {
  List<Collection> self;
  List<Collection> collection;

  Links({
    this.self,
    this.collection,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? null : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: json["collection"] == null ? null : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
  };
}

class Collection {
  String href;

  Collection({
    this.href,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}


List<AttributeTerms> attributeTermsFromJson(String str) => List<AttributeTerms>.from(json.decode(str).map((x) => AttributeTerms.fromJson(x)));

String attributeTermsToJson(List<AttributeTerms> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AttributeTerms {
  int id;
  String name;
  String slug;
  String description;
  int menuOrder;
  int count;
  Links links;

  AttributeTerms({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.menuOrder,
    this.count,
    this.links,
  });

  factory AttributeTerms.fromJson(Map<String, dynamic> json) => AttributeTerms(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
    description: json["description"] == null ? null : json["description"],
    menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    count: json["count"] == null ? null : json["count"],
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
    "description": description == null ? null : description,
    "menu_order": menuOrder == null ? null : menuOrder,
    "count": count == null ? null : count,
    "_links": links == null ? null : links.toJson(),
  };
}
