// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);
class CommentsModel {
  final List<Comment> comments;

  CommentsModel({
    this.comments,
  });

  factory CommentsModel.fromJson(List<dynamic> parsedJson) {

    List<Comment> comments = new List<Comment>();
    comments = parsedJson.map((i)=>Comment.fromJson(i)).toList();

    return new CommentsModel(comments : comments);
  }

}

class Comment {
  int id;
  int post;
  int parent;
  int author;
  String authorName;
  String authorUrl;
  DateTime date;
  DateTime dateGmt;
  Content content;
  String link;
  String status;
  String type;
  Map<String, String> authorAvatarUrls;
  List<dynamic> meta;
  Links links;

  Comment({
    this.id,
    this.post,
    this.parent,
    this.author,
    this.authorName,
    this.authorUrl,
    this.date,
    this.dateGmt,
    this.content,
    this.link,
    this.status,
    this.type,
    this.authorAvatarUrls,
    this.meta,
    this.links,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"] == null ? null : json["id"],
    post: json["post"] == null ? null : json["post"],
    parent: json["parent"] == null ? null : json["parent"],
    author: json["author"] == null ? null : json["author"],
    authorName: json["author_name"] == null ? null : json["author_name"],
    authorUrl: json["author_url"] == null ? null : json["author_url"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    dateGmt: json["date_gmt"] == null ? null : DateTime.parse(json["date_gmt"]),
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    link: json["link"] == null ? null : json["link"],
    status: json["status"] == null ? null : json["status"],
    type: json["type"] == null ? null : json["type"],
    authorAvatarUrls: json["author_avatar_urls"] == null ? null : Map.from(json["author_avatar_urls"]).map((k, v) => MapEntry<String, String>(k, v)),
    meta: json["meta"] == null ? null : List<dynamic>.from(json["meta"].map((x) => x)),
    links: json["_links"] == null ? null : Links.fromJson(json["_links"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "post": post == null ? null : post,
    "parent": parent == null ? null : parent,
    "author": author == null ? null : author,
    "author_name": authorName == null ? null : authorName,
    "author_url": authorUrl == null ? null : authorUrl,
    "date": date == null ? null : date.toIso8601String(),
    "date_gmt": dateGmt == null ? null : dateGmt.toIso8601String(),
    "content": content == null ? null : content.toJson(),
    "link": link == null ? null : link,
    "status": status == null ? null : status,
    "type": type == null ? null : type,
    "author_avatar_urls": authorAvatarUrls == null ? null : Map.from(authorAvatarUrls).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "meta": meta == null ? null : List<dynamic>.from(meta.map((x) => x)),
    "_links": links == null ? null : links.toJson(),
  };
}

class Content {
  String rendered;

  Content({
    this.rendered,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    rendered: json["rendered"] == null ? null : json["rendered"],
  );

  Map<String, dynamic> toJson() => {
    "rendered": rendered == null ? null : rendered,
  };
}

class Links {
  List<Collection> self;
  List<Collection> collection;
  List<Author> author;
  List<Up> up;

  Links({
    this.self,
    this.collection,
    this.author,
    this.up,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    self: json["self"] == null ? null : List<Collection>.from(json["self"].map((x) => Collection.fromJson(x))),
    collection: json["collection"] == null ? null : List<Collection>.from(json["collection"].map((x) => Collection.fromJson(x))),
    author: json["author"] == null ? null : List<Author>.from(json["author"].map((x) => Author.fromJson(x))),
    up: json["up"] == null ? null : List<Up>.from(json["up"].map((x) => Up.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "self": self == null ? null : List<dynamic>.from(self.map((x) => x.toJson())),
    "collection": collection == null ? null : List<dynamic>.from(collection.map((x) => x.toJson())),
    "author": author == null ? null : List<dynamic>.from(author.map((x) => x.toJson())),
    "up": up == null ? null : List<dynamic>.from(up.map((x) => x.toJson())),
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

class Collection {
  String href;

  Collection({
    this.href,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "href": href == null ? null : href,
  };
}

class Up {
  bool embeddable;
  String postType;
  String href;

  Up({
    this.embeddable,
    this.postType,
    this.href,
  });

  factory Up.fromJson(Map<String, dynamic> json) => Up(
    embeddable: json["embeddable"] == null ? null : json["embeddable"],
    postType: json["post_type"] == null ? null : json["post_type"],
    href: json["href"] == null ? null : json["href"],
  );

  Map<String, dynamic> toJson() => {
    "embeddable": embeddable == null ? null : embeddable,
    "post_type": postType == null ? null : postType,
    "href": href == null ? null : href,
  };
}
