import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/blocks_model.dart';
import 'hex_color.dart';
import 'list_header.dart';

class BannerScrollList extends StatefulWidget {

  final Block block;
  final Function onBannerClick;
  BannerScrollList({Key key, this.block, this.onBannerClick}) : super(key: key);

  @override
  _BannerScrollListState createState() => _BannerScrollListState();
}

class _BannerScrollListState extends State<BannerScrollList> {

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            height: widget.block.childHeight.toDouble(),
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
                        itemCount: widget.block.children.length,
                        itemBuilder: (BuildContext context, int index) {
                          double paddingLeft = widget.block.paddingBetween/2;
                          double paddingRight = widget.block.paddingBetween/2;
                          if(index == 0) {
                            paddingLeft = widget.block.paddingBetween;
                          } if (index == widget.block.children.length - 1) {
                            paddingRight = widget.block.paddingBetween;
                          }
                          return Container(
                              width: widget.block.childWidth.toDouble(),
                              padding: EdgeInsets.fromLTRB(paddingLeft, 0.0, paddingRight, 0.0),
                              child: InkWell(
                                splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                onTap: () => widget.onBannerClick(widget.block.children[index]),
                                child: Card(
                                  elevation: widget.block.elevation.toDouble(),
                                  shape: widget.block.borderRadius != 50 ? RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        double.parse(widget.block
                                            .borderRadius
                                            .toString())),
                                  ) : StadiumBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.block
                                        .children[index].image,
                                    imageBuilder: (context, imageProvider) => Ink.image(
                                      child: InkWell(
                                        splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                                        onTap: () {
                                          widget.onBannerClick(widget.block
                                              .children[index]);
                                        },
                                      ),
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    placeholder: (context, url) =>
                                        Container(color: HexColor(widget.block.bgColor).withOpacity(0.5)),
                                    errorWidget: (context, url, error) => Container(color: Colors.black12),
                                  ),),
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