// To parse this JSON data, do
//
//     final productVariation = productVariationFromJson(jsonString);

import 'dart:convert';

List<ProductVariation> productVariationFromJson(String str) => List<ProductVariation>.from(json.decode(str).map((x) => ProductVariation.fromJson(x)));

String productVariationToJson(List<ProductVariation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductVariation {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String description;
  String permalink;
  String sku;
  String price;
  String regularPrice;
  String salePrice;
  dynamic dateOnSaleFrom;
  dynamic dateOnSaleFromGmt;
  dynamic dateOnSaleTo;
  dynamic dateOnSaleToGmt;
  bool onSale;
  String status;
  bool purchasable;
  bool virtual;
  bool downloadable;
  List<dynamic> downloads;
  int downloadLimit;
  int downloadExpiry;
  String taxStatus;
  String taxClass;
  bool manageStock;
  dynamic stockQuantity;
  String stockStatus;
  String backorders;
  bool backordersAllowed;
  bool backordered;
  String weight;
  Dimensions dimensions;
  String shippingClass;
  int shippingClassId;
  VariationImage image;
  List<VariationAttribute> attributes;
  int menuOrder;
  List<dynamic> metaData;
  Links links;

  ProductVariation({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.description,
    this.permalink,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.dateOnSaleFrom,
    this.dateOnSaleFromGmt,
    this.dateOnSaleTo,
    this.dateOnSaleToGmt,
    this.onSale,
    this.status,
    this.purchasable,
    this.virtual,
    this.downloadable,
    this.downloads,
    this.downloadLimit,
    this.downloadExpiry,
    this.taxStatus,
    this.taxClass,
    this.manageStock,
    this.stockQuantity,
    this.stockStatus,
    this.backorders,
    this.backordersAllowed,
    this.backordered,
    this.weight,
    this.dimensions,
    this.shippingClass,
    this.shippingClassId,
    this.image,
    this.attributes,
    this.menuOrder,
    this.metaData,
    this.links,
  });

  factory ProductVariation.fromJson(Map<String, dynamic> json) => ProductVariation(
    id: json["id"] == null ? null : json["id"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    description: json["description"] == null ? null : json["description"],
    permalink: json["permalink"] == null ? null : json["permalink"],
    sku: json["sku"] == null ? null : json["sku"],
    price: json["price"] == null || json["price"] == '' ? '0' : json["price"],
    regularPrice: json["regular_price"] == null || json["price"] == '' ? '0' : json["regular_price"],
    salePrice: json["sale_price"] == null ? null : json["sale_price"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleFromGmt: json["date_on_sale_from_gmt"],
    dateOnSaleTo: json["date_on_sale_to"],
    dateOnSaleToGmt: json["date_on_sale_to_gmt"],
    onSale: json["on_sale"] == null ? null : json["on_sale"],
    status: json["status"] == null ? null : json["status"],
    purchasable: json["purchasable"] == null ? null : json["purchasable"],
    virtual: json["virtual"] == null ? null : json["virtual"],
    downloadable: json["downloadable"] == null ? null : json["downloadable"],
    downloads: json["downloads"] == null ? null : List<dynamic>.from(json["downloads"].map((x) => x)),
    downloadLimit: json["download_limit"] == null ? null : json["download_limit"],
    downloadExpiry: json["download_expiry"] == null ? null : json["download_expiry"],
    taxStatus: json["tax_status"] == null ? null : json["tax_status"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    manageStock: json["manage_stock"] == null ? null : json["manage_stock"],
    stockQuantity: json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? null : json["stock_status"],
    backorders: json["backorders"] == null ? null : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? null : json["backorders_allowed"],
    backordered: json["backordered"] == null ? null : json["backordered"],
    weight: json["weight"] == null ? null : json["weight"],
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    shippingClass: json["shipping_class"] == null ? null : json["shipping_class"],
    shippingClassId: json["shipping_class_id"] == null ? null : json["shipping_class_id"],
    image: json["image"] == null ? null : VariationImage.fromJson(json["image"]),
    attributes: json["attributes"] == null ? null : List<VariationAttribute>.from(json["attributes"].map((x) => VariationAttribute.fromJson(x))),
    menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    metaData: json["meta_data"] == null ? null : List<dynamic>.from(json["meta_data"].map((x) => x)),
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "description": description == null ? null : description,
    "permalink": permalink == null ? null : permalink,
    "sku": sku == null ? null : sku,
    "price": price == null ? null : price,
    "regular_price": regularPrice == null ? null : regularPrice,
    "sale_price": salePrice == null ? null : salePrice,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_from_gmt": dateOnSaleFromGmt,
    "date_on_sale_to": dateOnSaleTo,
    "date_on_sale_to_gmt": dateOnSaleToGmt,
    "on_sale": onSale == null ? null : onSale,
    "status": status == null ? null : status,
    "purchasable": purchasable == null ? null : purchasable,
    "virtual": virtual == null ? null : virtual,
    "downloadable": downloadable == null ? null : downloadable,
    "downloads": downloads == null ? null : List<dynamic>.from(downloads.map((x) => x)),
    "download_limit": downloadLimit == null ? null : downloadLimit,
    "download_expiry": downloadExpiry == null ? null : downloadExpiry,
    "tax_status": taxStatus == null ? null : taxStatus,
    "tax_class": taxClass == null ? null : taxClass,
    "manage_stock": manageStock == null ? null : manageStock,
    "stock_quantity": stockQuantity,
    "stock_status": stockStatus == null ? null : stockStatus,
    "backorders": backorders == null ? null : backorders,
    "backorders_allowed": backordersAllowed == null ? null : backordersAllowed,
    "backordered": backordered == null ? null : backordered,
    "weight": weight == null ? null : weight,
    "dimensions": dimensions == null ? null : dimensions.toJson(),
    "shipping_class": shippingClass == null ? null : shippingClass,
    "shipping_class_id": shippingClassId == null ? null : shippingClassId,
    "image": image == null ? null : image.toJson(),
    "attributes": attributes == null ? null : List<dynamic>.from(attributes.map((x) => x.toJson())),
    "menu_order": menuOrder == null ? null : menuOrder,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
    "_links": links == null ? null : links.toJson(),
  };
}

class VariationAttribute {
  int id;
  String name;
  String option;

  VariationAttribute({
    this.id,
    this.name,
    this.option,
  });

  factory VariationAttribute.fromJson(Map<String, dynamic> json) => VariationAttribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    option: json["option"] == null ? null : json["option"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "option": option == null ? null : option,
  };
}

class Dimensions {
  String length;
  String width;
  String height;

  Dimensions({
    this.length,
    this.width,
    this.height,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    length: json["length"] == null ? null : json["length"],
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
  );

  Map<String, dynamic> toJson() => {
    "length": length == null ? null : length,
    "width": width == null ? null : width,
    "height": height == null ? null : height,
  };
}

class VariationImage {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String src;
  String name;
  String alt;

  VariationImage({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.src,
    this.name,
    this.alt,
  });

  factory VariationImage.fromJson(Map<String, dynamic> json) => VariationImage(
    id: json["id"] == null ? null : json["id"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    src: json["src"] == null ? null : json["src"],
    name: json["name"] == null ? null : json["name"],
    alt: json["alt"] == null ? null : json["alt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "src": src == null ? null : src,
    "name": name == null ? null : name,
    "alt": alt == null ? null : alt,
  };
}

class Links {
  List<Collection> self;
  List<Collection> collection;
  List<Collection> up;

  Links({
    this.self,
    this.collection,
    this.up,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? null : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: json["collection"] == null ? null : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    up: json["up"] == null ? null : List<Collection>.from(json["up"].map((x) => Collection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
    "up": up == null ? null : List<dynamic>.from(up.map((x) => x.toJson())),
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
