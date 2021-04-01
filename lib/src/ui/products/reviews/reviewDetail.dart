import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../blocs/product_detail_bloc.dart';
import '../../../models/product_model.dart';
import '../../../models/review_model.dart';


class ReviewsDetail extends StatefulWidget {
  final ProductDetailBloc productDetailBloc;
  final Product product;

  const ReviewsDetail({Key key, this.productDetailBloc, this.product}) : super(key: key);

  @override
  _ReviewsDetailState createState() => _ReviewsDetailState();
}

class _ReviewsDetailState extends State<ReviewsDetail> {

  final double widthOfSummaryOverview = 110;
  final double widthOfStarRow = 75;
  final double widthOfWholeSummary = 270;



  Color blk = Colors.black45;
  Color gry = Colors.grey.withOpacity(.4);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Customer Reviews',
          style: TextStyle(
          ),
        ),
      ),
      body: StreamBuilder<List<ReviewModel>>(
          stream: widget.productDetailBloc.allReviews,
          builder: (context, AsyncSnapshot<List<ReviewModel>> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: buildReviewSummary(snapshot, context),
                  ),
                  buildReviewsList(snapshot, context)
                ],
              );
              return buildReviewsList(snapshot, context);
            } else {
              return Container();
            }
          }),
      /*StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: buildReviewSummary(context),
              )
            ],
          );
        }
      ),*/
    );
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

  Column buildReviewSummary(AsyncSnapshot<List<ReviewModel>> snapshot, BuildContext context) {

    var fiveStars = snapshot.data.where((element) => double.parse(element.rating) > 4 && double.parse(element.rating) <= 5).length;
    var fourStars = snapshot.data.where((element) => double.parse(element.rating) > 3 && double.parse(element.rating) <= 4).length;
    var threeStars = snapshot.data.where((element) => double.parse(element.rating) > 2 && double.parse(element.rating) <= 3).length;
    var twoStars = snapshot.data.where((element) => double.parse(element.rating) > 1 && double.parse(element.rating) <= 2).length;
    var singleStars = snapshot.data.where((element) => double.parse(element.rating) > 0 && double.parse(element.rating) <= 1).length;

    var count = snapshot.data.length;
    //print(widget.product.averageRating);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                width: widthOfSummaryOverview,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: widget.product.averageRating.toString(),
                        style: Theme.of(context).textTheme.headline5.copyWith(
                            fontSize: 28,
                            fontWeight: FontWeight.w800
                        ),
                        children: <TextSpan>[
                          TextSpan(text: '/5', style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey),),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      initialRating: double.parse(widget.product.averageRating),
                      itemSize: 20,
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
                    Text(
                      '${snapshot.data.length} Ratings ',
                      style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.grey),),
                  ],
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                  height: 120,
                  child: VerticalDivider(
                    thickness: 1,
                    indent: 10,
                    endIndent: 0,
                  )
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row( children: [
                    buildStarRow(blk,blk,blk,blk,blk,),
                    SizedBox(
                      width: 10,
                    ),
                    buildBarStack(fiveStars, count),
                  ]),
                  Row(
                    children: [
                      buildStarRow(blk,blk,blk,blk,gry,),
                      SizedBox(
                        width: 10,
                      ),
                      buildBarStack(fourStars,count),
                    ],
                  ),
                  Row(
                    children: [
                      buildStarRow(blk,blk,blk,gry,gry,),
                      SizedBox(
                        width: 10,
                      ),
                      buildBarStack(threeStars,count),
                    ],
                  ),
                  Row(
                    children: [
                      buildStarRow(blk,blk,gry,gry,gry,),
                      SizedBox(
                        width: 10,
                      ),
                      buildBarStack(twoStars,count),
                    ],
                  ),
                  Row(
                    children: [
                      buildStarRow(blk,gry,gry,gry,gry,),
                      SizedBox(
                        width: 10,
                      ),
                      buildBarStack(singleStars,count )
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${fiveStars.floor()}',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),),
                  Text(
                    '${fourStars.floor()}',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),),
                  Text(
                    '${threeStars.floor()}',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),),
                  Text(
                    '${twoStars.floor()}',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),),
                  Text(
                    '${singleStars.floor()}',
                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey),),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Stack buildBarStack(int value, int count) {
    final width =MediaQuery.of(context).size.width-widthOfWholeSummary;
    return Stack(
      overflow: Overflow.visible,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 5,
            width: width,
            color: gry ,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4),
            topLeft: Radius.circular(4),
          ),
          child: Container(
            height: 5,
            width:width*(value/count),
            color: blk ,
          ),
        )

      ],
    );
  }

  Container buildStarRow(Color color1,Color color2,Color color3,Color color4,Color color5) {
    return Container(
      width: widthOfStarRow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.star,size: 15,color: color1 ),
          Icon(Icons.star,size: 15,color: color2,),
          Icon(Icons.star,size: 15,color: color3),
          Icon(Icons.star,size: 15,color: color4),
          Icon(Icons.star,size: 15,color: color5),

        ],
      ),
    );
  }
}