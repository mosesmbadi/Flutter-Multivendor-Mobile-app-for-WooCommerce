import 'package:flutter/material.dart';

import '../../../src/ui/products/product_grid/product_item4.dart';
import '../../layout/adaptive.dart';
import '../../models/blocks_model.dart';


class ProductGridList extends StatefulWidget {
  final Block block;
  final Function onProductClick;
  ProductGridList({Key key, this.block, this.onProductClick}) : super(key: key);
  @override
  _ProductGridListState createState() => _ProductGridListState();
}

class _ProductGridListState extends State<ProductGridList> {
  @override
  Widget build(BuildContext context) {

    final bool isDesktop = isDisplayDesktop(context);

    final containerWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = containerWidth ~/ (isDesktop ? 180 : 180);

    final childAspectRatio = (containerWidth / (crossAxisCount * 16)) / ((containerWidth / (crossAxisCount * 16)) * 1.45);

    return ProductGrid(products: widget.block.products,);/*SliverPadding(
      padding: EdgeInsets.fromLTRB(
        double.parse(widget.block.paddingLeft.toString()),
        0.0,
        double.parse(widget.block.paddingRight.toString()),
        double.parse(widget.block.paddingBottom.toString()),
      ),
      sliver: SliverGrid(
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? crossAxisCount : int.parse(widget.block.layoutGridCol.toString()),
            childAspectRatio:
            isDesktop ? childAspectRatio : widget.block.childWidth / widget.block.childHeight,
            mainAxisSpacing: widget.block.paddingBetween,
            crossAxisSpacing: widget.block.paddingBetween),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    double.parse(widget.block.borderRadius.toString())),
                color: HexColor(widget.block.bgColor),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      double.parse(widget.block.borderRadius.toString())),
                ),
                margin: EdgeInsets.all(0.0),
                clipBehavior: Clip.antiAlias,
                elevation: widget.block.elevation.toDouble(),
                child: InkWell(
                  splashColor: HexColor(widget.block.bgColor).withOpacity(0.1),
                  onTap: () {
                    widget.onProductClick(widget.block.products[index]);
                  },
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 18.0 / 18.0,
                        child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: widget.block.products[index].images[0].src,
                              imageBuilder: (context, imageProvider) => Ink.image(
                                child: InkWell(
                                  splashColor: HexColor(widget.block.bgColor)
                                      .withOpacity(0.1),
                                  onTap: () {
                                    widget.onProductClick(
                                        widget.block.products[index]);
                                  },
                                ),
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              placeholder: (context, url) =>
                                  Container(color: Colors.black12),
                              errorWidget: (context, url, error) =>
                                  Container(color: Colors.black12),
                            ),
                            ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                              return Positioned(
                                top: 0.0,
                                right: 0.0,
                                child: IconButton(
                                    icon: model.wishListIds.contains(widget.block.products[index].id) ? Icon(Icons.favorite, color: Theme.of(context).accentColor) :
                                    Icon(Icons.favorite_border, color: Colors.black87),
                                    onPressed: () {
                                      if (!model.loggedIn) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Login()));
                                      } else {
                                        model.updateWishList(widget.block.products[index].id);
                                      }
                                    }
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4.0, 0, 4, 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.block.products[index].name,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(
                                    (widget.block.products[index]
                                        .formattedPrice !=
                                        null &&
                                        widget.block.products[index]
                                            .formattedPrice.isNotEmpty)
                                        ? parseHtmlString(widget.block
                                        .products[index].formattedPrice)
                                        : '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18,
                                    )),
                                SizedBox(width: 4.0),
                                Text(
                                    (widget.block.products[index].salePrice !=
                                        null &&
                                        widget.block.products[index]
                                            .salePrice !=
                                            0)
                                        ? parseHtmlString(widget
                                        .block
                                        .products[index]
                                        .formattedSalesPrice)
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                      decoration:
                                      TextDecoration.lineThrough,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ],
                            ),
                            SizedBox(height: 8.0),
                          ],
                        ),
                      ),
                      *//*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RatingBar(
                            initialRating: double.parse(widget.block.products[index].averageRating),
                            itemSize: 15,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            //unratedColor: Theme.of(context).accentColor.withOpacity(0.4),
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              
                            },
                          ),
                          widget.block.products[index].averageRating != '0.00' ? Row(
                            children: <Widget>[
                              SizedBox(width: 4.0),
                              Text('(' + widget.block.products[index].ratingCount.toString() + ')',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color:
                                    Theme.of(context).hintColor.withOpacity(0.4),
                                    fontSize: 12,
                                  )),
                            ],
                          ) : Container(),
                        ],
                      )*//*
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: widget.block.products.length,
        ),
      )
    );*/
  }
}