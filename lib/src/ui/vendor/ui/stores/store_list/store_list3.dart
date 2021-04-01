import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../products/vendor_detail/vendor_detail.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/store_model.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class StoresList3 extends StatelessWidget {
  final List<StoreModel> stores;
  StoresList3({Key key, this.stores}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: EdgeInsets.all(16),
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
            //TODO ADD AssetImage as placeholder
            placeholder: (context, url) => Container(color: Colors.black12),
            //TODO ADD AssetImage as placeholder
            errorWidget: (context, url, error) =>
                Container(color: Colors.white),
          )
        : Container();
    return Container(
      height: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0)),
        ),
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 10.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openDetails(store, context),
          child: new Stack(
            children: <Widget>[
              featuredImage,
              new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: new Container(
                  decoration: new BoxDecoration(
                    color: Colors.purple,
                    gradient: new LinearGradient(
                        colors: [Colors.black54, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: new Alignment(0.0, 0.0),
                        tileMode: TileMode.clamp),
                  ),
                ),
              ),
              new Positioned(
                left: 10.0,
                bottom: 10.0,
                child: Row(
                  children: <Widget>[
                    store.icon != null
                        ? CircleAvatar(
                            backgroundImage:
                                CachedNetworkImageProvider(store.icon),
                            backgroundColor: Colors.black12,
                          )
                        : CircleAvatar(
                            //TODO ADD AssetImage as placeholder
                            backgroundImage:
                                CachedNetworkImageProvider(store.icon),
                            backgroundColor: Colors.black12,
                          ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 340,
                          child: new Text(store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white,
                              )),
                        ),
                        store.averageRating != null ? buildRatingBar() : Container()
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildRatingBar() {
    return Row(
      children: <Widget>[
        RatingBar.builder(
          itemSize: 12.0,
          initialRating: store.averageRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
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
