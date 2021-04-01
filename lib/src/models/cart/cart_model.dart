// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

CartModel cartFromJson(String str) => CartModel.fromJson(json.decode(str));

class CartModel {
  List<dynamic> appliedCoupons;
  String taxDisplayCart;
  CartSessionData cartSessionData;
  List<dynamic> couponAppliedCount;
  List<dynamic> couponDiscountTotals;
  List<dynamic> couponDiscountTaxTotals;
  List<CartContent> cartContents;
  String cartNonce;
  CartTotals cartTotals;
  List<dynamic> chosenShipping;
  Points points;
  int purchasePoint;
  String currency;
  List<CartFee> cartFees;
  List<Coupon> coupons;

  CartModel({
    this.appliedCoupons,
    this.taxDisplayCart,
    this.cartSessionData,
    this.couponAppliedCount,
    this.couponDiscountTotals,
    this.couponDiscountTaxTotals,
    this.cartContents,
    this.cartNonce,
    this.cartTotals,
    this.chosenShipping,
    this.points,
    this.purchasePoint,
    this.currency,
    this.cartFees,
    this.coupons
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      //appliedCoupons: json["applied_coupons"] == null ? null : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
      //taxDisplayCart: json["tax_display_cart"] == null ? null : json["tax_display_cart"],
      //cartSessionData: json["cart_session_data"] == null ? null : CartSessionData.fromJson(json["cart_session_data"]),
      //couponAppliedCount: json["coupon_applied_count"] == null ? null : new List<dynamic>.from(json["coupon_applied_count"].map((x) => x)),
      //couponDiscountTotals: json["coupon_discount_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_totals"].map((x) => x)),
      //couponDiscountTaxTotals: json["coupon_discount_tax_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_tax_totals"].map((x) => x)),
      cartContents: json["cartContents"] == null ? null : new List<CartContent>.from(json["cartContents"].map((x) => CartContent.fromJson(x))),
      cartNonce: json["cart_nonce"] == null ? null : json["cart_nonce"],
      cartTotals: json["cart_totals"] == null ? null : CartTotals.fromJson(json["cart_totals"]),
      //chosenShipping: (json["chosen_shipping"] == false || json["chosen_shipping"] == null) ? null : new List<dynamic>.from(json["chosen_shipping"].map((x) => x)),
      points: json["points"] == null ? null : Points.fromJson(json["points"]),
      //purchasePoint: json["purchase_point"] == null ? null : json["purchase_point"],
      currency: json["currency"] == null ? 'USD' : json["currency"],
      cartFees: json["cart_fees"] == null ? null : List<CartFee>.from(json["cart_fees"].map((x) => CartFee.fromJson(x))),
      coupons: json["coupons"] == null ? null : List<Coupon>.from(json["coupons"].map((x) => Coupon.fromJson(x))),
    );
  }
}

class CartFee {
  CartFee({
    this.id,
    this.name,
    this.total,
  });

  String id;
  String name;
  String amount;
  String total;

  factory CartFee.fromJson(Map<String, dynamic> json) => CartFee(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    total: json["total"] == null ? null : json["total"],
  );
}

class Coupon {
  Coupon({
    this.code,
    this.amount,
  });

  String code;
  String amount;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
    code: json["code"] == null ? null : json["code"],
    amount: json["amount"] == null ? null : json["amount"],
  );
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => new Data(
  );

  Map<String, dynamic> toJson() => {
  };
}

class LineTaxData {
  List<dynamic> subtotal;
  List<dynamic> total;

  LineTaxData({
    this.subtotal,
    this.total,
  });

  factory LineTaxData.fromJson(Map<String, dynamic> json) => new LineTaxData(
    subtotal: json["subtotal"] == null ? null : new List<dynamic>.from(json["subtotal"].map((x) => x)),
    total: json["total"] == null ? null : new List<dynamic>.from(json["total"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal == null ? null : new List<dynamic>.from(subtotal.map((x) => x)),
    "total": total == null ? null : new List<dynamic>.from(total.map((x) => x)),
  };
}

class VariationClass {
  String attributePaColor;
  String attributePaSize;

  VariationClass({
    this.attributePaColor,
    this.attributePaSize,
  });

  factory VariationClass.fromJson(Map<String, dynamic> json) => new VariationClass(
    attributePaColor: json["attribute_pa_Color"] == null ? null : json["attribute_pa_Color"],
    attributePaSize: json["attribute_pa_Size"] == null ? null : json["attribute_pa_Size"],
  );

  Map<String, dynamic> toJson() => {
    "attribute_pa_Color": attributePaColor == null ? null : attributePaColor,
    "attribute_pa_Size": attributePaSize == null ? null : attributePaSize,
  };
}

class CartContent {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  dynamic variation;
  int quantity;
  String dataHash;
  //LineTaxData lineTaxData;
  double lineSubtotal;
  double lineSubtotalTax;
  double lineTotal;
  double lineTax;
  Data data;
  String name;
  String thumb;
  String removeUrl;
  double price;
  double taxPrice;
  double regularPrice;
  double salesPrice;
  bool loadingQty;
  String formattedPrice;
  String formattedSalesPrice;
  int parentId;


  CartContent({
    this.addons,
    this.key,
    this.productId,
    this.variationId,
    this.variation,
    this.quantity,
    this.dataHash,
    //this.lineTaxData,
    this.lineSubtotal,
    this.lineSubtotalTax,
    this.lineTotal,
    this.lineTax,
    this.data,
    this.name,
    this.thumb,
    this.removeUrl,
    this.price,
    this.taxPrice,
    this.regularPrice,
    this.salesPrice,
    this.loadingQty,
    this.formattedPrice,
    this.formattedSalesPrice,
    this.parentId
  });

  factory CartContent.fromJson(Map<String, dynamic> json) => new CartContent(
    addons: json["addons"] == null ? null : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? null : json["key"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    variation: json["variation"],
    quantity: json["quantity"] == null ? null : json["quantity"] is int ? json["quantity"] : int.parse(json["quantity"]),
    dataHash: json["data_hash"] == null ? null : json["data_hash"],
    //lineTaxData: json["line_tax_data"] == null ? null : LineTaxData.fromJson(json["line_tax_data"]),
    lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"].toDouble(),
    lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"].toDouble(),
    lineTotal: json["line_total"] == null ? null : json["line_total"].toDouble(),
    lineTax: json["line_tax"] == null ? null : json["line_tax"].toDouble(),
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    name: json["name"] == null ? null : json["name"],
    thumb: json["thumb"] == null ? null : json["thumb"],
    removeUrl: json["remove_url"] == null ? null : json["remove_url"],
    price: json["price"] == null ? null : json["price"].toDouble(),
    taxPrice: json["tax_price"] == null ? null : json["tax_price"],
    regularPrice: json["regular_price"] == null ? null : json["regular_price"].toDouble(),
    salesPrice: json["sales_price"] == null ? null : json["sales_price"].toDouble(),
    formattedPrice: json["formated_price"] == null ? null : json["formated_price"],
    formattedSalesPrice: json["formated_sales_price"] == null ? null : json["formated_sales_price"],
    loadingQty: false,
    parentId: json["parent_id"] == null ? null : json["parent_id"],
  );

  Map<String, dynamic> toJson() => {
    "addons": addons == null ? null : new List<dynamic>.from(addons.map((x) => x)),
    "key": key == null ? null : key,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "variation": variation,
    "quantity": quantity == null ? null : quantity,
    "data_hash": dataHash == null ? null : dataHash,
    //"line_tax_data": lineTaxData == null ? null : lineTaxData.toJson(),
    "line_subtotal": lineSubtotal == null ? null : lineSubtotal,
    "line_subtotal_tax": lineSubtotalTax == null ? null : lineSubtotalTax,
    "line_total": lineTotal == null ? null : lineTotal,
    "line_tax": lineTax == null ? null : lineTax,
    "data": data == null ? null : data.toJson(),
    "name": name == null ? null : name,
    "thumb": thumb == null ? null : thumb,
    "remove_url": removeUrl == null ? null : removeUrl,
    "price": price == null ? null : price,
    "regular_price": regularPrice == null ? null : regularPrice,


  };
}

class CartSessionData {
  int cartContentsTotal;
  int total;
  int subtotal;
  int subtotalExTax;
  int taxTotal;
  List<dynamic> taxes;
  List<dynamic> shippingTaxes;
  int discountCart;
  int discountCartTax;
  int shippingTotal;
  int shippingTaxTotal;
  List<dynamic> couponDiscountAmounts;
  List<dynamic> couponDiscountTaxAmounts;
  int feeTotal;
  List<dynamic> fees;

  CartSessionData({
    this.cartContentsTotal,
    this.total,
    this.subtotal,
    this.subtotalExTax,
    this.taxTotal,
    this.taxes,
    this.shippingTaxes,
    this.discountCart,
    this.discountCartTax,
    this.shippingTotal,
    this.shippingTaxTotal,
    this.couponDiscountAmounts,
    this.couponDiscountTaxAmounts,
    this.feeTotal,
    this.fees,
  });

  factory CartSessionData.fromJson(Map<String, dynamic> json) => new CartSessionData(
    cartContentsTotal: json["cart_contents_total"] == null ? null : json["cart_contents_total"],
    total: json["total"] == null ? null : json["total"],
    subtotal: json["subtotal"] == null ? null : json["subtotal"],
    subtotalExTax: json["subtotal_ex_tax"] == null ? null : json["subtotal_ex_tax"],
    taxTotal: json["tax_total"] == null ? null : json["tax_total"],
    taxes: json["taxes"] == null ? null : new List<dynamic>.from(json["taxes"].map((x) => x)),
    shippingTaxes: json["shipping_taxes"] == null ? null : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountCart: json["discount_cart"] == null ? null : json["discount_cart"],
    discountCartTax: json["discount_cart_tax"] == null ? null : json["discount_cart_tax"],
    shippingTotal: json["shipping_total"] == null ? null : json["shipping_total"],
    shippingTaxTotal: json["shipping_tax_total"] == null ? null : json["shipping_tax_total"],
    couponDiscountAmounts: json["coupon_discount_amounts"] == null ? null : new List<dynamic>.from(json["coupon_discount_amounts"].map((x) => x)),
    couponDiscountTaxAmounts: json["coupon_discount_tax_amounts"] == null ? null : new List<dynamic>.from(json["coupon_discount_tax_amounts"].map((x) => x)),
    feeTotal: json["fee_total"] == null ? null : json["fee_total"],
    fees: json["fees"] == null ? null : new List<dynamic>.from(json["fees"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "cart_contents_total": cartContentsTotal == null ? null : cartContentsTotal,
    "total": total == null ? null : total,
    "subtotal": subtotal == null ? null : subtotal,
    "subtotal_ex_tax": subtotalExTax == null ? null : subtotalExTax,
    "tax_total": taxTotal == null ? null : taxTotal,
    "taxes": taxes == null ? null : new List<dynamic>.from(taxes.map((x) => x)),
    "shipping_taxes": shippingTaxes == null ? null : new List<dynamic>.from(shippingTaxes.map((x) => x)),
    "discount_cart": discountCart == null ? null : discountCart,
    "discount_cart_tax": discountCartTax == null ? null : discountCartTax,
    "shipping_total": shippingTotal == null ? null : shippingTotal,
    "shipping_tax_total": shippingTaxTotal == null ? null : shippingTaxTotal,
    "coupon_discount_amounts": couponDiscountAmounts == null ? null : new List<dynamic>.from(couponDiscountAmounts.map((x) => x)),
    "coupon_discount_tax_amounts": couponDiscountTaxAmounts == null ? null : new List<dynamic>.from(couponDiscountTaxAmounts.map((x) => x)),
    "fee_total": feeTotal == null ? null : feeTotal,
    "fees": fees == null ? null : new List<dynamic>.from(fees.map((x) => x)),
  };
}

class CartTotals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  String shippingTax;
  //List<dynamic> shippingTaxes;
  String discountTotal;
  String discountTax;
  String cartContentsTotal;
  String cartContentsTax;
  //List<dynamic> cartContentsTaxes;
  String feeTotal;
  String feeTax;
  //List<dynamic> feeTaxes;
  String total;
  String totalTax;

  CartTotals({
    this.subtotal,
    this.subtotalTax,
    this.shippingTotal,
    this.shippingTax,
    //this.shippingTaxes,
    this.discountTotal,
    this.discountTax,
    this.cartContentsTotal,
    this.cartContentsTax,
    //this.cartContentsTaxes,
    this.feeTotal,
    this.feeTax,
    //this.feeTaxes,
    this.total,
    this.totalTax,
  });

  factory CartTotals.fromJson(Map<String, dynamic> json) => new CartTotals(
    subtotal: json["subtotal"] == 0 ? '0' : json["subtotal"],
    subtotalTax: (json["subtotal_tax"] == null || json["subtotal_tax"] == 0) ? null : json["subtotal_tax"],
    shippingTotal: json["shipping_total"] == 0 ? '0' : json["shipping_total"],
    //shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"],
    //shippingTaxes: json["shipping_taxes"] == null ? null : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountTotal: json["discount_total"] == null ? null : json["discount_total"].toString(),
    //discountTax: json["discount_tax"] == null ? null : json["discount_tax"],
    cartContentsTotal: json["cart_contents_total"] == 0 ? '0' : json["cart_contents_total"],
    //cartContentsTax: json["cart_contents_tax"] == null ? null : json["cart_contents_tax"],
    //cartContentsTaxes: json["cart_contents_taxes"] == null ? null : new List<dynamic>.from(json["cart_contents_taxes"].map((x) => x)),
    feeTotal: json["fee_total"] == 0 ? '0' : json["fee_total"],
    //feeTax: json["fee_tax"] == null ? null : json["fee_tax"],
    //feeTaxes: json["fee_taxes"] == null ? null : new List<dynamic>.from(json["fee_taxes"].map((x) => x)),
    total: json["total"] == 0 ? '0' : json["total"],
    totalTax: json["total_tax"] == null ? null : json["total_tax"].toString(),
  );

}

class Points {
  int points;
  double discountAvailable;
  String message;

  Points({
    this.points,
    this.discountAvailable,
    this.message,
  });

  factory Points.fromJson(Map<String, dynamic> json) => new Points(
    points: json["points"] == null ? null : json["points"],
    discountAvailable: json["discount_available"] == null || json["discount_available"] == false ? null : double.parse(json["discount_available"].toString()),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "points": points == null ? null : points,
    "discount_available": discountAvailable == null ? null : discountAvailable,
    "message": message == null ? null : message,
  };
}

class Content {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  dynamic variation;
  int quantity;
  String dataHash;
  LineTaxData lineTaxData;
  int lineSubtotal;
  int lineSubtotalTax;
  int lineTotal;
  int lineTax;
  Data data;

  Content({
    this.addons,
    this.key,
    this.productId,
    this.variationId,
    this.variation,
    this.quantity,
    this.dataHash,
    this.lineTaxData,
    this.lineSubtotal,
    this.lineSubtotalTax,
    this.lineTotal,
    this.lineTax,
    this.data,
  });

  factory Content.fromJson(Map<String, dynamic> json) => new Content(
    addons: json["addons"] == null ? null : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? null : json["key"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    variation: json["variation"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    dataHash: json["data_hash"] == null ? null : json["data_hash"],
    lineTaxData: json["line_tax_data"] == null ? null : LineTaxData.fromJson(json["line_tax_data"]),
    lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"],
    lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"],
    lineTotal: json["line_total"] == null ? null : json["line_total"],
    lineTax: json["line_tax"] == null ? null : json["line_tax"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "addons": addons == null ? null : new List<dynamic>.from(addons.map((x) => x)),
    "key": key == null ? null : key,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "variation": variation,
    "quantity": quantity == null ? null : quantity,
    "data_hash": dataHash == null ? null : dataHash,
    "line_tax_data": lineTaxData == null ? null : lineTaxData.toJson(),
    "line_subtotal": lineSubtotal == null ? null : lineSubtotal,
    "line_subtotal_tax": lineSubtotalTax == null ? null : lineSubtotalTax,
    "line_total": lineTotal == null ? null : lineTotal,
    "line_tax": lineTax == null ? null : lineTax,
    "data": data == null ? null : data.toJson(),
  };
}

class Destination {
  String country;
  String state;
  String postcode;
  String city;
  String address;
  String address2;

  Destination({
    this.country,
    this.state,
    this.postcode,
    this.city,
    this.address,
    this.address2,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => new Destination(
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
    postcode: json["postcode"] == null ? null : json["postcode"],
    city: json["city"] == null ? null : json["city"],
    address: json["address"] == null ? null : json["address"],
    address2: json["address_2"] == null ? null : json["address_2"],
  );

  Map<String, dynamic> toJson() => {
    "country": country == null ? null : country,
    "state": state == null ? null : state,
    "postcode": postcode == null ? null : postcode,
    "city": city == null ? null : city,
    "address": address == null ? null : address,
    "address_2": address2 == null ? null : address2,
  };
}

class User {
  int id;

  User({
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    id: json["ID"] == null ? null : json["ID"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
  };
}

class ShippingMethod {
  String id;
  String label;
  String cost;
  String methodId;
  List<dynamic> taxes;

  ShippingMethod({
    this.id,
    this.label,
    this.cost,
    this.methodId,
    this.taxes,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => new ShippingMethod(
    id: json["id"] == null ? null : json["id"],
    label: json["label"] == null ? null : json["label"],
    cost: json["cost"] == null ? null : json["cost"],
    methodId: json["method_id"] == null ? null : json["method_id"],
    taxes: json["taxes"] == null ? null : new List<dynamic>.from(json["taxes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "cost": cost == null ? null : cost,
    "method_id": methodId == null ? null : methodId,
    "taxes": taxes == null ? null : new List<dynamic>.from(taxes.map((x) => x)),
  };
}
