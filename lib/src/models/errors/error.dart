// To parse this JSON data, do
//
//     final error = errorFromJson(jsonString);

import 'dart:convert';

WpErrors errorFromJson(String str) => WpErrors.fromJson(json.decode(str));

String errorToJson(WpErrors data) => json.encode(data.toJson());

class WpErrors {
  bool success;
  List<Datum> data;

  WpErrors({
    this.success,
    this.data,
  });

  factory WpErrors.fromJson(Map<String, dynamic> json) => new WpErrors(
    success: json["success"],
    data: new List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String code;
  String message;

  Datum({
    this.code,
    this.message,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => new Datum(
    code: json["code"] != null ? json["code"].toString() : null,
    message: json["message"] != null ? json["message"] : null,
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
  };
}


Notice noticeFromJson(String str) => Notice.fromJson(json.decode(str));

String noticeToJson(Notice data) => json.encode(data.toJson());

class Notice {
  Notice({
    this.success,
    this.data,
  });

  bool success;
  List<Messages> data;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Messages>.from(json["data"].map((x) => Messages.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Messages {
  Messages({
    this.notice,
    this.data,
  });

  String notice;
  List<dynamic> data;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
    notice: json["notice"] == null ? null : json["notice"],
    data: json["data"] == null ? null : List<dynamic>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "notice": notice == null ? null : notice,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x)),
  };
}
