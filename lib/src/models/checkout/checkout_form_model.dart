// To parse this JSON data, do
//
//     final checkoutFormModel = checkoutFormModelFromJson(jsonString);

import 'dart:convert';

CheckoutFormModel checkoutFormModelFromJson(String str) => CheckoutFormModel.fromJson(json.decode(str));

String checkoutFormModelToJson(CheckoutFormModel data) => json.encode(data.toJson());

class CheckoutFormModel {
  String billingFirstName;
  String billingLastName;
  String billingCompany;
  String billingCountry;
  String billingAddress1;
  String billingAddress2;
  String billingCity;
  String billingState;
  String billingPostcode;
  String billingPhone;
  String billingEmail;
  String shippingFirstName;
  String shippingLastName;
  String shippingCompany;
  String shippingCountry;
  String shippingAddress1;
  String shippingAddress2;
  String shippingCity;
  String shippingState;
  String shippingPostcode;
  List<Country> countries;
  Nonce nonce;
  String checkoutNonce;
  String wpnonce;
  String checkoutLogin;
  String saveAccountDetails;
  bool userLogged;
  String logoutUrl;
  int userId;

  CheckoutFormModel({
    this.billingFirstName,
    this.billingLastName,
    this.billingCompany,
    this.billingCountry,
    this.billingAddress1,
    this.billingAddress2,
    this.billingCity,
    this.billingState,
    this.billingPostcode,
    this.billingPhone,
    this.billingEmail,
    this.shippingFirstName,
    this.shippingLastName,
    this.shippingCompany,
    this.shippingCountry,
    this.shippingAddress1,
    this.shippingAddress2,
    this.shippingCity,
    this.shippingState,
    this.shippingPostcode,
    this.countries,
    this.nonce,
    this.checkoutNonce,
    this.wpnonce,
    this.checkoutLogin,
    this.saveAccountDetails,
    this.userLogged,
    this.logoutUrl,
    this.userId,
  });

  factory CheckoutFormModel.fromJson(Map<String, dynamic> json) => CheckoutFormModel(
    billingFirstName: json["billing_first_name"] == null ? '' : json["billing_first_name"],
    billingLastName: json["billing_last_name"] == null ? '' : json["billing_last_name"],
    billingCompany: json["billing_company"] == null ? '' : json["billing_company"],
    billingCountry: json["billing_country"] == null ? '' : json["billing_country"],
    billingAddress1: json["billing_address_1"] == null ? '' : json["billing_address_1"],
    billingAddress2: json["billing_address_2"] == null ? '' : json["billing_address_2"],
    billingCity: json["billing_city"] == null ? '' : json["billing_city"],
    billingState: json["billing_state"] == null ? '' : json["billing_state"],
    billingPostcode: json["billing_postcode"] == null ? '' : json["billing_postcode"],
    billingPhone: json["billing_phone"] == null ? '' : json["billing_phone"],
    billingEmail: json["billing_email"] == null ? '' : json["billing_email"],
    shippingFirstName: json["shipping_first_name"] == null ? '' : json["shipping_first_name"],
    shippingLastName: json["shipping_last_name"] == null ? '' : json["shipping_last_name"],
    shippingCompany: json["shipping_company"] == null ? '' : json["shipping_company"],
    shippingCountry: json["shipping_country"] == null ? '' : json["shipping_country"],
    shippingAddress1: json["shipping_address_1"] == null ? '' : json["shipping_address_1"],
    shippingAddress2: json["shipping_address_2"] == null ? '' : json["shipping_address_2"],
    shippingCity: json["shipping_city"] == null ? '' : json["shipping_city"],
    shippingState: json["shipping_state"] == null ? '' : json["shipping_state"],
    shippingPostcode: json["shipping_postcode"] == null ? '' : json["shipping_postcode"],
    countries: json["countries"] == null ? [] : List<Country>.from(json["countries"].map((x) => Country.fromJson(x))),
    nonce: json["nonce"] == null ? null : Nonce.fromJson(json["nonce"]),
    checkoutNonce: json["checkout_nonce"] == null ? '' : json["checkout_nonce"],
    wpnonce: json["_wpnonce"] == null ? '' : json["_wpnonce"],
    checkoutLogin: json["checkout_login"] == null ? false : json["checkout_login"],
    saveAccountDetails: json["save_account_details"] == null ? null : json["save_account_details"],
    userLogged: json["user_logged"] == null ? null : json["user_logged"],
  );

  Map<String, dynamic> toJson() => {
    "billing_first_name": billingFirstName == null ? null : billingFirstName,
    "billing_last_name": billingLastName == null ? null : billingLastName,
    "billing_company": billingCompany == null ? null : billingCompany,
    "billing_country": billingCountry == null ? null : billingCountry,
    "billing_address_1": billingAddress1 == null ? null : billingAddress1,
    "billing_address_2": billingAddress2 == null ? null : billingAddress2,
    "billing_city": billingCity == null ? null : billingCity,
    "billing_state": billingState == null ? null : billingState,
    "billing_postcode": billingPostcode == null ? null : billingPostcode,
    "billing_phone": billingPhone == null ? null : billingPhone,
    //"billing_email": billingEmail == null ? null : billingEmail,
    "shipping_first_name": shippingFirstName == null ? null : shippingFirstName,
    "shipping_last_name": shippingLastName == null ? null : shippingLastName,
    "shipping_company": shippingCompany == null ? null : shippingCompany,
    "shipping_country": shippingCountry == null ? null : shippingCountry,
    "shipping_address_1": shippingAddress1 == null ? null : shippingAddress1,
    "shipping_address_2": shippingAddress2 == null ? null : shippingAddress2,
    "shipping_city": shippingCity == null ? null : shippingCity,
    "shipping_state": shippingState == null ? null : shippingState,
    "shipping_postcode": shippingPostcode == null ? null : shippingPostcode,
    "countries": countries == null ? null : List<dynamic>.from(countries.map((x) => x.toJson())),
    "nonce": nonce == null ? null : nonce.toJson(),
    "checkout_nonce": checkoutNonce == null ? null : checkoutNonce,
    "_wpnonce": wpnonce == null ? null : wpnonce,
    "checkout_login": checkoutLogin == null ? null : checkoutLogin,
    "save_account_details": saveAccountDetails == null ? null : saveAccountDetails,
    "user_logged": userLogged == null ? null : userLogged,
    "logout_url": logoutUrl == null ? null : logoutUrl,
    "user_id": userId == null ? null : userId,
  };
}

class Country {
  String label;
  String value;
  List<Region> regions;

  Country({
    this.label,
    this.value,
    this.regions,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
    regions: json["regions"] == null ? null : List<Region>.from(json["regions"].map((x) => Region.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
    "regions": regions == null ? null : List<dynamic>.from(regions.map((x) => x.toJson())),
  };
}

class Region {
  String label;
  String value;

  Region({
    this.label,
    this.value,
  });

  factory Region.fromJson(Map<String, dynamic> json) => Region(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
  };
}

class Nonce {
  String ajaxUrl;
  String wcAjaxUrl;
  String updateOrderReviewNonce;
  String applyCouponNonce;
  String removeCouponNonce;
  String optionGuestCheckout;
  String checkoutUrl;
  bool debugMode;
  String i18NCheckoutError;

  Nonce({
    this.ajaxUrl,
    this.wcAjaxUrl,
    this.updateOrderReviewNonce,
    this.applyCouponNonce,
    this.removeCouponNonce,
    this.optionGuestCheckout,
    this.checkoutUrl,
    this.debugMode,
    this.i18NCheckoutError,
  });

  factory Nonce.fromJson(Map<String, dynamic> json) => Nonce(
    ajaxUrl: json["ajax_url"] == null ? null : json["ajax_url"],
    wcAjaxUrl: json["wc_ajax_url"] == null ? null : json["wc_ajax_url"],
    updateOrderReviewNonce: json["update_order_review_nonce"] == null ? null : json["update_order_review_nonce"],
    applyCouponNonce: json["apply_coupon_nonce"] == null ? null : json["apply_coupon_nonce"],
    removeCouponNonce: json["remove_coupon_nonce"] == null ? null : json["remove_coupon_nonce"],
    optionGuestCheckout: json["option_guest_checkout"] == null ? null : json["option_guest_checkout"],
    checkoutUrl: json["checkout_url"] == null ? null : json["checkout_url"],
    debugMode: json["debug_mode"] == null ? null : json["debug_mode"],
    i18NCheckoutError: json["i18n_checkout_error"] == null ? null : json["i18n_checkout_error"],
  );

  Map<String, dynamic> toJson() => {
    "ajax_url": ajaxUrl == null ? null : ajaxUrl,
    "wc_ajax_url": wcAjaxUrl == null ? null : wcAjaxUrl,
    "update_order_review_nonce": updateOrderReviewNonce == null ? null : updateOrderReviewNonce,
    "apply_coupon_nonce": applyCouponNonce == null ? null : applyCouponNonce,
    "remove_coupon_nonce": removeCouponNonce == null ? null : removeCouponNonce,
    "option_guest_checkout": optionGuestCheckout == null ? null : optionGuestCheckout,
    "checkout_url": checkoutUrl == null ? null : checkoutUrl,
    "debug_mode": debugMode == null ? null : debugMode,
    "i18n_checkout_error": i18NCheckoutError == null ? null : i18NCheckoutError,
  };
}
