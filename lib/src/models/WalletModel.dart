// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

List<WalletModel> walletModelFromJson(String str) => List<WalletModel>.from(json.decode(str).map((x) => WalletModel.fromJson(x)));

String walletModelToJson(List<WalletModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalletModel {
  WalletModel({
    this.transactionId,
    this.blogId,
    this.userId,
    this.type,
    this.amount,
    this.balance,
    this.currency,
    this.details,
    this.deleted,
    this.date,
  });

  String transactionId;
  String blogId;
  String userId;
  String type;
  String amount;
  String balance;
  String currency;
  String details;
  String deleted;
  DateTime date;

  factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    blogId: json["blog_id"] == null ? null : json["blog_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    type: json["type"] == null ? null : json["type"],
    amount: json["amount"] == null ? null : json["amount"],
    balance: json["balance"] == null ? null : json["balance"],
    currency: json["currency"] == null ? null : json["currency"],
    details: json["details"] == null ? null : json["details"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId == null ? null : transactionId,
    "blog_id": blogId == null ? null : blogId,
    "user_id": userId == null ? null : userId,
    "type": type == null ? null : type,
    "amount": amount == null ? null : amount,
    "balance": balance == null ? null : balance,
    "currency": currency == null ? null : currency,
    "details": details == null ? null : details,
    "deleted": deleted == null ? null : deleted,
    "date": date == null ? null : date.toIso8601String(),
  };
}
