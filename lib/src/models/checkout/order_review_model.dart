// To parse this JSON data, do
//
//     final orderReviewModel = orderReviewModelFromJson(jsonString);

import 'dart:convert';

OrderReviewModel orderReviewModelFromJson(String str) => OrderReviewModel.fromJson(json.decode(str));

String orderReviewModelToJson(OrderReviewModel data) => json.encode(data.toJson());

class OrderReviewModel {
  String result;
  String messages;
  String reload;
  Cart cart;
  Checkout checkout;
  Totals totals;
  double balance;
  String balanceFormatted;
  Totals totalsUnformatted;
  List<dynamic> chosenShipping;
  List<Shipping> shipping;
  List<WooPaymentMethod> paymentMethods;

  OrderReviewModel({
    this.result,
    this.messages,
    this.reload,
    this.cart,
    this.checkout,
    this.totals,
    this.balance,
    this.balanceFormatted,
    this.chosenShipping,
    this.shipping,
    this.paymentMethods,
    this.totalsUnformatted
  });

  factory OrderReviewModel.fromJson(Map<String, dynamic> json) => new OrderReviewModel(
    result: json["result"] == null ? null : json["result"],
    //messages: json["messages"] == null ? null : json["messages"],
    //reload: json["reload"] == null ? null : json["reload"],
    //cart: json["cart"] == null ? null : Cart.fromJson(json["cart"]),
    //checkout: json["checkout"] == null ? null : Checkout.fromJson(json["checkout"]),
    balance: json["balance"] == null ? 0.0 : json["balance"].toDouble(),
    balanceFormatted: json["balanceFormatted"] == null ? '' : json["balanceFormatted"],
    totals: json["totals"] == null ? null : Totals.fromJson(json["totals"]),
    totalsUnformatted: json["totalsUnformatted"] == null ? null : Totals.fromJson(json["totalsUnformatted"]),
    //chosenShipping: json["chosen_shipping"] == null ? null : new List<dynamic>.from(json["chosen_shipping"].map((x) => x)),
    shipping: json["shipping"] == null ? null : new List<Shipping>.from(json["shipping"].map((x) => Shipping.fromJson(x))),
    paymentMethods: json["paymentMethods"] == null ? [] : new List<WooPaymentMethod>.from(json["paymentMethods"].map((x) => WooPaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? null : result,
    "messages": messages == null ? null : messages,
    "reload": reload == null ? null : reload,
    "cart": cart == null ? null : cart.toJson(),
    "checkout": checkout == null ? null : checkout.toJson(),
    "totals": totals == null ? null : totals.toJson(),
    "chosen_shipping": chosenShipping == null ? null : new List<dynamic>.from(chosenShipping.map((x) => x)),
    "shipping": shipping == null ? null : new List<dynamic>.from(shipping.map((x) => x.toJson())),
    "paymentMethods": paymentMethods == null ? null : new List<dynamic>.from(paymentMethods.map((x) => x.toJson())),
  };
}

class Cart {
  CartContents cartContents;
  List<dynamic> appliedCoupons;
  String taxDisplayCart;
  CartSessionData cartSessionData;
  List<dynamic> couponAppliedCount;
  List<dynamic> couponDiscountTotals;
  List<dynamic> couponDiscountTaxTotals;

  Cart({
    this.cartContents,
    this.appliedCoupons,
    this.taxDisplayCart,
    this.cartSessionData,
    this.couponAppliedCount,
    this.couponDiscountTotals,
    this.couponDiscountTaxTotals,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => new Cart(
    cartContents: json["cart_contents"] == null ? null : CartContents.fromJson(json["cart_contents"]),
    appliedCoupons: json["applied_coupons"] == null ? null : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
    taxDisplayCart: json["tax_display_cart"] == null ? null : json["tax_display_cart"],
    cartSessionData: json["cart_session_data"] == null ? null : CartSessionData.fromJson(json["cart_session_data"]),
    couponAppliedCount: json["coupon_applied_count"] == null ? null : new List<dynamic>.from(json["coupon_applied_count"].map((x) => x)),
    couponDiscountTotals: json["coupon_discount_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_totals"].map((x) => x)),
    couponDiscountTaxTotals: json["coupon_discount_tax_totals"] == null ? null : new List<dynamic>.from(json["coupon_discount_tax_totals"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "cart_contents": cartContents == null ? null : cartContents.toJson(),
    //"removed_cart_contents": removedCartContents == null ? null : new List<dynamic>.from(removedCartContents.map((x) => x)),
    "applied_coupons": appliedCoupons == null ? null : new List<dynamic>.from(appliedCoupons.map((x) => x)),
    "tax_display_cart": taxDisplayCart == null ? null : taxDisplayCart,
    "cart_session_data": cartSessionData == null ? null : cartSessionData.toJson(),
    "coupon_applied_count": couponAppliedCount == null ? null : new List<dynamic>.from(couponAppliedCount.map((x) => x)),
    "coupon_discount_totals": couponDiscountTotals == null ? null : new List<dynamic>.from(couponDiscountTotals.map((x) => x)),
    "coupon_discount_tax_totals": couponDiscountTaxTotals == null ? null : new List<dynamic>.from(couponDiscountTaxTotals.map((x) => x)),
  };
}

class CartContents {
  The8Da153B3917424A1Cf24A9Cd1D7B4E9D the8Da153B3917424A1Cf24A9Cd1D7B4E9D;
  E610F941894B4A6488Cc1E06655862Ee e610F941894B4A6488Cc1E06655862Ee;

  CartContents({
    this.the8Da153B3917424A1Cf24A9Cd1D7B4E9D,
    this.e610F941894B4A6488Cc1E06655862Ee,
  });

  factory CartContents.fromJson(Map<String, dynamic> json) => new CartContents(
    the8Da153B3917424A1Cf24A9Cd1D7B4E9D: json["8da153b3917424a1cf24a9cd1d7b4e9d"] == null ? null : The8Da153B3917424A1Cf24A9Cd1D7B4E9D.fromJson(json["8da153b3917424a1cf24a9cd1d7b4e9d"]),
    e610F941894B4A6488Cc1E06655862Ee: json["e610f941894b4a6488cc1e06655862ee"] == null ? null : E610F941894B4A6488Cc1E06655862Ee.fromJson(json["e610f941894b4a6488cc1e06655862ee"]),
  );

  Map<String, dynamic> toJson() => {
    "8da153b3917424a1cf24a9cd1d7b4e9d": the8Da153B3917424A1Cf24A9Cd1D7B4E9D == null ? null : the8Da153B3917424A1Cf24A9Cd1D7B4E9D.toJson(),
    "e610f941894b4a6488cc1e06655862ee": e610F941894B4A6488Cc1E06655862Ee == null ? null : e610F941894B4A6488Cc1E06655862Ee.toJson(),
  };
}

class E610F941894B4A6488Cc1E06655862Ee {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  VariationClass variation;
  int quantity;
  String dataHash;
  LineTaxData lineTaxData;
  int lineSubtotal;
  int lineSubtotalTax;
  int lineTotal;
  int lineTax;
  Checkout data;
  String name;

  E610F941894B4A6488Cc1E06655862Ee({
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
    this.name,
  });

  factory E610F941894B4A6488Cc1E06655862Ee.fromJson(Map<String, dynamic> json) => new E610F941894B4A6488Cc1E06655862Ee(
    addons: json["addons"] == null ? null : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? null : json["key"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    variation: json["variation"] == null ? null : VariationClass.fromJson(json["variation"]),
    quantity: json["quantity"] == null ? null : json["quantity"],
    dataHash: json["data_hash"] == null ? null : json["data_hash"],
    lineTaxData: json["line_tax_data"] == null ? null : LineTaxData.fromJson(json["line_tax_data"]),
    lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"],
    lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"],
    lineTotal: json["line_total"] == null ? null : json["line_total"],
    lineTax: json["line_tax"] == null ? null : json["line_tax"],
    data: json["data"] == null ? null : Checkout.fromJson(json["data"]),
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "addons": addons == null ? null : new List<dynamic>.from(addons.map((x) => x)),
    "key": key == null ? null : key,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "variation": variation == null ? null : variation.toJson(),
    "quantity": quantity == null ? null : quantity,
    "data_hash": dataHash == null ? null : dataHash,
    "line_tax_data": lineTaxData == null ? null : lineTaxData.toJson(),
    "line_subtotal": lineSubtotal == null ? null : lineSubtotal,
    "line_subtotal_tax": lineSubtotalTax == null ? null : lineSubtotalTax,
    "line_total": lineTotal == null ? null : lineTotal,
    "line_tax": lineTax == null ? null : lineTax,
    "data": data == null ? null : data.toJson(),
    "name": name == null ? null : name,
  };
}

class Checkout {
  Checkout();

  factory Checkout.fromJson(Map<String, dynamic> json) => new Checkout(
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

class The8Da153B3917424A1Cf24A9Cd1D7B4E9D {
  List<dynamic> addons;
  String key;
  int productId;
  int variationId;
  String variation;
  int quantity;
  String dataHash;
  LineTaxData lineTaxData;
  int lineSubtotal;
  int lineSubtotalTax;
  int lineTotal;
  int lineTax;
  Checkout data;
  String name;

  The8Da153B3917424A1Cf24A9Cd1D7B4E9D({
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
    this.name,
  });

  factory The8Da153B3917424A1Cf24A9Cd1D7B4E9D.fromJson(Map<String, dynamic> json) => new The8Da153B3917424A1Cf24A9Cd1D7B4E9D(
    addons: json["addons"] == null ? null : new List<dynamic>.from(json["addons"].map((x) => x)),
    key: json["key"] == null ? null : json["key"],
    productId: json["product_id"] == null ? null : json["product_id"],
    variationId: json["variation_id"] == null ? null : json["variation_id"],
    variation: json["variation"] == null ? null : json["variation"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    dataHash: json["data_hash"] == null ? null : json["data_hash"],
    lineTaxData: json["line_tax_data"] == null ? null : LineTaxData.fromJson(json["line_tax_data"]),
    lineSubtotal: json["line_subtotal"] == null ? null : json["line_subtotal"],
    lineSubtotalTax: json["line_subtotal_tax"] == null ? null : json["line_subtotal_tax"],
    lineTotal: json["line_total"] == null ? null : json["line_total"],
    lineTax: json["line_tax"] == null ? null : json["line_tax"],
    data: json["data"] == null ? null : Checkout.fromJson(json["data"]),
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "addons": addons == null ? null : new List<dynamic>.from(addons.map((x) => x)),
    "key": key == null ? null : key,
    "product_id": productId == null ? null : productId,
    "variation_id": variationId == null ? null : variationId,
    "variation": variation == null ? null : variation,
    "quantity": quantity == null ? null : quantity,
    "data_hash": dataHash == null ? null : dataHash,
    "line_tax_data": lineTaxData == null ? null : lineTaxData.toJson(),
    "line_subtotal": lineSubtotal == null ? null : lineSubtotal,
    "line_subtotal_tax": lineSubtotalTax == null ? null : lineSubtotalTax,
    "line_total": lineTotal == null ? null : lineTotal,
    "line_tax": lineTax == null ? null : lineTax,
    "data": data == null ? null : data.toJson(),
    "name": name == null ? null : name,
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

class WooPaymentMethod {
  dynamic orderButtonText;
  String enabled;
  String title;
  String description;
  bool chosen;
  String methodTitle;
  String methodDescription;
  bool hasFields;
  dynamic countries;
  dynamic availability;
  String icon;
  List<String> supports;
  int maxAmount;
  String viewTransactionUrl;
  String newMethodLabel;
  String pluginId;
  String id;
  Settings settings;
  FormFields formFields;
  String instructions;
  String payStackPublicKey;
  String stripePublicKey;

  WooPaymentMethod({
    this.orderButtonText,
    this.enabled,
    this.title,
    this.description,
    this.chosen,
    this.methodTitle,
    this.methodDescription,
    this.hasFields,
    this.countries,
    this.availability,
    this.icon,
    this.supports,
    this.maxAmount,
    this.viewTransactionUrl,
    this.newMethodLabel,
    this.pluginId,
    this.id,
    this.settings,
    this.formFields,
    this.instructions,
    this.payStackPublicKey,
    this.stripePublicKey
  });

  factory WooPaymentMethod.fromJson(Map<String, dynamic> json) => new WooPaymentMethod(
    orderButtonText: json["order_button_text"],
    enabled: json["enabled"] == null ? null : json["enabled"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    chosen: json["chosen"] == null ? null : json["chosen"],
    methodTitle: json["method_title"] == null ? null : json["method_title"],
    methodDescription: json["method_description"] == null ? null : json["method_description"],
    hasFields: json["has_fields"] == null ? null : json["has_fields"],
    countries: json["countries"],
    availability: json["availability"],
    icon: (json["icon"] == null || json["icon"] == false) ? null : json["icon"],
    supports: json["supports"] == null ? null : new List<String>.from(json["supports"].map((x) => x)),
    maxAmount: json["max_amount"] == null ? null : json["max_amount"],
    viewTransactionUrl: json["view_transaction_url"] == null ? null : json["view_transaction_url"],
    newMethodLabel: json["new_method_label"] == null ? null : json["new_method_label"],
    pluginId: json["plugin_id"] == null ? null : json["plugin_id"],
    id: json["id"] == null ? null : json["id"],
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    formFields: json["form_fields"] == null ? null : FormFields.fromJson(json["form_fields"]),
    instructions: json["instructions"] == null ? null : json["instructions"],
    payStackPublicKey: json["public_key"] == null ? null : json["public_key"],
    stripePublicKey: json["publishable_key"] == null ? null : json["publishable_key"],
  );

  Map<String, dynamic> toJson() => {
    "order_button_text": orderButtonText,
    "enabled": enabled == null ? null : enabled,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "chosen": chosen == null ? null : chosen,
    "method_title": methodTitle == null ? null : methodTitle,
    "method_description": methodDescription == null ? null : methodDescription,
    "has_fields": hasFields == null ? null : hasFields,
    "countries": countries,
    "availability": availability,
    "icon": icon == null ? null : icon,
    "supports": supports == null ? null : new List<dynamic>.from(supports.map((x) => x)),
    "max_amount": maxAmount == null ? null : maxAmount,
    "view_transaction_url": viewTransactionUrl == null ? null : viewTransactionUrl,
    "new_method_label": newMethodLabel == null ? null : newMethodLabel,
    "plugin_id": pluginId == null ? null : pluginId,
    "id": id == null ? null : id,
    "settings": settings == null ? null : settings.toJson(),
    "form_fields": formFields == null ? null : formFields.toJson(),
    "instructions": instructions == null ? null : instructions,
  };
}

class FormFields {
  Enabled enabled;
  Description title;
  Description description;
  Description instructions;

  FormFields({
    this.enabled,
    this.title,
    this.description,
    this.instructions,
  });

  factory FormFields.fromJson(Map<String, dynamic> json) => new FormFields(
    enabled: json["enabled"] == null ? null : Enabled.fromJson(json["enabled"]),
    title: json["title"] == null ? null : Description.fromJson(json["title"]),
    description: json["description"] == null ? null : Description.fromJson(json["description"]),
    instructions: json["instructions"] == null ? null : Description.fromJson(json["instructions"]),
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled == null ? null : enabled.toJson(),
    "title": title == null ? null : title.toJson(),
    "description": description == null ? null : description.toJson(),
    "instructions": instructions == null ? null : instructions.toJson(),
  };
}

class Description {
  String title;
  String type;
  String description;
  String descriptionDefault;
  //bool descTip;

  Description({
    this.title,
    this.type,
    this.description,
    this.descriptionDefault,
    //this.descTip,
  });

  factory Description.fromJson(Map<String, dynamic> json) => new Description(
    title: json["title"] == null ? null : json["title"],
    type: json["type"] == null ? null : json["type"],
    description: json["description"] == null ? null : json["description"],
    descriptionDefault: json["default"] == null ? null : json["default"],
    //descTip: json["desc_tip"] == null ? null : json["desc_tip"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "type": type == null ? null : type,
    "description": description == null ? null : description,
    "default": descriptionDefault == null ? null : descriptionDefault,
    //"desc_tip": descTip == null ? null : descTip,
  };
}

class Enabled {
  String title;
  String type;
  String label;
  String enabledDefault;

  Enabled({
    this.title,
    this.type,
    this.label,
    this.enabledDefault,
  });

  factory Enabled.fromJson(Map<String, dynamic> json) => new Enabled(
    title: json["title"] == null ? null : json["title"],
    type: json["type"] == null ? null : json["type"],
    label: json["label"] == null ? null : json["label"],
    enabledDefault: json["default"] == null ? null : json["default"],
  );

  Map<String, dynamic> toJson() => {
    "title": title == null ? null : title,
    "type": type == null ? null : type,
    "label": label == null ? null : label,
    "default": enabledDefault == null ? null : enabledDefault,
  };
}

class Settings {
  String enabled;
  String title;
  String description;
  String instructions;
  String razorPayKeyId;


  Settings({
    this.enabled,
    this.title,
    this.description,
    this.instructions,
    this.razorPayKeyId
  });

  factory Settings.fromJson(Map<String, dynamic> json) => new Settings(
    enabled: json["enabled"] == null ? null : json["enabled"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    instructions: json["instructions"] == null ? null : json["instructions"],
    razorPayKeyId: json["key_id"] == null ? null : json["key_id"],
  );

  Map<String, dynamic> toJson() => {
    "enabled": enabled == null ? null : enabled,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "instructions": instructions == null ? null : instructions,
  };
}

class Shipping {
  Package package;
  bool showPackageDetails;
  bool showShippingCalculator;
  String packageDetails;
  String packageName;
  String index;
  String chosenMethod;
  List<ShippingMethod> shippingMethods;

  Shipping({
    this.package,
    this.showPackageDetails,
    this.showShippingCalculator,
    this.packageDetails,
    this.packageName,
    this.index,
    this.chosenMethod,
    this.shippingMethods,
  });

  factory Shipping.fromJson(Map<String, dynamic> json) => new Shipping(
    package: json["package"] == null ? null : Package.fromJson(json["package"]),
    showPackageDetails: json["show_package_details"] == null ? null : json["show_package_details"],
    showShippingCalculator: json["show_shipping_calculator"] == null ? null : json["show_shipping_calculator"],
    packageDetails: json["package_details"] == null ? null : json["package_details"],
    packageName: json["package_name"] == null ? null : json["package_name"],
    index: json["index"] == null ? null : json["index"].toString(),
    chosenMethod: (json["chosen_method"] == null || json["chosen_method"] == false ) ? '' : json["chosen_method"],
    shippingMethods: json["shippingMethods"] == null ? [] : new List<ShippingMethod>.from(json["shippingMethods"].map((x) => ShippingMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "package": package == null ? null : package.toJson(),
    "show_package_details": showPackageDetails == null ? null : showPackageDetails,
    "show_shipping_calculator": showShippingCalculator == null ? null : showShippingCalculator,
    "package_details": packageDetails == null ? null : packageDetails,
    "package_name": packageName == null ? null : packageName,
    "index": index == null ? null : index,
    "chosen_method": chosenMethod == null ? null : chosenMethod,
    "shippingMethods": shippingMethods == null ? null : new List<dynamic>.from(shippingMethods.map((x) => x.toJson())),
  };
}

class Package {
  //List<Content> contents;
  double contentsCost;
  List<dynamic> appliedCoupons;
  User user;
  Destination destination;

  Package({
    //this.contents,
    this.contentsCost,
    this.appliedCoupons,
    this.user,
    this.destination,
  });

  factory Package.fromJson(Map<String, dynamic> json) => new Package(
    //contents: json["contents"] == null ? null : new List<Content>.from(json["contents"].map((x) => Content.fromJson(x))),
    contentsCost: json["contents_cost"] == null ? null : json["contents_cost"].toDouble(),
    appliedCoupons: json["applied_coupons"] == null ? null : new List<dynamic>.from(json["applied_coupons"].map((x) => x)),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
  );

  Map<String, dynamic> toJson() => {
    //"contents": contents == null ? null : new List<dynamic>.from(contents.map((x) => x.toJson())),
    "contents_cost": contentsCost == null ? null : contentsCost,
    "applied_coupons": appliedCoupons == null ? null : new List<dynamic>.from(appliedCoupons.map((x) => x)),
    "user": user == null ? null : user.toJson(),
    "destination": destination == null ? null : destination.toJson(),
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
  Checkout data;

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
    data: json["data"] == null ? null : Checkout.fromJson(json["data"]),
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
    cost: json["cost"] == null ? null : json["cost"].toString(),
    methodId: json["method_id"] == null ? null : json["method_id"],
    //taxes: json["taxes"] == null ? null : new List<dynamic>.from(json["taxes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "label": label == null ? null : label,
    "cost": cost == null ? null : cost,
    "method_id": methodId == null ? null : methodId,
    "taxes": taxes == null ? null : new List<dynamic>.from(taxes.map((x) => x)),
  };
}

class Totals {
  String subtotal;
  String subtotalTax;
  String shippingTotal;
  String shippingTax;
  List<dynamic> shippingTaxes;
  String discountTotal;
  String discountTax;
  String cartContentsTotal;
  String cartContentsTax;
  List<dynamic> cartContentsTaxes;
  String feeTotal;
  String feeTax;
  List<dynamic> feeTaxes;
  String total;
  String totalTax;

  Totals({
    this.subtotal,
    this.subtotalTax,
    this.shippingTotal,
    this.shippingTax,
    this.shippingTaxes,
    this.discountTotal,
    this.discountTax,
    this.cartContentsTotal,
    this.cartContentsTax,
    this.cartContentsTaxes,
    this.feeTotal,
    this.feeTax,
    this.feeTaxes,
    this.total,
    this.totalTax,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => new Totals(
    subtotal: json["subtotal"] == null ? null : json["subtotal"].toString(),
    subtotalTax: json["subtotal_tax"] == null ? null : json["subtotal_tax"].toString(),
    shippingTotal: json["shipping_total"] == null ? null : json["shipping_total"].toString(),
    shippingTax: json["shipping_tax"] == null ? null : json["shipping_tax"].toString(),
    //shippingTaxes: json["shipping_taxes"] == null ? null : new List<dynamic>.from(json["shipping_taxes"].map((x) => x)),
    discountTotal: json["discount_total"] == null ? null : json["discount_total"].toString(),
    discountTax: json["discount_tax"] == null ? null : json["discount_tax"].toString(),
    cartContentsTotal: json["cart_contents_total"] == null ? null : json["cart_contents_total"].toString(),
    //cartContentsTax: json["cart_contents_tax"] == null ? null : json["cart_contents_tax"].toDouble(),
    //cartContentsTaxes: json["cart_contents_taxes"] == null ? null : new List<dynamic>.from(json["cart_contents_taxes"].map((x) => x)),
    feeTotal: json["fee_total"] == null ? null : json["fee_total"].toString(),
    feeTax: json["fee_tax"] == null ? null : json["fee_tax"].toString(),
    //feeTaxes: json["fee_taxes"] == null ? null : new List<dynamic>.from(json["fee_taxes"].map((x) => x)),
    total: json["total"] == null ? null : json["total"].toString(),
    totalTax: json["total_tax"] == null ? null : json["total_tax"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "subtotal": subtotal == null ? null : subtotal,
    "subtotal_tax": subtotalTax == null ? null : subtotalTax,
    "shipping_total": shippingTotal == null ? null : shippingTotal,
    "shipping_tax": shippingTax == null ? null : shippingTax,
    "shipping_taxes": shippingTaxes == null ? null : new List<dynamic>.from(shippingTaxes.map((x) => x)),
    "discount_total": discountTotal == null ? null : discountTotal,
    "discount_tax": discountTax == null ? null : discountTax,
    "cart_contents_total": cartContentsTotal == null ? null : cartContentsTotal,
    "cart_contents_tax": cartContentsTax == null ? null : cartContentsTax,
    "cart_contents_taxes": cartContentsTaxes == null ? null : new List<dynamic>.from(cartContentsTaxes.map((x) => x)),
    "fee_total": feeTotal == null ? null : feeTotal,
    "fee_tax": feeTax == null ? null : feeTax,
    "fee_taxes": feeTaxes == null ? null : new List<dynamic>.from(feeTaxes.map((x) => x)),
    "total": total == null ? null : total,
    "total_tax": totalTax == null ? null : totalTax,
  };
}
