import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/accounts/login/login.dart';
import '../../../ui/products/product_detail/product_detail.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  const ProductGrid({Key key, this.products}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(5.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 0.65,
          crossAxisCount: MediaQuery.of(context).size.width ~/ 150,
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

  const ProductItem({
    Key key,
    this.product,
    this.onProductClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    int percentOff = 0;

    if ((product.salePrice != null && product.salePrice != 0)) {
      percentOff = (((product.regularPrice - product.salePrice / product.regularPrice)).round());
    }
    bool onSale = false;
    if(product.regularPrice == null || product.regularPrice.isNaN) {
      product.regularPrice = product.price;
    }

    if(product.salePrice != null && product.salePrice != 0) {
      onSale = true;
    }

    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            onProductClick(product);
          },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 180,
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: product.images[0].src,
                        imageBuilder: (context, imageProvider) => Ink.image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        errorWidget: (context, url, error) => Container(color: Theme.of(context).colorScheme.background),
                      ),
                      ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                        return Positioned(
                          top: 0.0,
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
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(6.0, 10, 6, 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                            fontSize: 12,
                          color: Theme.of(context).textTheme.caption.color
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                       // textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(onSale ? parseHtmlString(product.formattedSalesPrice)
                              : '', style: Theme.of(context).textTheme.body1.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          )),
                          onSale ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
                          Text((product.formattedPrice !=
                              null && product.formattedPrice.isNotEmpty)
                              ? parseHtmlString(product.formattedPrice)
                              : '', style: TextStyle(
                            fontWeight: onSale ? FontWeight.w200 : FontWeight.w600,
                            fontSize: onSale ? 10 : 14,
                            decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
                          )),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RatingBar.builder(
                            initialRating: double.parse(product.averageRating),
                            itemSize: 12,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                            unratedColor: Theme.of(context).hintColor.withOpacity(0.4),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              
                            },
                          ),
                          product.averageRating != '0.00' ? Row(
                            children: <Widget>[
                              SizedBox(width: 4.0),
                              Text('(' + product.ratingCount.toString() + ')',
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Theme.of(context).hintColor.withOpacity(0.8),
                                    fontSize: 12,
                                  )),
                            ],
                          ): Container(),
                        ],
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