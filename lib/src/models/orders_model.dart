// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

import 'customer_model.dart';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int id;
  int parentId;
  String number;
  String orderKey;
  String createdVia;
  String version;
  String status;
  String currency;
  DateTime dateCreated;
  DateTime dateCreatedGmt;
  DateTime dateModified;
  DateTime dateModifiedGmt;
  String discountTotal;
  String discountTax;
  String shippingTotal;
  String shippingTax;
  String cartTax;
  String total;
  String totalTax;
  bool pricesIncludeTax;
  int customerId;
  String customerIpAddress;
  String customerUserAgent;
  String customerNote;
  Address billing;
  Address shipping;
  String paymentMethod;
  String paymentMethodTitle;
  String transactionId;
  dynamic datePaid;
  dynamic datePaidGmt;
  dynamic dateCompleted;
  dynamic dateCompletedGmt;
  String cartHash;
  List<MetaDatum> metaData;
  List<LineItem> lineItems;
  List<dynamic> taxLines;
  List<ShippingLine> shippingLines;
  List<dynamic> feeLines;
  List<dynamic> couponLines;
  List<dynamic> refunds;
  int decimals;

  Order({
    this.id,
    this.parentId,
    this.number,
    this.orderKey,
    this.createdVia,
    this.version,
    this.status,
    this.currency,
    this.dateCreated,
    this.dateCreatedGmt,
    this.dateModified,
    this.dateModifiedGmt,
    this.discountTotal,
    this.discountTax,
    this.shippingTotal,
    this.shippingTax,
    this.cartTax,
    this.total,
    this.totalTax,
    this.pricesIncludeTax,
    this.customerId,
    this.customerIpAddress,
    this.customerUserAgent,
    this.customerNote,
    this.billing,
    this.shipping,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.transactionId,
    this.datePaid,
    this.datePaidGmt,
    this.dateCompleted,
    this.dateCompletedGmt,
    this.cartHash,
    this.metaData,
    this.lineItems,
    this.taxLines,
    this.shippingLines,
    this.feeLines,
    this.couponLines,
    this.refunds,
    this.decimals,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"] == null ? null : json["id"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    number: json["number"] == null ? null : json["number"],
    orderKey: json["order_key"] == null ? null : json["order_key"],
    createdVia: json["created_via"] == null ? null : json["created_via"],
    version: json["version"] == null ? null : json["version"],
    status: json["status"] == null ? null : json["status"],
    currency: json["currency"] == null ? null : json["currency"],
    dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
    dateCreatedGmt: json["date_created_gmt"] == null ? null : DateTime.parse(json["date_created_gmt"]),
    dateModified: json["date_modified"] == null ? null : DateTime.parse(json["date_modified"]),
    dateModifiedGmt: json["date_modified_gmt"] == null ? null : DateTime.parse(json["date_modified_gmt"]),
    discountTotal: json["discount_total"] == null ? null : json["discount_total"],
    discountTax: json["discount_tax"] == null ? null : json["discount_tax"],
    shippingTotal: json["shipping_total"] == null ? null : json["shipping_total"],
    shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"],
    cartTax: json["cart_tax"] == null ? null : json["cart_tax"],
    total: json["total"] == null ? null : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    pricesIncludeTax: json["prices_include_tax"] == null ? null : json["prices_include_tax"],
    customerId: json["customer_id"] == null ? null : json["customer_id"],
    customerIpAddress: json["customer_ip_address"] == null ? null : json["customer_ip_address"],
    customerUserAgent: json["customer_user_agent"] == null ? null : json["customer_user_agent"],
    customerNote: json["customer_note"] == null ? null : json["customer_note"],
    billing: json["billing"] == null ? null : Address.fromJson(json["billing"]),
    shipping: json["shipping"] == null ? null : Address.fromJson(json["shipping"]),
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    paymentMethodTitle: json["payment_method_title"] == null ? null : json["payment_method_title"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    datePaid: json["date_paid"],
    datePaidGmt: json["date_paid_gmt"],
    dateCompleted: json["date_completed"],
    dateCompletedGmt: json["date_completed_gmt"],
    cartHash: json["cart_hash"] == null ? null : json["cart_hash"],
    metaData: json["meta_data"] == null ? null : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
    lineItems: json["line_items"] == null ? null : List<LineItem>.from(json["line_items"].map((x) => LineItem.fromJson(x))),
    taxLines: json["tax_lines"] == null ? null : List<dynamic>.from(json["tax_lines"].map((x) => x)),
    shippingLines: json["shipping_lines"] == null ? null : List<ShippingLine>.from(json["shipping_lines"].map((x) => ShippingLine.fromJson(x))),
    feeLines: json["fee_lines"] == null ? null : List<dynamic>.from(json["fee_lines"].map((x) => x)),
    couponLines: json["coupon_lines"] == null ? null : List<dynamic>.from(json["coupon_lines"].map((x) => x)),
    refunds: json["refunds"] == null ? null : List<dynamic>.from(json["refunds"].map((x) => x)),
    decimals: json["decimals"] == null ? null : json["decimals"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "parent_id": parentId == null ? null : parentId,
    "number": number == null ? null : number,
    "order_key": orderKey == null ? null : orderKey,
    "created_via": createdVia == null ? null : createdVia,
    "version": version == null ? null : version,
    "status": status == null ? null : status,
    "currency": currency == null ? null : currency,
    "date_created": dateCreated == null ? null : dateCreated.toIso8601String(),
    "date_created_gmt": dateCreatedGmt == null ? null : dateCreatedGmt.toIso8601String(),
    "date_modified": dateModified == null ? null : dateModified.toIso8601String(),
    "date_modified_gmt": dateModifiedGmt == null ? null : dateModifiedGmt.toIso8601String(),
    "discount_total": discountTotal == null ? null : discountTotal,
    "discount_tax": discountTax == null ? null : discountTax,
    "shipping_total": shippingTotal == null ? null : shippingTotal,
    "shipping_tax": shippingTax == null ? null : shippingTax,
    "cart_tax": cartTax == null ? null : cartTax,
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
    "prices_include_tax": pricesIncludeTax == null ? null : pricesIncludeTax,
    "customer_id": customerId == null ? null : customerId,
    "customer_ip_address": customerIpAddress == null ? null : customerIpAddress,
    "customer_user_agent": customerUserAgent == null ? null : customerUserAgent,
    "customer_note": customerNote == null ? null : customerNote,
    "billing": billing == null ? null : billing.toJson(),
    "shipping": shipping == null ? null : shipping.toJson(),
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payment_method_title": paymentMethodTitle == null ? null : paymentMethodTitle,
    "transaction_id": transactionId == null ? null : transactionId,
    "date_paid": datePaid,
    "date_paid_gmt": datePaidGmt,
    "date_completed": dateCompleted,
    "date_completed_gmt": dateCompletedGmt,
    "cart_hash": cartHash == null ? null : cartHash,
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
    "line_items": lineItems == null ? null : List<dynamic>.from(lineItems.map((x) => x.toJson())),
    "tax_lines": taxLines == null ? null : List<dynamic>.from(taxLines.map((x) => x)),
    "shipping_lines": shippingLines == null ? null : List<dynamic>.from(shippingLines.map((x) => x.toJson())),
    "fee_lines": feeLines == null ? null : List<dynamic>.from(feeLines.map((x) => x)),
    "coupon_lines": couponLines == null ? null : List<dynamic>.from(couponLines.map((x) => x)),
    "refunds": refunds == null ? null : List<dynamic>.from(refunds.map((x) => x)),
  };
}

class LineItem {
  int id;
  String name;
  int productId;
  int variationId;
  int quantity;
  String taxClass;
  String subtotal;
  String subtotalTax;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<LineItemMetaDatum> metaData;
  String sku;
  double price;

  LineItem({
    this.id,
    this.name,
    this.productId,
    this.variationId,
    this.quantity,
    this.taxClass,
    this.subtotal,
    this.subtotalTax,
    this.total,
    this.totalTax,
    this.taxes,
    this.metaData,
    this.sku,
    this.price,
  });

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    taxClass: json["tax_class"] == null ? null : json["tax_class"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    subtotalTax: json["subtotal_tax"] == null ? null : json["subtotal_tax"],
    total: json["total"] == null ? null : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    metaData: json["meta_data"] == null ? null : List<LineItemMetaDatum>.from(json["meta_data"].map((x) => LineItemMetaDatum.fromMap(x))),
    taxes: json["taxes"] == null ? null : List<dynamic>.from(json["taxes"].map((x) => x)),
    sku: json["sku"] == null ? null : json["sku"],
    price: json["price"] == null ? null : json["price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "quantity": quantity == null ? null : quantity,
    "tax_class": taxClass == null ? null : taxClass,
    "subtotal": subtotal == null ? null : subtotal,
    "subtotal_tax": subtotalTax == null ? null : subtotalTax,
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
    "taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x)),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x)),
    "sku": sku == null ? null : sku,
    "price": price == null ? null : price,
  };
}


class LineItemMetaDatum {
  LineItemMetaDatum({
    this.id,
    this.key,
    this.value,
  });

  int id;
  String key;
  dynamic value;

  factory LineItemMetaDatum.fromJson(String str) => LineItemMetaDatum.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LineItemMetaDatum.fromMap(Map<String, dynamic> json) => LineItemMetaDatum(
    id: json["id"] == null ? null : json["id"],
    key: json["key"] == null ? null : json["key"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}

class MetaDatum {
  int id;
  String key;
  String value;

  MetaDatum({
    this.id,
    this.key,
    this.value,
  });

  factory MetaDatum.fromJson(Map<String, dynamic> json) {
    try {
      return MetaDatum(
        id: json["id"] == null ? null : json["id"],
        key: json["key"] == null ? null : json["key"],
        value: json["value"] == null ? null : json["value"],
      );
    } catch (e, s) {
      return MetaDatum(
        id: json["id"] == null ? null : json["id"],
        key: json["key"] == null ? null : json["key"],
        value: null,
      );
    }
  }

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "key": key == null ? null : key,
    "value": value == null ? null : value,
  };
}

class ShippingLine {
  int id;
  String methodTitle;
  String methodId;
  String instanceId;
  String total;
  String totalTax;
  List<dynamic> taxes;
  List<MetaDatum> metaData;

  ShippingLine({
    this.id,
    this.methodTitle,
    this.methodId,
    this.instanceId,
    this.total,
    this.totalTax,
    this.taxes,
    this.metaData,
  });

  factory ShippingLine.fromJson(Map<String, dynamic> json) => ShippingLine(
    id: json["id"] == null ? null : json["id"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    methodId: json["method_id"] == null ? null : json["method_id"],
    instanceId: json["instance_id"] == null ? null : json["instance_id"],
    total: json["total"] == null ? null : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"],
    taxes: json["taxes"] == null ? null : List<dynamic>.from(json["taxes"].map((x) => x)),
    metaData: json["meta_data"] == null ? null : List<MetaDatum>.from(json["meta_data"].map((x) => MetaDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "method_title": methodTitle == null ? null : methodTitle,
    "method_id": methodId == null ? null : methodId,
    "instance_id": instanceId == null ? null : instanceId,
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
    "taxes": taxes == null ? null : List<dynamic>.from(taxes.map((x) => x)),
    "meta_data": metaData == null ? null : List<dynamic>.from(metaData.map((x) => x.toJson())),
  };
}
