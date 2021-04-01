// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  int id;
  DateTime date;
  DateTime dateGmt;
  Guid guid;
  DateTime modified;
  DateTime modifiedGmt;
  String slug;
  String status;
  String type;
  String link;
  Guid title;
  Content content;
  Content excerpt;
  int author;
  int featuredMedia;
  String commentStatus;
  String pingStatus;
  bool sticky;
  String template;
  String format;
  Meta meta;
  List<int> categories;
  List<dynamic> tags;
  String featuredUrl;
  AuthorDetails authorDetails;
  FeaturedDetails featuredDetails;
  String excerptData;
  String commentCount;
  Links links;

  Post({
    this.id,
    this.date,
    this.dateGmt,
    this.guid,
    this.modified,
    this.modifiedGmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.content,
    this.excerpt,
    this.author,
    this.featuredMedia,
    this.commentStatus,
    this.pingStatus,
    this.sticky,
    this.template,
    this.format,
    this.meta,
    this.categories,
    this.tags,
    this.featuredUrl,
    this.authorDetails,
    this.featuredDetails,
    this.excerptData,
    this.commentCount,
    this.links,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json["id"] == null ? null : json["id"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    dateGmt: json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
    guid: json["guid"] == null ? null : Guid.fromJson(json["guid"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
    modifiedGmt: json["modified_gmt"] == null ? null : DateTime.parse(json["modified_gmt"]),
    slug: json["slug"] == null ? null : json["slug"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    link: json["link"] == null ? null : json["link"],
    title: json["title"] == null ? null : Guid.fromJson(json["title"]),
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    excerpt: json["excerpt"] == null ? null : Content.fromJson(json["excerpt"]),
    author: json["author"] == null ? null : json["author"],
    featuredMedia: json["featured_media"] == null ? null : json["featured_media"],
    commentStatus: json["comment_status"] == null ? null : json["comment_status"],
    pingStatus: json["ping_status"] == null ? null : json["ping_status"],
    sticky: json["sticky"] == null ? null : json["sticky"],
    template: json["template"] == null ? null : json["template"],
    format: json["format"] == null ? null : json["format"],
    meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    categories: json["categories"] == null ? null : List<int>.from(json["categories"].map((x) => x)),
    tags: json["tags"] == null ? null : List<dynamic>.from(json["tags"].map((x) => x)),
    featuredUrl: json["featuredUrl"] == null ? null : json["featuredUrl"],
    authorDetails: json["authorDetails"] == null ? null : AuthorDetails.fromJson(json["authorDetails"]),
    featuredDetails: json["featuredDetails"] == null ? null : FeaturedDetails.fromJson(json["featuredDetails"]),
    excerptData: json["excerptData"] == null ? null : json["excerptData"],
    commentCount: json["commentCount"] == null ? null : json["commentCount"],
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "date": date == null ? null : date.toIso8601String(),
    "date_gmt": dateGmt == null ? null : dateGmt.toIso8601String(),
    "guid": guid == null ? null : guid.toJson(),
    "modified": modified == null ? null : modified.toIso8601String(),
    "modified_gmt": modifiedGmt == null ? null : modifiedGmt.toIso8601String(),
    "slug": slug == null ? null : slug,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "link": link == null ? null : link,
    "title": title == null ? null : title.toJson(),
    "content": content == null ? null : content.toJson(),
    "excerpt": excerpt == null ? null : excerpt.toJson(),
    "author": author == null ? null : author,
    "featured_media": featuredMedia == null ? null : featuredMedia,
    "comment_status": commentStatus == null ? null : commentStatus,
    "ping_status": pingStatus == null ? null : pingStatus,
    "sticky": sticky == null ? null : sticky,
    "template": template == null ? null : template,
    "format": format == null ? null : format,
    "meta": meta == null ? null : meta.toJson(),
    "categories": categories == null ? null : List<dynamic>.from(categories.map((x) => x)),
    "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
    "featuredUrl": featuredUrl == null ? null : featuredUrl,
    "authorDetails": authorDetails == null ? null : authorDetails.toJson(),
    "featuredDetails": featuredDetails == null ? null : featuredDetails.toJson(),
    "excerptData": excerptData == null ? null : excerptData,
    "commentCount": commentCount == null ? null : commentCount,
    "_links": links == null ? null : links.toJson(),
  };
}

class AuthorDetails {
  String name;
  String avatar;

  AuthorDetails({
    this.name,
    this.avatar,
  });

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => AuthorDetails(
    name: json["name"] == null ? null : json["name"],
    avatar: json["avatar"] == null ? null : json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "avatar": avatar == null ? null : avatar,
  };
}

class Content {
  String rendered;
  bool protected;

  Content({
    this.rendered,
    this.protected,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"] == null ? null : json["rendered"],
    protected: json["protected"] == null ? null : json["protected"],
  );

  Map<String, dynamic> toJson() => {
    "rendered": rendered == null ? null : rendered,
    "protected": protected == null ? null : protected,
  };
}

class FeaturedDetails {
  int width;
  int height;
  String file;
  ImageMeta imageMeta;

  FeaturedDetails({
    this.width,
    this.height,
    this.file,
    this.imageMeta,
  });

  factory FeaturedDetails.fromJson(Map<String, dynamic> json) => FeaturedDetails(
    width: json["width"] == null ? null : json["width"],
    height: json["height"] == null ? null : json["height"],
    file: json["file"] == null ? null : json["file"],
    imageMeta: json["image_meta"] == null ? null : ImageMeta.fromJson(json["image_meta"]),
  );

  Map<String, dynamic> toJson() => {
    "width": width == null ? null : width,
    "height": height == null ? null : height,
    "file": file == null ? null : file,
    "image_meta": imageMeta == null ? null : imageMeta.toJson(),
  };
}

class ImageMeta {
  String aperture;
  String credit;
  String camera;
  String caption;
  String createdTimestamp;
  String copyright;
  String focalLength;
  String iso;
  String shutterSpeed;
  String title;
  String orientation;
  List<String> keywords;

  ImageMeta({
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  });

  factory ImageMeta.fromJson(Map<String, dynamic> json) => ImageMeta(
    aperture: json["aperture"] == null ? null : json["aperture"],
    credit: json["credit"] == null ? null : json["credit"],
    camera: json["camera"] == null ? null : json["camera"],
    caption: json["caption"] == null ? null : json["caption"],
    createdTimestamp: json["created_timestamp"] == null ? null : json["created_timestamp"],
    copyright: json["copyright"] == null ? null : json["copyright"],
    focalLength: json["focal_length"] == null ? null : json["focal_length"],
    iso: json["iso"] == null ? null : json["iso"],
    shutterSpeed: json["shutter_speed"] == null ? null : json["shutter_speed"],
    title: json["title"] == null ? null : json["title"],
    orientation: json["orientation"] == null ? null : json["orientation"],
    keywords: json["keywords"] == null ? null : List<String>.from(json["keywords"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "aperture": aperture == null ? null : aperture,
    "credit": credit == null ? null : credit,
    "camera": camera == null ? null : camera,
    "caption": caption == null ? null : caption,
    "created_timestamp": createdTimestamp == null ? null : createdTimestamp,
    "copyright": copyright == null ? null : copyright,
    "focal_length": focalLength == null ? null : focalLength,
    "iso": iso == null ? null : iso,
    "shutter_speed": shutterSpeed == null ? null : shutterSpeed,
    "title": title == null ? null : title,
    "orientation": orientation == null ? null : orientation,
    "keywords": keywords == null ? null : List<dynamic>.from(keywords.map((x) => x)),
  };
}

class Guid {
  String rendered;

  Guid({
    this.rendered,
  });

  factory Guid.fromJson(Map<String, dynamic> json) => Guid(
    rendered: json["rendered"] == null ? null : json["rendered"],
  );

  Map<String, dynamic> toJson() => {
    "rendered": rendered == null ? null : rendered,
  };
}

class Links {
  List<About> self;
  List<About> collection;
  List<About> about;
  List<Author> author;
  List<Author> replies;
  List<VersionHistory> versionHistory;
  List<PredecessorVersion> predecessorVersion;
  List<Author> wpFeaturedmedia;
  List<About> wpAttachment;
  List<WpTerm> wpTerm;
  List<Cury> curies;

  Links({
    this.self,
    this.collection,
    this.about,
    this.author,
    this.replies,
    this.versionHistory,
    this.predecessorVersion,
    this.wpFeaturedmedia,
    this.wpAttachment,
    this.wpTerm,
    this.curies,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? null : List<About>.from(json["self"].map((x) => About.fromJson(x))),
    collection: json["collection"] == null ? null : List<About>.from(json["collection"].map((x) => About.fromJson(x))),
    about: json["about"] == null ? null : List<About>.from(json["about"].map((x) => About.fromJson(x))),
    author: json["author"] == null ? null : List<Author>.from(json["author"].map((x) => Author.fromJson(x))),
    replies: json["replies"] == null ? null : List<Author>.from(json["replies"].map((x) => Author.fromJson(x))),
    versionHistory: json["version-history"] == null ? null : List<VersionHistory>.from(json["version-history"].map((x) => VersionHistory.fromJson(x))),
    predecessorVersion: json["predecessor-version"] == null ? null : List<PredecessorVersion>.from(json["predecessor-version"].map((x) => PredecessorVersion.fromJson(x))),
    wpFeaturedmedia: json["wp:featuredmedia"] == null ? null : List<Author>.from(json["wp:featuredmedia"].map((x) => Author.fromJson(x))),
    wpAttachment: json["wp:attachment"] == null ? null : List<About>.from(json["wp:attachment"].map((x) => About.fromJson(x))),
    wpTerm: json["wp:term"] == null ? null : List<WpTerm>.from(json["wp:term"].map((x) => WpTerm.fromJson(x))),
    curies: json["curies"] == null ? null : List<Cury>.from(json["curies"].map((x) => Cury.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
    "about": about == null ? null : List<dynamic>.from(about.map((x) => x.toJson())),
    "author": author == null ? null : List<dynamic>.from(author.map((x) => x.toJson())),
    "replies": replies == null ? null : List<dynamic>.from(replies.map((x) => x.toJson())),
    "version-history": versionHistory == null ? null : List<dynamic>.from(versionHistory.map((x) => x.toJson())),
    "predecessor-version": predecessorVersion == null ? null : List<dynamic>.from(predecessorVersion.map((x) => x.toJson())),
    "wp:featuredmedia": wpFeaturedmedia == null ? null : List<dynamic>.from(wpFeaturedmedia.map((x) => x.toJson())),
    "wp:attachment": wpAttachment == null ? null : List<dynamic>.from(wpAttachment.map((x) => x.toJson())),
    "wp:term": wpTerm == null ? null : List<dynamic>.from(wpTerm.map((x) => x.toJson())),
    "curies": curies == null ? null : List<dynamic>.from(curies.map((x) => x.toJson())),
  };
}

class About {
  String href;

  About({
    this.href,
  });

  factory About.fromJson(Map<String, dynamic> json) => About(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}

class Author {
  bool embeddable;
  String href;

  Author({
    this.embeddable,
    this.href,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    embeddable: json["embeddable"] == null ? null : json["embeddable"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable == null ? null : embeddable,
    "href": href == null ? null : href,
  };
}

class Cury {
  String name;
  String href;
  bool templated;

  Cury({
    this.name,
    this.href,
    this.templated,
  });

  factory Cury.fromJson(Map<String, dynamic> json) => Cury(
    name: json["name"] == null ? null : json["name"],
    href: json["href"] == null ? null : json["href"],
    templated: json["templated"] == null ? null : json["templated"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "href": href == null ? null : href,
    "templated": templated == null ? null : templated,
  };
}

class PredecessorVersion {
  int id;
  String href;

  PredecessorVersion({
    this.id,
    this.href,
  });

  factory PredecessorVersion.fromJson(Map<String, dynamic> json) => PredecessorVersion(
    id: json["id"] == null ? null : json["id"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "href": href == null ? null : href,
  };
}

class VersionHistory {
  int count;
  String href;

  VersionHistory({
    this.count,
    this.href,
  });

  factory VersionHistory.fromJson(Map<String, dynamic> json) => VersionHistory(
    count: json["count"] == null ? null : json["count"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
    "href": href == null ? null : href,
  };
}

class WpTerm {
  String taxonomy;
  bool embeddable;
  String href;

  WpTerm({
    this.taxonomy,
    this.embeddable,
    this.href,
  });

  factory WpTerm.fromJson(Map<String, dynamic> json) => WpTerm(
    taxonomy: json["taxonomy"] == null ? null : json["taxonomy"],
    embeddable: json["embeddable"] == null ? null : json["embeddable"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "taxonomy": taxonomy == null ? null : taxonomy,
    "embeddable": embeddable == null ? null : embeddable,
    "href": href == null ? null : href,
  };
}

class Meta {
  int likes;

  Meta({
    this.likes,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    likes: json["likes"] == null ? null : json["likes"],
  );

  Map<String, dynamic> toJson() => {
    "likes": likes == null ? null : likes,
  };
}
