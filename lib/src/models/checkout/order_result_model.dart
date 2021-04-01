
import 'dart:convert';

OrderResult OrderResultFromJson(String str) => OrderResult.fromJson(json.decode(str));

class OrderResult {
  String result;
  String messages;
  String redirect;

  OrderResult({
    this.result,
    this.messages,
    this.redirect,
  });

  factory OrderResult.fromJson(Map<String, dynamic> json) => new OrderResult(
    result: json["result"] == null ? null : json["result"],
    messages: json["messages"] == null ? null : json["messages"],
    redirect: json["redirect"] == null ? null : json["redirect"],
  );

}