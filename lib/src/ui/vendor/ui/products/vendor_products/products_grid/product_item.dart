import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../../../../../functions.dart';
import '../../../../../../models/app_state_model.dart';
import '../../../../../../models/vendor/vendor_product_model.dart';
import '../product_detail.dart';

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class ProductGrid extends StatefulWidget {
  final List<VendorProduct> products;
  const ProductGrid({Key key, this.products}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.5,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return ProductItem(
                product: widget.products[index],
                onProductClick: onProductClick);
          },
          childCount: widget.products.length,
        ),
      ),
    );
  }

  onProductClick(VendorProduct product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return VendorProductDetail(
        product: product,
      );
    }));
  }
}

class ProductItem extends StatelessWidget {
  final VendorProduct product;
  final void Function(VendorProduct product) onProductClick;
  int percentOff = 0;

  NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2, name: AppStateModel().selectedCurrency);

  ProductItem({
    Key key,
    this.product,
    this.onProductClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double detailsWidth = MediaQuery.of(context).size.width - 160;

    bool onSale = false;
    if ((product.salePrice.isNotEmpty &&
        double.parse(product.salePrice) != 0)) {
      onSale = true;
    }
    /*if (product.regularPrice == null ||
        product.regularPrice.isNotEmpty &&
            product.price != null &&
            product.price.isNotEmpty) {
      product.regularPrice = product.price;
    }

    if ((product.salePrice != null &&
        product.salePrice.isNotEmpty &&
        double.parse(product.salePrice) != 0 &&
        product.regularPrice != null &&
        product.regularPrice.isNotEmpty)) {
      onSale = true;
      try {
        percentOff = ((((double.parse(product.regularPrice) -
                    double.parse(product.salePrice)) /
                double.parse(product.regularPrice) *
                100))
            .round());
      } catch (e) {
        print(e);
      }
    }*/

    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        splashColor: Theme.of(context).accentColor.withOpacity(0.1),
        onTap: () {
          onProductClick(product);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              height: 160,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: product.images[0].src,
                    imageBuilder: (context, imageProvider) => Card(
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
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
                  percentOff != 0
                      ? Positioned(
                          top: 10.0,
                          left: 0.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                            elevation: 0.0,
                            margin: EdgeInsets.all(0.0),
                            color: Theme.of(context).accentColor,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                              child: Text(
                                percentOff.toString() + '% OFF',
                                style: Theme.of(context)
                                    .accentTextTheme
                                    .body2
                                    .copyWith(fontSize: 12.0),
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Container(
              width: detailsWidth,
              height: 160,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(product.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.0)),
                        SizedBox(height: 4.0),
                        Text(parseHtmlString(product.shortDescription),
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 0.0,
                              fontSize: 14,
                            )),
                        SizedBox(height: 6.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                                onSale
                                    ? formatter
                                        .format(double.parse(product.price))
                                    : '',
                                style: TextStyle(
                                  color: Theme.of(context).hintColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                )),
                            onSale
                                ? SizedBox(width: 6.0)
                                : SizedBox(width: 0.0),
                            Row(
                              children: <Widget>[
                                Text(
                                    (product.regularPrice != null &&
                                            product.regularPrice.isNotEmpty)
                                        ? formatter
                                            .format(double.parse(product.regularPrice))
                                        : '',
                                    style: TextStyle(
                                      color: Theme.of(context).hintColor,
                                      decoration: onSale
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      fontWeight: onSale
                                          ? FontWeight.w300
                                          : FontWeight.w600,
                                      fontSize: onSale ? 11 : 16,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        RatingBar.builder(
                          initialRating: double.parse(product.averageRating),
                          itemSize: 15,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
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
                        product.averageRating != '0.00'
                            ? Row(
                                children: <Widget>[
                                  SizedBox(width: 4.0),
                                  Text(
                                      '(' +
                                          product.ratingCount.toString() +
                                          ')',
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.4),
                                        fontSize: 12,
                                      )),
                                ],
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
