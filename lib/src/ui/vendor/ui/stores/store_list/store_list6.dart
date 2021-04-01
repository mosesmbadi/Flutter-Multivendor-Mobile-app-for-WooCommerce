import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../products/vendor_detail/vendor_detail.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/store_model.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class StoresList6 extends StatelessWidget {
  final List<StoreModel> stores;
  StoresList6({Key key, this.stores}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: EdgeInsets.all(8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return StoreCard(store: stores[index], index: index);
          },
          childCount: stores.length,
        ),
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  AppStateModel appStateModel = AppStateModel();
  final StoreModel store;
  final int index;
  StoreCard({Key key, this.store, this.index}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Widget featuredImage = store.banner != null
        ? CachedNetworkImage(
            imageUrl: store.banner,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.white),
          )
        : Container();
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.all(16),
      child: InkWell(
        onTap: () => openDetails(store, context),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              child: featuredImage,
            ),
            Container(
              padding: EdgeInsets.all(8),
              height: 120,
              child: Row(
                children: [
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: new Text(store.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            )),
                      ),
                      SizedBox(height: 4),
                      store.averageRating != null ? buildRatingBar(context) : Container()
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildRatingBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        RatingBar.builder(
          itemSize: 12.0,
          initialRating: store.averageRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          unratedColor: Theme.of(context).focusColor,
          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        store.ratingCount != 0 ? Column(
          children: [
            SizedBox(
              width: 6.0,
            ),
            Text(
              '(' +
                  store.ratingCount.toString() +
                  ' ' + appStateModel.blocks.localeText.reviews +
                  ')',
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w300),
            ),
          ],
        ) : Container(),
      ],
    );
  }

  openDetails(StoreModel store, BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorDetails(
        vendorId: store.id.toString(),
      );
    }));
  }
}
