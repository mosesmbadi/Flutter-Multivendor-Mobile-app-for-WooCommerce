// To parse this JSON data, do
//
//     final vendorReviews = vendorReviewsFromJson(jsonString);

import 'dart:convert';

List<VendorReviews> vendorReviewsFromJson(String str) => List<VendorReviews>.from(json.decode(str).map((x) => VendorReviews.fromJson(x)));

String vendorReviewsToJson(List<VendorReviews> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorReviews {
  String id;
  String vendorId;
  String authorId;
  String authorName;
  String authorEmail;
  String reviewTitle;
  String reviewDescription;
  String reviewRating;
  String approved;
  DateTime created;

  VendorReviews({
    this.id,
    this.vendorId,
    this.authorId,
    this.authorName,
    this.authorEmail,
    this.reviewTitle,
    this.reviewDescription,
    this.reviewRating,
    this.approved,
    this.created,
  });

  VendorReviews copyWith({
    String id,
    String vendorId,
    String authorId,
    String authorName,
    String authorEmail,
    String reviewTitle,
    String reviewDescription,
    String reviewRating,
    String approved,
    DateTime created,
  }) =>
      VendorReviews(
        id: id ?? this.id,
        vendorId: vendorId ?? this.vendorId,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        authorEmail: authorEmail ?? this.authorEmail,
        reviewTitle: reviewTitle ?? this.reviewTitle,
        reviewDescription: reviewDescription ?? this.reviewDescription,
        reviewRating: reviewRating ?? this.reviewRating,
        approved: approved ?? this.approved,
        created: created ?? this.created,
      );

  factory VendorReviews.fromJson(Map<String, dynamic> json) => VendorReviews(
    id: json["ID"] == null ? null : json["ID"],
    vendorId: json["vendor_id"] == null ? null : json["vendor_id"],
    authorId: json["author_id"] == null ? null : json["author_id"],
    authorName: json["author_name"] == null ? null : json["author_name"],
    authorEmail: json["author_email"] == null ? null : json["author_email"],
    reviewTitle: json["review_title"] == null ? null : json["review_title"],
    reviewDescription: json["review_description"] == null ? null : json["review_description"],
    reviewRating: json["review_rating"] == null ? null : json["review_rating"],
    approved: json["approved"] == null ? null : json["approved"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
    "vendor_id": vendorId == null ? null : vendorId,
    "author_id": authorId == null ? null : authorId,
    "author_name": authorName == null ? null : authorName,
    "author_email": authorEmail == null ? null : authorEmail,
    "review_title": reviewTitle == null ? null : reviewTitle,
    "review_description": reviewDescription == null ? null : reviewDescription,
    "review_rating": reviewRating == null ? null : reviewRating,
    "approved": approved == null ? null : approved,
    "created": created == null ? null : created.toIso8601String(),
  };
}
