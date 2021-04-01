import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../../blocs/vendor/vendor_detail_state_model.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_reviews_model.dart';
import 'write_review.dart';

class VendorReviewsList extends StatefulWidget {
  final VendorDetailStateModel vendorDetailModel;

  const VendorReviewsList({Key key, this.vendorDetailModel})
      : super(key: key);
  @override
  _VendorReviewsListState createState() => _VendorReviewsListState();
}

class _VendorReviewsListState extends State<VendorReviewsList> {

  ScrollController _reviewScrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  @override
  initState() {
    super.initState();
    _reviewScrollController.addListener(() async {
      if (_reviewScrollController.position.pixels ==
          _reviewScrollController.position.maxScrollExtent) {
        widget.vendorDetailModel.getMoreReviews();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<VendorDetailStateModel>(
      builder: (context, child, model) {
        return model.reviews != null &&
            model.reviews.length > 0
            ? CustomScrollView(
            controller: _reviewScrollController,
            slivers: buildList(model.reviews, context))
            : CustomScrollView(
            controller: _reviewScrollController,
            slivers: [
              writeReviewTile(),
              SliverToBoxAdapter(
                child: Container(height: 650),
              ),
            ]);
      },
    );
  }

  buildList(List<VendorReviews> reviews, BuildContext context) {
    List<Widget> list = new List<Widget>();
    list.add(writeReviewTile());
    list.add(buildReviewsList(reviews, context));
    if(reviews.length < 10);
    return list;
  }

  buildReviewsList(List<VendorReviews> reviews, BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildListTile(context, reviews[index]),
              Divider(
                height: 0.0,
              ),
            ]);
      }, childCount: reviews.length),
    );
  }

  buildListTile(context, VendorReviews comment) {
    return Container(
      padding: EdgeInsets.fromLTRB(22.0, 16.0, 16.0, 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('lib/assets/images/icon1.jpg'),
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
                          Text(comment.reviewTitle,
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.w400)),
                          RatingBar.builder(
                            initialRating: double.parse(comment.reviewRating),
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
                      Text(timeago.format(comment.created),
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).textTheme.caption.color))
                    ]),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Html(data: comment.reviewDescription),
        ],
      ),
    );
  }

  Widget writeReviewTile() {
    return SliverToBoxAdapter(
        child: Container(
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ReviewsPage(vendorDetailModel: widget.vendorDetailModel);
              }));
            },
            title: Text(appStateModel.blocks.localeText.yourReview),
            trailing: Icon(Icons.arrow_forward, color: Theme.of(context).focusColor,),
          ),
        ),
    );
  }


}
