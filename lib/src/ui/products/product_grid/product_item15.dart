import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../functions.dart';
import '../../../models/product_model.dart';
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
      padding: const EdgeInsets.all(10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.5,
          crossAxisCount: crossAxisCount,
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
  double soldWidth = 0;

  ProductItem({
    Key key,
    this.product,
    this.onProductClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double detailsWidth = MediaQuery.of(context).size.width - 160;

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

    soldWidth = (product.totalSales * 100) / 10;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child:Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            onProductClick(product);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                //color: Colors.black,
                width: 140,
                height: 140,
                //margin: EdgeInsets.fromLTRB(6, 8, 2, 8),
                //color: Colors.red,
                //padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
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
                                image: imageProvider,
                                fit: BoxFit.cover),
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
                    percentOff != 1 ? Positioned(
                      left: 0.0,
                      top: 0.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topRight: Radius.circular(12.0), bottomLeft: Radius.circular(12.0)),
                        ),
                        elevation: 0.0,
                        margin: EdgeInsets.all(0.0),
                        color: Theme.of(context).accentColor,
                        child: percentOff != 0 ? Center(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                            child: Text(percentOff.toString() + '% OFF', style: Theme.of(context).accentTextTheme.bodyText1.copyWith(
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
                padding: EdgeInsets.all(8),
                width: MediaQuery.of(context).size.width - 185,
                height: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Text(product.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.0)),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(parseHtmlString(product.shortDescription),
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).hintColor.withOpacity(0.6),
                              letterSpacing: 0.0,
                              fontSize: 14,
                            )),
                        SizedBox(
                          height: 8.0,
                        ),

                        Row(
                          children: <Widget>[
                            Text(onSale ? parseHtmlString(product.formattedSalesPrice)
                                : '', style: Theme.of(context).textTheme.body1.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                            )),
                            SizedBox(
                              width: 4.0,
                            ),
                            Text((product.formattedPrice !=
                                null && product.formattedPrice.isNotEmpty)
                                ? parseHtmlString(product.formattedPrice)
                                : '', style: TextStyle(
                              fontWeight: onSale ? FontWeight.w200 : FontWeight.w600 ,
                              fontSize: onSale ? 12 : 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
                              decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 2.0,
                        ),
                      ],
                    ),
                    product.totalSales != 0 ? Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Card(
                                color: Colors.red.withOpacity(.2),
                                elevation: 0,
                                clipBehavior: Clip.antiAlias,
                                margin: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Container(
                                  height: 15,
                                  padding: EdgeInsets.all(4),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                child: Card(
                                  color: Colors.red,
                                  elevation: 0,
                                  clipBehavior: Clip.antiAlias,
                                  margin: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Container(
                                    width: soldWidth,
                                    constraints: BoxConstraints(maxWidth: 150),
                                    height: 15,
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                top: 1,
                                child: Center(
                                  child: Container(
                                    width: 100,
                                    height: 15,
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(product.totalSales.toString() + ' Sold',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                            Theme.of(context).cardColor,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ) : Container()
                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
  }
}