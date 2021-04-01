import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../layout/adaptive.dart';
import '../../models/blocks_model.dart';
import 'hex_color.dart';
class BannerGridList extends StatefulWidget {
  final Block block;
  final Function onBannerClick;
  BannerGridList({Key key, this.block, this.onBannerClick}) : super(key: key);
  @override
  _BannerGridListState createState() => _BannerGridListState();
}

class _BannerGridListState extends State<BannerGridList> {
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);
    final containerWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = containerWidth ~/ (isDesktop ? 300 : 180);
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
          double.parse(widget.block.paddingLeft.toString()),
          0.0,
          double.parse(
              widget.block.paddingRight.toString()),
          double.parse(
              widget.block.paddingBottom.toString())),
      sliver: Container(
        child: SliverGrid(
          //  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isDesktop ? crossAxisCount : int.parse(widget.block.layoutGridCol.toString()),
              childAspectRatio: widget.block.childWidth/widget.block.childHeight,
              mainAxisSpacing: widget.block.paddingBetween,
              crossAxisSpacing: widget.block.paddingBetween
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius
                        .toString()))),
                child: InkWell(
                    onTap: () {
                      widget.onBannerClick(widget.block
                          .children[index]);
                    },
                    child: Card(
                        shape: widget.block.borderRadius != 50 ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(double.parse(
                              widget.block.borderRadius
                                  .toString())),
                        ) :StadiumBorder(),
                        clipBehavior: Clip.antiAlias,
                        elevation: widget.block.elevation.toDouble(),
                        child:  CachedNetworkImage(
                          imageUrl:  widget.block
                              .children[index].image,
                          imageBuilder: (context, imageProvider) => Ink.image(
                            child: InkWell(
                              splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                              onTap: () {
                                widget.onBannerClick(widget.block
                                    .children[index]);
                              },
                            ),
                            fit: BoxFit.cover,
                            image: imageProvider,
                          ),
                          placeholder: (context, url) =>
                              Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Container(color: Colors.black12),
                        ))),
              );
            },
            childCount: widget.block.children.length,
          ),
        ),
      ),
    );
  }
}
