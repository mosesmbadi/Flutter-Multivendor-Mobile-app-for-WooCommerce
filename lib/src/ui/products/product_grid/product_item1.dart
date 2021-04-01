import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/products/product_detail/product_detail.dart';
import 'products_widgets/add_to_cart_new.dart';

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
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(15.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.3,
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
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;

    double detailsWidth = (screenWidth / crossAxisCount) - 160;
    if ((product.salePrice != null && product.salePrice != 0)) {
      percentOff = ((((product.regularPrice - product.salePrice) /
          product.regularPrice *
          100))
          .round());
    }
    bool onSale = false;
    if (product.regularPrice == null || product.regularPrice.isNaN) {
      product.regularPrice = product.price;
    }
    if (product.salePrice != null && product.salePrice != 0) {
      onSale = true;
    }
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.1),
      onTap: () {
        onProductClick(product);
      },
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0,3),
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.1)
              )
            ]
        ),
        padding: EdgeInsets.all(5.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              height: 150,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    child: CachedNetworkImage(
                      imageUrl: product.images[0].src,
                      imageBuilder: (context, imageProvider) => Card(
                        elevation: 0.0,
                        margin: EdgeInsets.all(0.0),
                        //clipBehavior: Clip.antiAlias,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 150,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  percentOff != 1
                      ? Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(15),
                            topLeft: Radius.circular(10)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      color: Theme.of(context).accentColor,
                      child: percentOff != 0
                          ? Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              8.0, 4.0, 8.0, 4.0),
                          child: Text(
                            '-' + percentOff.toString() + '%',
                            style: Theme.of(context)
                                .accentTextTheme
                                .bodyText2
                                .copyWith(fontSize: 12.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                          : Container(),
                    ),
                  )
                      : Container()
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(10)),
              color: Theme.of(context).brightness == Brightness.light ? Colors.white :Colors.white),
              width: detailsWidth,
              height: 150,
              child: Stack(
                overflow: Overflow.visible,
                children:  [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10, 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(product.name,
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.black,
                                fontFamily: 'Lexend_Deca',
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 0.0)),
                        SizedBox(height: 6.0),
                        Text(parseHtmlString(product.shortDescription),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Lexend_Deca',
                              fontSize: 12,
                              color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).textTheme.caption.color: Colors.grey.withOpacity(.9) ,
                            )),
                        SizedBox(height: 6.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                onSale
                                    ? parseHtmlString(
                                    product.formattedSalesPrice)
                                    : parseHtmlString(product.formattedPrice),
                                style:
                                Theme.of(context).textTheme.body1.copyWith(
                                  fontSize: 18,
                                    fontWeight: FontWeight.w900,

                                    color: Theme.of(context).primaryColor
                                )),
                            onSale
                                ? SizedBox(width: 6.0)
                                : SizedBox(width: 0.0),
                           Text(
                                (onSale && product.formattedPrice != null &&
                                    product.formattedPrice.isNotEmpty)
                                    ? parseHtmlString(product.formattedPrice)
                                    : '',
                                style: TextStyle(
                                  fontWeight:  FontWeight.w400,
                                  fontSize: 14 ,
                                  color: Theme.of(context).hintColor,
                                  decoration: TextDecoration.lineThrough
                                )),
                          ],
                        ),
                        /* Row(
                          children: [
                            Row(
                              children: <Widget>[
                                RatingBar(
                                  initialRating:
                                      double.parse(product.averageRating),
                                  itemSize: 10,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  ignoreGestures: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  unratedColor:
                                      Theme.of(context).hintColor.withOpacity(0.3),
                                  onRatingUpdate: (rating) {},
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
                                                color: Theme.of(context).hintColor,
                                                fontSize: 12,
                                              )),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        )*/
                      ],
                    ),
                  ),
                  Positioned(
                    bottom:10,
                    right:10,
                    child: ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                          return AddToCart(model: model,
                            product: product,
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

