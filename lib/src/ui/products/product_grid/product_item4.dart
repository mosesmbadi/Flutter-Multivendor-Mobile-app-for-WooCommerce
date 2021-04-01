import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../layout/adaptive.dart';
import './../../../layout/text_scale.dart';
import './../../../ui/products/product_grid/product_item.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/accounts/login/login.dart';
import '../../../ui/products/product_detail/product_detail.dart';

double desktopCategoryMenuPageWidth({
  BuildContext context,
}) {
  return 232 * reducedTextScale(context);
}

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  const ProductGrid({Key key, this.products}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {

  @override
  Widget build(BuildContext context) {

    final bool isDesktop = isDisplayDesktop(context);

    final containerWidth = isDesktop ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width;

    final crossAxisCount = containerWidth ~/ (isDesktop ? 200 : 180);

    final childAspectRatio = (containerWidth / (crossAxisCount * 16)) / ((containerWidth / (crossAxisCount * 16)) * 1.55);

    return SliverPadding(
      padding: const EdgeInsets.all(8.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: childAspectRatio,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return ProductItem(crossAxisCount: crossAxisCount, containerWidth: containerWidth,
                product: widget.products[index]);
          },
          childCount: widget.products.length,
        ),
      ),
    );
  }
}

class ProductItem extends StatefulWidget {

  final Product product;
  final crossAxisCount;
  final containerWidth;

  ProductItem({
    Key key,
    this.product,
    this.crossAxisCount,
    this.containerWidth
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  final appStateModel = AppStateModel();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {

    int percentOff = 0;

    if ((widget.product.salePrice != null && widget.product.salePrice != 0)) {
      percentOff = (((widget.product.regularPrice - widget.product.salePrice) / widget.product.regularPrice) * 100).round();
    }
    bool onSale = false;

    if(widget.product.salePrice != 0) {
      onSale = true;
    }

    return Container(
      child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
        return Card(
          margin: EdgeInsets.all(0),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: Theme.of(context).splashColor.withOpacity(0.1),
            onTap: () {
              onProductClick(widget.product);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: widget.containerWidth/widget.crossAxisCount,
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: widget.product.images[0].src,
                        imageBuilder: (context, imageProvider) => Ink.image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).focusColor.withOpacity(0.02),
                        ),
                        errorWidget: (context, url, error) => Container(color: Theme.of(context).focusColor.withOpacity(1)),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: IconButton(
                            icon: model.wishListIds.contains(widget.product.id) ? Icon(Icons.favorite, color: Theme.of(context).accentColor) :
                            Icon(Icons.favorite_border, color: Colors.black87),
                            onPressed: () {
                              if (!model.loggedIn) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Login()));
                              } else {
                                model.updateWishList(widget.product.id);
                              }
                            }
                        ),
                      ),
                      percentOff != 1 ? Positioned(
                        left: 0.0,
                        top: 0.0,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(4.0)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          elevation: 0.0,
                          margin: EdgeInsets.all(0.0),
                          color: Theme.of(context).accentColor,
                          child: percentOff != 0 ? Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                              child: Text('-'+percentOff.toString() + '%', style: Theme.of(context).accentTextTheme.bodyText1.copyWith(
                                  fontSize: 12.0
                              ),),
                            ),

                          ) : Container(),
                        ),
                      ) : Container()
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(6.0, 10, 6, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        widget.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Container(alignment: Alignment.topLeft, child: PriceWidget(onSale: onSale, product: widget.product)),
                      SizedBox(height: 8.0),
                      //AddToCart(model: model, product: widget.product,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
      ),
    );
  }
  onProductClick(Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }
}

