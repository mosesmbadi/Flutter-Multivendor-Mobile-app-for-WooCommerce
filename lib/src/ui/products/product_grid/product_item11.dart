import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/accounts/login/login.dart';
import '../../../ui/products/product_detail/product_detail.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  const ProductGrid({Key key, this.products}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn ? 1 : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(_scaffoldPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.8,
          crossAxisCount:  crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return ProductItem(
                product: widget.products[index], onProductClick: onProductClick);
          },
          childCount: widget.products.length,
        ),
      ),
    );
  }
  onProductClick(Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final void Function(Product category) onProductClick;
  int percentOff = 0;

  ProductItem({
    Key key,
    this.product,
    this.onProductClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn ? 1 : screenWidth ~/ _minWidthPerColumn;

    double detailsWidth = (screenWidth / crossAxisCount ) - 150;
    if ((product.salePrice != null && product.salePrice != 0)) {
      percentOff = ((((product.regularPrice - product.salePrice) / product.regularPrice * 100)).round());
    }
    bool onSale = false;
    if(product.regularPrice == null || product.regularPrice.isNaN) {
      product.regularPrice = product.price;
    }

    if(product.salePrice != null && product.salePrice != 0) {
      onSale = true;
    }

    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.1),
      onTap: () {
        onProductClick(product);
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              //height: 120,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: product.images[0].src,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => Container(
                      width: 120,
                      height: 120,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                    ),
                  ),
                  percentOff != 0 ? Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(4.0), bottomLeft: Radius.circular(4.0)),
                      ),
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      color: Theme.of(context).accentColor,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                        child: Text(percentOff.toString() + '% OFF', style: Theme.of(context).accentTextTheme.bodyText1.copyWith(
                            fontSize: 12.0
                        ),),
                      ),
                    ),
                  ) : Container()
                ],
              ),
            ),
            Stack(
              children: <Widget>[
                Container(
                  width: detailsWidth,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16, 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(product.name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    letterSpacing: 0.0)),
                            SizedBox(height: 4.0),
                            Text(parseHtmlString(product.shortDescription),
                                maxLines: 2,
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  letterSpacing: 0.0,
                                  fontSize: 10,
                                )),
                            SizedBox(height: 6.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Text(onSale ? parseHtmlString(product.formattedSalesPrice)
                                    : '', style: Theme.of(context).textTheme.body1.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).hintColor,
                                )),
                                onSale ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
                                Text((product.formattedPrice !=
                                    null && product.formattedPrice.isNotEmpty)
                                    ? parseHtmlString(product.formattedPrice)
                                    : '', style: TextStyle(
                                  fontWeight: onSale ? FontWeight.w200 : FontWeight.w600,
                                  fontSize: onSale ? 10 : 14,
                                  color: onSale ? Theme.of(context).hintColor : Theme.of(context).colorScheme.onSurface,
                                  decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
                                )),
                              ],
                            ),
                          ],
                        ),
                        Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(1.0),
                            ),
                          ),
                          color: _getColor(),
                          child: Container(
                            padding: EdgeInsets.all(2.0),
                            width: 40.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(product.averageRating.substring(0,3),
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600
                                    )),
                                SizedBox(width: 4.0),
                                Icon(Icons.star, size: 10.0,color: Colors.white,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                  return Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: IconButton(
                        icon: model.wishListIds.contains(product.id) ? Icon(Icons.favorite, color: Theme.of(context).accentColor) :
                        Icon(Icons.favorite_border, color: Colors.black87),
                        onPressed: () {
                          if (!model.loggedIn) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Login()));
                          } else {
                            model.updateWishList(product.id);
                          }
                        }
                    ),
                  );
                })
              ],
            ),
          ],
        ),
      ),
    );
  }

  _getColor() {
    final rating = double.parse(product.averageRating);
    if(rating >= 4.5) {
      return Colors.green[700];
    } if(rating >= 4.0) {
      return Colors.green[500];
    } if(rating >= 3.5) {
      return Colors.green[300];
    } if(rating >= 3.0) {
      return Colors.amber;
    } if(rating >= 2.0) {
      return Colors.amber[300];
    } else return Colors.amber[300];
  }
}
