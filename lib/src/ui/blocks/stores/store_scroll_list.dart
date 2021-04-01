import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import './../../../models/vendor/store_model.dart';
import './../../vendor/ui/products/vendor_detail/vendor_detail_nearby.dart';
import '../../../functions.dart';
import '../../../layout/adaptive.dart';
import '../../../models/blocks_model.dart';
import '../hex_color.dart';
import '../list_header.dart';


class StoreScrollList extends StatefulWidget {
  final Block block;
  StoreScrollList({Key key, this.block}) : super(key: key);
  @override
  _StoreScrollListState createState() => _StoreScrollListState();
}

class _StoreScrollListState extends State<StoreScrollList> {
  @override
  Widget build(BuildContext context) {

    final bool isDesktop = isDisplayDesktop(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: isDesktop ? 260 : widget.block.childHeight.toDouble(),
            color: Theme.of(context).brightness != Brightness.dark ? HexColor(widget.block.bgColor) : Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(
              double.parse(widget.block.paddingLeft
                  .toString()),
              0.0,
              double.parse(widget.block.paddingRight
                  .toString()),
              double.parse(widget.block.paddingBottom
                  .toString()),
            ),
            margin: EdgeInsets.fromLTRB(
                double.parse(widget.block.marginLeft
                    .toString()),
                double.parse(widget.block.marginTop
                    .toString()),
                double.parse(widget.block.marginRight
                    .toString()),
                double.parse(widget.block.marginBottom
                    .toString())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListHeader(block: widget.block),
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.block.stores.length,
                        itemBuilder: (BuildContext context, int index) {
                          double paddingLeft = widget.block.paddingBetween/2;
                          double paddingRight = widget.block.paddingBetween/2;
                          if(index == 0) {
                            paddingLeft = widget.block.paddingBetween;
                          } if (index == widget.block.stores.length - 1) {
                            paddingRight = widget.block.paddingBetween;
                          }
                          return Container(
                              padding: EdgeInsets.fromLTRB(paddingLeft,
                                  0.0,
                                  paddingRight,
                                  0.0),
                              width: isDesktop ? 220 : double.parse(widget.block.childWidth.toString()),
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  //margin: EdgeInsets.all(0.0),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: widget.block.elevation.toDouble(),
                                  child: InkWell(
                                    splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                    onTap: () => onStoreClick(widget.block.stores[index]),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AspectRatio(
                                            aspectRatio: 18.0 / 11.0,
                                            child: widget.block.stores[index].banner != null ? CachedNetworkImage(
                                              imageUrl: widget.block.stores[index].banner,
                                              imageBuilder: (context, imageProvider) => Ink.image(
                                                child: InkWell(
                                                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                                  onTap: () => onStoreClick(widget.block.stores[index]),
                                                ),
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(color: HexColor(widget.block.bgColor).withOpacity(0.5)),
                                              errorWidget: (context, url, error) => Container(color: Colors.white),
                                            )  : Container(color: Colors.white)
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: new Text(
                                              parseHtmlString(widget.block.stores[index].name),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4.0),
                                      ],
                                    ),
                                  )));
                        }))
              ],
            ),
          ),
        ],
      ),
    );
  }

  onStoreClick(StoreModel store) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VendorDetails(vendorId: store.id.toString())));
  }
}

class StoreScrollStadiumList extends StatefulWidget {
  final Block block;
  StoreScrollStadiumList({Key key, this.block}) : super(key: key);
  @override
  _StoreScrollStadiumListState createState() => _StoreScrollStadiumListState();
}

class _StoreScrollStadiumListState extends State<StoreScrollStadiumList> {
  @override
  Widget build(BuildContext context) {

    final bool isDesktop = isDisplayDesktop(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: isDesktop ? 330 : widget.block.childHeight.toDouble(),
            color: Theme.of(context).brightness != Brightness.dark ? HexColor(widget.block.bgColor) : Theme.of(context).scaffoldBackgroundColor,
            padding: EdgeInsets.fromLTRB(
              double.parse(widget.block.paddingLeft
                  .toString()),
              0.0,
              double.parse(widget.block.paddingRight
                  .toString()),
              double.parse(widget.block.paddingBottom
                  .toString()),
            ),
            margin: EdgeInsets.fromLTRB(
                double.parse(widget.block.marginLeft
                    .toString()),
                double.parse(widget.block.marginTop
                    .toString()),
                double.parse(widget.block.marginRight
                    .toString()),
                double.parse(widget.block.marginBottom
                    .toString())),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListHeader(block: widget.block),
                Expanded(
                    child: ListView.builder(
                        /*padding: EdgeInsets.fromLTRB(
                            double.parse(widget.block.paddingLeft
                                .toString()) + widget.block.paddingBetween/2,
                            0.0,
                            double.parse(widget.block.paddingRight
                                .toString()) + widget.block.paddingBetween/2,
                            double.parse(widget.block.paddingBottom
                                .toString())),*/
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.block.stores.length,
                        itemBuilder: (BuildContext context, int index) {
                          double paddingLeft = widget.block.paddingBetween/2;
                          double paddingRight = widget.block.paddingBetween/2;
                          return Container(
                              padding: EdgeInsets.fromLTRB(paddingLeft,
                                  0.0,
                                  paddingRight,
                                  0.0),
                              width:  isDesktop ? 220 : double.parse(widget.block.childWidth.toString()),
                              child: Column(
                                children: <Widget>[
                                  Card(
                                      shape: StadiumBorder(),
                                      //margin: EdgeInsets.all(0.0),
                                      clipBehavior: Clip.antiAlias,
                                      elevation: widget.block.elevation.toDouble(),
                                      child: InkWell(
                                        splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                        onTap: () => onStoreClick(widget.block.stores[index]),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            AspectRatio(
                                                aspectRatio: 1,
                                                child: widget.block.stores[index].banner != null ? CachedNetworkImage(
                                                  imageUrl: widget.block.stores[index].banner,
                                                  imageBuilder: (context, imageProvider) => Ink.image(
                                                    child: InkWell(
                                                      splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                                      onTap: () => onStoreClick(widget.block.stores[index]),
                                                    ),
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(color: HexColor(widget.block.bgColor).withOpacity(0.5)),
                                                  errorWidget: (context, url, error) => Container(color: Colors.white),
                                                )  : Container(color: Colors.white)
                                            ),
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      parseHtmlString(widget.block.stores[index].name),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                ],
                              ));
                        }))
              ],
            ),
          ),
        ],
      ),
    );
  }

  onStoreClick(StoreModel store) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VendorDetails(vendorId: store.id.toString())));
  }
}
