import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../functions.dart';
import '../../layout/adaptive.dart';
import '../../models/blocks_model.dart';
import '../../models/category_model.dart';
import 'hex_color.dart';
import 'list_header.dart';


class VendorCategoryScrollList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  VendorCategoryScrollList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _VendorCategoryScrollListState createState() => _VendorCategoryScrollListState();
}

class _VendorCategoryScrollListState extends State<VendorCategoryScrollList> {
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
                        padding: EdgeInsets.fromLTRB(
                            double.parse(widget.block.paddingLeft
                                .toString()),
                            0.0,
                            double.parse(widget.block.paddingRight
                                .toString()),
                            double.parse(widget.block.paddingBottom
                                .toString())),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          double paddingLeft = widget.block.paddingBetween/2;
                          double paddingRight = widget.block.paddingBetween/2;
                          if(index == 0) {
                            paddingLeft = widget.block.paddingBetween;
                          } if (index == widget.categories.length - 1) {
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
                                  margin: EdgeInsets.all(0.0),
                                  clipBehavior: Clip.antiAlias,
                                  elevation: widget.block.elevation.toDouble(),
                                  child: InkWell(
                                    splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                    onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        AspectRatio(
                                            aspectRatio: widget.block.childHeight/widget.block.childWidth,
                                            child: widget.categories[index].image != null ? CachedNetworkImage(
                                              imageUrl: widget.categories[index].image,
                                              imageBuilder: (context, imageProvider) => Ink.image(
                                                child: InkWell(
                                                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                                  onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
                                                ),
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                              placeholder: (context, url) =>
                                                  Container(color: HexColor(widget.block.bgColor).withOpacity(0.5)),
                                              errorWidget: (context, url, error) => Container(color: Colors.black12),
                                            )  : Container(color: Colors.black12)
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: new Text(
                                              parseHtmlString(widget.categories[index].name),
                                              style: Theme.of(context).textTheme.display3,
                                              maxLines: 1,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
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
}

class VendorCategoryScrollStadiumList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  VendorCategoryScrollStadiumList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _VendorCategoryScrollStadiumListState createState() => _VendorCategoryScrollStadiumListState();
}

class _VendorCategoryScrollStadiumListState extends State<VendorCategoryScrollStadiumList> {
  @override
  Widget build(BuildContext context) {

    final bool isDesktop = isDisplayDesktop(context);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: isDesktop ? 280 : widget.block.childHeight.toDouble(),
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
                        padding: EdgeInsets.fromLTRB(
                            double.parse(widget.block.paddingLeft
                                .toString()) + widget.block.paddingBetween/2,
                            0.0,
                            double.parse(widget.block.paddingRight
                                .toString()) + widget.block.paddingBetween/2,
                            double.parse(widget.block.paddingBottom
                                .toString())),
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.categories.length,
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
                                      margin: EdgeInsets.all(0.0),
                                      clipBehavior: Clip.antiAlias,
                                      elevation: widget.block.elevation.toDouble(),
                                      child: InkWell(
                                        splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                        onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            AspectRatio(
                                                aspectRatio: 1,
                                                child: widget.categories[index].image != null ? CachedNetworkImage(
                                                  imageUrl: widget.categories[index].image,
                                                  imageBuilder: (context, imageProvider) => Ink.image(
                                                    child: InkWell(
                                                      splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                                      onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
                                                    ),
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  placeholder: (context, url) =>
                                                      Container(color: HexColor(widget.block.bgColor).withOpacity(0.5)),
                                                  errorWidget: (context, url, error) => Container(color: Colors.black12),
                                                )  : Container(color: Colors.black12)
                                            ),
                                          ],
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(
                                      parseHtmlString(widget.categories[index].name),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.headline1,
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
}
