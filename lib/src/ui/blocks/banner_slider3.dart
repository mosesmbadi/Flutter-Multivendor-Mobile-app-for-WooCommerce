import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../../models/blocks_model.dart';
import 'hex_color.dart';
import 'list_header.dart';

class BannerSlider3 extends StatefulWidget {
  final Block block;
  final Function onBannerClick;
  BannerSlider3({Key key, this.block, this.onBannerClick}) : super(key: key);
  @override
  _BannerSlider3State createState() => _BannerSlider3State();
}

class _BannerSlider3State extends State<BannerSlider3> {
  @override
  Widget build(BuildContext context) {
    Color bgColor = HexColor(widget.block.bgColor);
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            ListHeader(block: widget.block),
            Container(
              color: Theme.of(context).brightness != Brightness.dark ?  bgColor : Theme.of(context).canvasColor,
              height: widget.block.childHeight.toDouble(),
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                    onTap: () => widget.onBannerClick(widget.block.children[index]),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(widget.block.borderRadius)),
                      ),
                      margin: EdgeInsets.fromLTRB(double.parse(widget.block.paddingLeft.toString()),
                        0.0,
                        double.parse(widget.block.paddingRight
                            .toString()),
                        double.parse(widget.block.paddingBottom
                            .toString()),
                      ),
                      elevation: widget.block.elevation.toDouble(),
                      clipBehavior: Clip.antiAlias,
                      child:  CachedNetworkImage(
                        imageUrl: widget.block.children[index].image != null ? widget.block.children[index].image : '',
                        imageBuilder: (context, imageProvider) => Ink.image(
                          child: InkWell(
                            splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                            onTap: () => widget.onBannerClick(widget.block.children[index]),
                          ),
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) =>
                            Container(color: Colors.black12),
                        errorWidget: (context, url, error) => Container(color: Colors.black12),
                      ),
                    ),
                  );
                },
                itemCount: widget.block.children.length,
                containerHeight: widget.block.childHeight + widget.block.paddingTop + widget.block.paddingBottom,
                itemHeight: widget.block.childHeight,
                itemWidth: widget.block.childWidth,
                autoplay: true,
                layout: SwiperLayout.TINDER,
                viewportFraction: 1,
                scale: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
