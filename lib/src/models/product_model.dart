// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<Product> productModelFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  int id;
  String name;
  String type;
  String status;
  bool featured;
  String catalogVisibility;
  String description;
  String shortDescription;
  String permalink;
  String sku;
  double price;
  double regularPrice;
  double salePrice;
  //DateTime dateOnSaleFromGmt;
  //DateTime dateOnSaleToGmt;
  bool onSale;
  bool purchasable;
  int totalSales;
  bool virtual;
  bool downloadable;
  String externalUrl;
  String buttonText;
  bool manageStock;
  int stockQuantity;
  String stockStatus;
  String backorders;
  bool backordersAllowed;
  bool backordered;
  bool soldIndividually;
  String weight;
  Dimensions dimensions;
  //bool shippingRequired;
  //bool shippingTaxable;
  //String shippingClass;
  bool reviewsAllowed;
  String averageRating;
  int ratingCount;
  List<int> relatedIds;
  List<int> upsellIds;
  List<int> crossSellIds;
  //int parentId;
  String purchaseNote;
  List<int> categories;
  List<dynamic> tags;
  List<Mage> images;
  List<Attribute> attributes;
  List<dynamic> groupedProducts;
  //int menuOrder;
  List<MetaDatum> metaData;
  //String storeName;
  List<AvailableVariation> availableVariations;
  List<VariationOption> variationOptions;
  String variationId;
  String formattedPrice;
  String formattedSalesPrice;
  Vendor vendor;
  List<Product> children;

  Product({
    this.id,
    this.name,
    this.type,
    this.status,
    this.featured,
    this.catalogVisibility,
    this.description,
    this.shortDescription,
    this.permalink,
    this.sku,
    this.price,
    this.regularPrice,
    this.salePrice,
    //this.dateOnSaleFromGmt,
    //this.dateOnSaleToGmt,
    this.onSale,
    this.purchasable,
    this.totalSales,
    this.virtual,
    this.downloadable,
    this.externalUrl,
    this.buttonText,
    this.manageStock,
    this.stockQuantity,
    this.stockStatus,
    this.backorders,
    this.backordersAllowed,
    this.backordered,
    this.soldIndividually,
    this.weight,
    this.dimensions,
    //this.shippingRequired,
    //this.shippingTaxable,
    //this.shippingClass,
    this.reviewsAllowed,
    this.averageRating,
    this.ratingCount,
    this.relatedIds,
    this.upsellIds,
    this.crossSellIds,
    //this.parentId,
    this.purchaseNote,
    this.categories,
    this.tags,
    this.images,
    this.attributes,
    this.groupedProducts,
    //this.menuOrder,
    this.metaData,
    //this.storeName,
    this.availableVariations,
    this.variationOptions,
    this.variationId,
    this.formattedPrice,
    this.formattedSalesPrice,
    this.vendor,
    this.children
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    type: json["type"] == null ? null : json["type"],
    status: json["status"] == null ? null : json["status"],
    featured: json["featured"] == null ? null : json["featured"],
    catalogVisibility: json["catalog_visibility"] == null ? null : json["catalog_visibility"],
    description: json["description"] == null ? null : json["description"],
    shortDescription: json["short_description"] == null ? null : json["short_description"],
    permalink: json["permalink"] == null ? null : json["permalink"],
    sku: json["sku"] == null ? null : json["sku"],
    formattedPrice: json["formated_price"] == null ? null : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? null : json["formated_sales_price"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    regularPrice: json["regular_price"] == null ? null : json["regular_price"].toDouble(),
    salePrice: json["sale_price"] == null ? null : json["sale_price"].toDouble(),
    //dateOnSaleFromGmt: json["date_on_sale_from_gmt"] == null ? null : DateTime.parse(json["date_on_sale_from_gmt"]),
    //dateOnSaleToGmt: json["date_on_sale_to_gmt"] == null ? null : DateTime.parse(json["date_on_sale_to_gmt"]),
    onSale: json["on_sale"] == null ? null : json["on_sale"],
    purchasable: json["purchasable"] == null ? null : json["purchasable"],
    totalSales: json["total_sales"] == null ? null : json["total_sales"],
    virtual: json["virtual"] == null ? null : json["virtual"],
    downloadable: json["downloadable"] == null ? null : json["downloadable"],
    externalUrl: json["external_url"] == null ? null : json["external_url"],
    buttonText: json["button_text"] == null ? null : json["button_text"],
    manageStock: json["manage_stock"] == null ? null : json["manage_stock"],
    stockQuantity: json["stock_quantity"] == null ? null : json["stock_quantity"],
    stockStatus: json["stock_status"] == null ? null : json["stock_status"],
    backorders: json["backorders"] == null ? null : json["backorders"],
    backordersAllowed: json["backorders_allowed"] == null ? null : json["backorders_allowed"],
    backordered: json["backordered"] == null ? null : json["backordered"],
    soldIndividually: json["sold_individually"] == null ? null : json["sold_individually"],
    weight: json["weight"] == null ? null : json["weight"],
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    //shippingRequired: json["shipping_required"] == null ? null : json["shipping_required"],
    //shippingTaxable: json["shipping_taxable"] == null ? null : json["shipping_taxable"],
    //shippingClass: json["shipping_class"] == null ? null : json["shipping_class"],
    reviewsAllowed: json["reviews_allowed"] == null ? null : json["reviews_allowed"],
    averageRating: json["average_rating"] == null ? null : json["average_rating"],
    ratingCount: json["rating_count"] == null ? null : json["rating_count"],
    relatedIds: json["related_ids"] == null ? null : List<int>.from(json["related_ids"].map((x) => x)),
    upsellIds: json["upsell_ids"] == null ? null : List<int>.from(json["upsell_ids"].map((x) => x)),
    crossSellIds: json["cross_sell_ids"] == null ? null : List<int>.from(json["cross_sell_ids"].map((x) => x)),
    //parentId: json["parent_id"] == null ? null : json["parent_id"],
    purchaseNote: json["purchase_note"] == null ? null : json["purchase_note"],
    categories: json["categories"] == null ? [] :  List<int>.from(json["categories"].map((x) => x)),
    tags: json["tags"] == null ? null : List<dynamic>.from(json["tags"].map((x) => x)),
    images: json["images"] == null ? null : List<Mage>.from(json["images"].map((x) => Mage.fromJson(x))),
    attributes: json["attributes"] == null ? null : List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    groupedProducts: json["grouped_products"] == null ? null : List<dynamic>.from(json["grouped_products"].map((x) => x)),
    //menuOrder: json["menu_order"] == null ? null : json["menu_order"],
    metaData: json["meta_data"] == null ? null : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    //storeName: json["store_name"] == null ? null : json["store_name"],
    availableVariations: json["availableVariations"] == null ? null : List<AvailableVariation>.from(json["availableVariations"].map((x) => AvailableVariation.fromJson(x))),
    variationOptions: json["variationOptions"] == null ? null : List<VariationOption>.from(json["variationOptions"].map((x) => VariationOption.fromJson(x))),
    variationId: null,
    vendor: json["vendor"] == null ? null : Vendor.fromJson(json["vendor"]),
    children: json['children'] == null ? null : List<Product>.from(json["children"].map((x) => Product.fromJson(x))),
  );
}


class Vendor {
  dynamic id;
  String name;
  String icon;

  Vendor({
    this.id,
    this.name,
    this.icon,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
    id: json["id"],
    name: json["name"] == null ? null : json["name"],
    icon: json["icon"] == null || json["icon"] == false ? null : json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name == null ? null : name,
    "icon": icon == null ? null : icon,
  };
}

class Attribute {
  int id;
  String name;
  int position;
  bool visible;
  bool variation;
  List<String> options;

  Attribute({
    this.id,
    this.name,
    this.position,
    this.visible,
    this.variation,
    this.options,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    position: json["position"] == null ? null : json["position"],
    visible: json["visible"] == null ? null : json["visible"],
    variation: json["variation"] == null ? null : json["variation"],
    options: json["options"] == null ? null : List<String>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "position": position == null ? null : position,
    "visible": visible == null ? null : visible,
    "variation": variation == null ? null : variation,
    "options": options == null ? null : List<dynamic>.from(options.map((x) => x)),
  };
}

class ProductCategory {
  int id;
  String name;
  String slug;

  ProductCategory({
    this.id,
    this.name,
    this.slug,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) => ProductCategory(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    slug: json["slug"] == null ? null : json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "slug": slug == null ? null : slug,
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

class Mage {
  int id;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String src;
  String name;
  String alt;

  Mage({
    this.id,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.src,
    this.name,
    this.alt,
  });

  factory Mage.fromJson(Map<String, dynamic> json) => Mage(
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
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value,
  };
}

class AvailableVariation {
  String availabilityHtml;
  bool backordersAllowed;
  Dimensions dimensions;
  String dimensionsHtml;
  double displayPrice;
  double displayRegularPrice;
  AvailableVariationImage image;
  String imageId;
  bool isDownloadable;
  bool isInStock;
  bool isPurchasable;
  String isSoldIndividually;
  bool isVirtual;
  int maxQty;
  int minQty;
  String priceHtml;
  String sku;
  String variationDescription;
  int variationId;
  bool variationIsActive;
  bool variationIsVisible;
  String weight;
  String weightHtml;
  List<Option> option;
  String formattedPrice;
  String formattedSalesPrice;

  AvailableVariation({
    this.availabilityHtml,
    this.backordersAllowed,
    this.dimensions,
    this.dimensionsHtml,
    this.displayPrice,
    this.displayRegularPrice,
    this.image,
    this.imageId,
    this.isDownloadable,
    this.isInStock,
    this.isPurchasable,
    this.isSoldIndividually,
    this.isVirtual,
    this.maxQty,
    this.minQty,
    this.priceHtml,
    this.sku,
    this.variationDescription,
    this.variationId,
    this.variationIsActive,
    this.variationIsVisible,
    this.weight,
    this.weightHtml,
    this.option,
    this.formattedPrice,
    this.formattedSalesPrice
  });

  factory AvailableVariation.fromJson(Map<String, dynamic> json) {
    return AvailableVariation(
    //availabilityHtml: json["availability_html"] == null ? null : json["availability_html"],
    backordersAllowed: json["backorders_allowed"] == null ? null : json["backorders_allowed"],
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    //dimensionsHtml: json["dimensions_html"] == null ? null : json["dimensions_html"],
    displayPrice: json["display_price"] == null ? null : json["display_price"].toDouble(),
    displayRegularPrice: json["display_regular_price"] == null ? null : json["display_regular_price"].toDouble(),
    image: json['image'] is Map<String, dynamic> ? AvailableVariationImage.fromJson(json["image"]) : null,
    //imageId: json["image_id"] == null ? null : json["image_id"],
    //isDownloadable: json["is_downloadable"] == null ? null : json["is_downloadable"],
    isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
    isPurchasable: json["is_purchasable"] == null ? null : json["is_purchasable"],
    //isSoldIndividually: json["is_sold_individually"] == null ? null : json["is_sold_individually"],
    //isVirtual: json["is_virtual"] == null ? null : json["is_virtual"],
    //maxQty: (json["max_qty"] == null || json["max_qty"] == '') ? null : json["max_qty"],
    //minQty: json["min_qty"] == null ? null : json["min_qty"],
    //priceHtml: json["price_html"] == null ? null : json["price_html"],
    sku: json["sku"] == null ? null : json["sku"],
    variationDescription: json["variation_description"] == null ? null : json["variation_description"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    //variationIsActive: json["variation_is_active"] == null ? null : json["variation_is_active"],
    //variationIsVisible: json["variation_is_visible"] == null ? null : json["variation_is_visible"],
    //weight: json["weight"] == null ? null : json["weight"],
    //weightHtml: json["weight_html"] == null ? null : json["weight_html"],
    option: json["option"] == null ? null : List<Option>.from(json["option"].map((x) => Option.fromJson(x))),
    formattedPrice: json["formated_price"] == null ? null : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? null : json["formated_sales_price"],
  );
  }
}

class Option {
  String key;
  String value;

  Option({
    this.key,
    this.value,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}

class AvailableVariationImage {
  String title;
  String caption;
  String url;
  //String alt;
  String src;
  //String srcset;
  String sizes;
  String fullSrc;
  int fullSrcW;
  int fullSrcH;
  String galleryThumbnailSrc;
  int galleryThumbnailSrcW;
  int galleryThumbnailSrcH;
  String thumbSrc;
  int thumbSrcW;
  int thumbSrcH;
  int srcW;
  int srcH;

  AvailableVariationImage({
    this.title,
    this.caption,
    this.url,
    //this.alt,
    this.src,
    //this.srcset,
    this.sizes,
    this.fullSrc,
    this.fullSrcW,
    this.fullSrcH,
    this.galleryThumbnailSrc,
    this.galleryThumbnailSrcW,
    this.galleryThumbnailSrcH,
    this.thumbSrc,
    this.thumbSrcW,
    this.thumbSrcH,
    this.srcW,
    this.srcH,
  });

  factory AvailableVariationImage.fromJson(Map<String, dynamic> json) => AvailableVariationImage(
    title: json["title"] == null ? null : json["title"],
    //caption: json["caption"] == null ? null : json["caption"],
    url: json["url"] == null ? null : json["url"],
    //alt: json["alt"] == null ? null : json["alt"],
    src: json["src"] == null ? null : json["src"],
    //srcset: json["srcset"] == null ? null : json["srcset"],
    //sizes: json["sizes"] == null ? null : json["sizes"],
    fullSrc: json["full_src"] == null ? null : json["full_src"],
    //fullSrcW: json["full_src_w"] == null ? null : json["full_src_w"],
    //fullSrcH: json["full_src_h"] == null ? null : json["full_src_h"],
    galleryThumbnailSrc: json["gallery_thumbnail_src"] == null ? null : json["gallery_thumbnail_src"],
    //galleryThumbnailSrcW: json["gallery_thumbnail_src_w"] == null ? null : json["gallery_thumbnail_src_w"],
    //galleryThumbnailSrcH: json["gallery_thumbnail_src_h"] == null ? null : json["gallery_thumbnail_src_h"],
    thumbSrc: json["thumb_src"] == null ? null : json["thumb_src"],
    //thumbSrcW: json["thumb_src_w"] == null ? null : json["thumb_src_w"],
    //thumbSrcH: json["thumb_src_h"] == null ? null : json["thumb_src_h"],
    //srcW: json["src_w"] == null ? null : json["src_w"],
    //srcH: json["src_h"] == null ? null : json["src_h"],
  );
}

class VariationOption {
  String name;
  List<String> options;
  String attribute;
  String selected;

  VariationOption({
    this.name,
    this.options,
    this.attribute,
    this.selected,
  });

  factory VariationOption.fromJson(Map<String, dynamic> json) => VariationOption(
    name: json["name"] == null ? null : json["name"],
    options: json["options"] == null ? null : List<String>.from(json["options"].map((x) => x)),
    attribute: json["attribute"] == null ? null : json["attribute"],
    selected: null,
  );
}

