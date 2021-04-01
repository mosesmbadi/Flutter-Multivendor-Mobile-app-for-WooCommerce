import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../src/blocs/product_detail_bloc.dart';
import '../../../../src/models/review_model.dart';

class ReviewList extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;

  const ReviewList({Key key, this.productDetailBloc}) : super(key: key);
  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ReviewModel>>(
        stream: widget.productDetailBloc.allReviews,
        builder: (context, AsyncSnapshot<List<ReviewModel>> snapshot) {
          if (snapshot.hasData) {
            return buildReviewsList(snapshot, context);
          } else {
            return SliverToBoxAdapter();
          }
        });;
  }

  Widget buildReviewsList(
      AsyncSnapshot<List<ReviewModel>> snapshot, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildListTile(context, snapshot.data[index]),
              Divider(
                height: 0.0,
              ),
            ]);
      }, childCount: snapshot.data.length),
    );
  }

  buildListTile(context, ReviewModel comment) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 16.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(comment.avatar),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(comment.author,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                          RatingBar.builder(
                            initialRating: double.parse(comment.rating),
                            itemSize: 15,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                      Text(timeago.format(comment.date),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).textTheme.caption.color))
                    ]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.content),
        ],
      ),
    );
  }
}
