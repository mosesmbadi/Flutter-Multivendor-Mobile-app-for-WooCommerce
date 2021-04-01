import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../../blocs/page_detail_bloc.dart';
import '../../models/comment_model.dart';
import '../../models/post_model.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:timeago/timeago.dart' as timeago;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../checkout/webview.dart';

class PageDetail extends StatefulWidget {
  final Post post;
  final bloc = PageDetailBloc();
  PageDetail({Key key, this.post}) : super(key: key);

  @override
  _PageDetailState createState() => _PageDetailState(post: post);
}

class _PageDetailState extends State<PageDetail> {
  ScrollController _scrollController = new ScrollController();

  final Post post;

  _PageDetailState({this.post});

  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (this.post.title != null) {
      widget.bloc.addPost(this.post);
    }
    widget.bloc.postId.add(this.post.id);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.bloc.fetchMoreComments(this.post.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Post>(
            stream: widget.bloc.post,
            builder: (context, snapshot) {
              return snapshot.hasData ? Text(snapshot.data.title.rendered) : Container();
            }),
        
      ),
      body: StreamBuilder<Post>(
          stream: widget.bloc.post,
          builder: (context, snapshot) {
            var height;
            if (snapshot.hasData) {
              double width = MediaQuery.of(context).size.width;
              double aspectRatio = snapshot.data.featuredDetails != null
                  ? snapshot.data.featuredDetails.height /
                      snapshot.data.featuredDetails.width
                  : 1;
              if (snapshot.data.featuredUrl == null) {
                height = 0.0;
              } else
                height = (aspectRatio * width);
            } else if(snapshot.hasError) {
              return Center(
                child: Text('Nothing to show')
              );
            }
            return snapshot.hasData
                ? buildLayout1(height, snapshot, context)
                : Center(child: CircularProgressIndicator());
          }),
      floatingActionButton: StreamBuilder<Post>(
          stream: widget.bloc.post,
        builder: (context, snapshot) {
          return snapshot.hasData ? FloatingActionButton(
            onPressed: () => shareFun(snapshot),
            tooltip: 'Increment',
            backgroundColor: getColorFromHex('#183055'),
            child: Icon(Icons.share),
          ) : Container();
        }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  shareFun(AsyncSnapshot<Post> snapshot) {
    Share.share('Checkout this Article ' +
        snapshot.data.title.rendered +
        "  " +
        snapshot.data.link.toString());
  }

  CustomScrollView buildLayout1(
      height, AsyncSnapshot<Post> snapshot, BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        /*SliverAppBar(
          elevation: 1,
          expandedHeight: height,
          pinned: true,
          floating: true,
          snap: false,
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: snapshot.data.featuredUrl != null
                ? CachedNetworkImage(
                    imageUrl: snapshot.data.featuredUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Container(color: Colors.black12),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ) //Image.network(snapshot.data.featuredUrl, fit: BoxFit.fill)
                : Container(),
          ),
          //title: Text('Detail'),
        ),*/
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.data.title.rendered,
                  //style: Styles.title1,
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
              ),
              /* if (snapshot.data.authorDetails?.name != ' ')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 20.0,
                        backgroundImage:
                            NetworkImage(snapshot.data.authorDetails.avatar),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('By ' + snapshot.data.authorDetails.name,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400)),
                          ]),
                    ],
                  ),
                )
              else
                Container(),*/
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Text(
                  timeago.format(snapshot.data.date),
                  //style: Styles.title3
                  style: TextStyle(
                      fontSize: 12.0,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Html(
                  data: snapshot.data.content.rendered,
                  //Optional parameters:
                  onLinkTap: (url) async {
                    if (url.contains('https://wa.me')) {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else
                      openWebView(url);
                  },
                  onImageTap: (src) {
                    //
                  },
                ),
              ),
              StreamBuilder(
                  stream: widget.bloc.comments,
                  builder: (context, AsyncSnapshot<CommentsModel> snapshot) {
                    if (snapshot.hasData) {
                      return buildList(snapshot);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ],
          ),
        ),
      ],
    );
  }

  CustomScrollView buildLayout2(
      height, AsyncSnapshot<Post> snapshot, BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          elevation: 1,
          //expandedHeight: height,
          pinned: false,
          floating: true,
          //snap: false,
          /* flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: snapshot.data.featuredUrl != null ? Image.network(snapshot.data.featuredUrl, fit: BoxFit.fill) : null,
          ),*/
          title: Text('Detail'),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      timeago.format(snapshot.data.date),
                      style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.caption.color),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  snapshot.data.title.rendered,
                  style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage:
                          NetworkImage(snapshot.data.authorDetails.avatar),
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('By ' + snapshot.data.authorDetails.name,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                        ]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: snapshot.data.featuredUrl != null
                    ? Image.network(snapshot.data.featuredUrl)
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Html(data: snapshot.data.excerpt.rendered),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Html(
                  data: snapshot.data.content.rendered,
                  //Optional parameters:
                  onLinkTap: (url) async {
                    if (url.contains('https://wa.me')) {
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    } else
                      openWebView(url);
                  },
                  onImageTap: (src) {
                    //
                  },
                ),
              ),
              StreamBuilder(
                  stream: widget.bloc.comments,
                  builder: (context, AsyncSnapshot<CommentsModel> snapshot) {
                    if (snapshot.hasData) {
                      return buildList(snapshot);
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildList(AsyncSnapshot<CommentsModel> snapshot) {
    Iterable<Widget> listTiles = snapshot.data.comments
        .map<Widget>((Comment item) => buildListTile(context, item));
    listTiles = ListTile.divideTiles(context: context, tiles: listTiles);

    return Column(
      children: <Widget>[
        Column(
          children: listTiles.toList(),
        ),
        Container(
            height: 60,
            child: StreamBuilder(
                stream: widget.bloc.hasMoreCommets,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  return snapshot.hasData && snapshot.data == false
                      ? Center(child: Icon(FlutterIcons.document_ent, size: 150, color: Theme.of(context).focusColor,))
                      : Container();
                }
                //child: Center(child: CircularProgressIndicator())
                ))
      ],
    );
  }

  buildListTile(context, Comment comment) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(comment.authorAvatarUrls['96']),
              ),
              SizedBox(
                width: 16.0,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(comment.authorName,
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                    Text(timeago.format(comment.date),
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).textTheme.caption.color))
                  ]),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.content.rendered),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }

  void openWebView(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebViewPage(
        url: url,
      );
    }));
  }

  getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');

    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }

    return Color(int.parse(hexColor, radix: 16));
  }

  void whatsAppOpen(String url) async {
    await canLaunch(url)
        ? launch(url)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }

}
