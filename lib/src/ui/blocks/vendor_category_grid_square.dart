import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import './../blocks/vendor_all_categories.dart';
import '../../functions.dart';
import '../../layout/adaptive.dart';
import '../../models/blocks_model.dart';
import '../../models/category_model.dart';
import 'hex_color.dart';

class VendorCategoryGridList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  VendorCategoryGridList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _VendorCategoryGridListState createState() => _VendorCategoryGridListState();
}

class _VendorCategoryGridListState extends State<VendorCategoryGridList> {

  int count;

  @override
  void initState() {
    super.initState();
    if(widget.categories.length < 8)
      count = widget.categories.length;
    else count = 8;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);

    final containerWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = containerWidth ~/ (isDesktop ? 180 : 180);

    final childAspectRatio = (containerWidth / (crossAxisCount * 16)) / ((containerWidth / (crossAxisCount * 16)) * 1.25);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        double.parse(widget.block.paddingLeft.toString()),
        0.0,
        double.parse(widget.block.paddingRight.toString()),
        double.parse(widget.block.paddingBottom.toString()),
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDisplayDesktop(context) ? crossAxisCount : int.parse(widget.block.layoutGridCol.toString()),
            childAspectRatio: isDisplayDesktop(context) ? childAspectRatio : widget.block.childWidth/widget.block.childHeight,
            mainAxisSpacing: widget.block.paddingBetween,
            crossAxisSpacing: widget.block.paddingBetween
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return index > 8 ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                color: HexColor(widget.block.bgColor),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                ),
                margin: EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAlias,
                elevation: widget.block.elevation.toDouble(),
                child: InkWell(
                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                  onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 18.0 / 14.0,
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
                              Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Container(color: Colors.black12),
                        ) : Container(color: Colors.black12),
                      ),
                      SizedBox(height: 10.0),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: new Text(
                          parseHtmlString(widget.categories[index].name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ) : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                color: HexColor(widget.block.bgColor),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(double.parse(widget.block.borderRadius.toString())),
                ),
                margin: EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAlias,
                elevation: widget.block.elevation.toDouble(),
                child: InkWell(
                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                  onTap: () => _viewAll(),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 18.0 / 14.0,
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
                              Container(color: Colors.black12),
                          errorWidget: (context, url, error) => Container(color: Colors.black12),
                        ) : Container(color: Colors.black12),
                      ),
                      SizedBox(height: 10.0),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: new Text(
                          parseHtmlString(widget.categories[index].name),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: count,
        ),
      ),
    );
  }

  _viewAll() {

  }
}

class VendorCategoryStadiumGridList extends StatefulWidget {
  final Block block;
  final List<Category> categories;
  final Function onCategoryClick;
  VendorCategoryStadiumGridList({Key key, this.block, this.categories, this.onCategoryClick}) : super(key: key);
  @override
  _VendorCategoryStadiumGridListState createState() => _VendorCategoryStadiumGridListState();
}

class _VendorCategoryStadiumGridListState extends State<VendorCategoryStadiumGridList> {

  int count;

  @override
  void initState() {
    super.initState();
    if(widget.categories.length < 8)
      count = widget.categories.length;
    else count = 8;
  }


  @override
  Widget build(BuildContext context) {
    final bool isDesktop = isDisplayDesktop(context);

    final containerWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = containerWidth ~/ (isDesktop ? 180 : 180);

    final childAspectRatio = (containerWidth / (crossAxisCount * 16)) / ((containerWidth / (crossAxisCount * 16)) * 1.35);

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        double.parse(widget.block.paddingLeft.toString()),
        16.0,
        double.parse(widget.block.paddingRight.toString()),
        double.parse(widget.block.paddingBottom.toString()),
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDisplayDesktop(context) ? crossAxisCount : int.parse(widget.block.layoutGridCol.toString()),
            childAspectRatio: isDisplayDesktop(context) ? childAspectRatio : widget.block.childWidth/widget.block.childHeight,
            mainAxisSpacing: widget.block.paddingBetween,
            crossAxisSpacing: widget.block.paddingBetween
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return index < 7 ? Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    shape: StadiumBorder(),
                    margin: EdgeInsets.all(0.0),
                    clipBehavior: Clip.antiAlias,
                    elevation: widget.block.elevation.toDouble(),
                    child: InkWell(
                      splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                      onTap: () => widget.onCategoryClick(widget.categories[index], widget.categories),
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
                            Container(color: Colors.black12.withOpacity(0.01)),
                        errorWidget: (context, url, error) => Container(color: Colors.black12.withOpacity(0.01)),
                      ) : Container(color: Colors.black12.withOpacity(0.01)),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: new Text(
                    parseHtmlString(widget.categories[index].name),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ) : Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    shape: StadiumBorder(),
                    margin: EdgeInsets.all(0.0),
                    clipBehavior: Clip.antiAlias,
                    elevation: widget.block.elevation.toDouble(),
                    child: InkWell(
                      splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                      onTap: () => _viewAll(),
                      child: Container(color: Colors.black12.withOpacity(0.01), child: Icon(Icons.list, size: 60, color: Theme.of(context).highlightColor,)),
                    ),
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: new Text(
                    parseHtmlString('View All'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
          childCount: count,
        ),
      ),
    );
  }

  _viewAll() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VendorAllCategories(categories: widget.categories)));
  }
}