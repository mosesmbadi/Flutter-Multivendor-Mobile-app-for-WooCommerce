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
          childAspectRatio: 0.60,
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

    return Container(
      color: Colors.white24,
      padding: EdgeInsets.all(0.1),
      child: Card(
        margin: EdgeInsets.all(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            onProductClick(product);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 150,
                    child: CachedNetworkImage(
                      imageUrl: product.images[0].src,
                      imageBuilder: (context, imageProvider) => Ink.image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      placeholder: (context, url) => Container(
                        color: Colors.white12,
                      ),
                      errorWidget: (context, url, error) => Container(color: Colors.black12),
                    ),
                  ),
                  ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                    return Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: IconButton(
                          icon: model.wishListIds.contains(product.id) ? Icon(Icons.favorite, color: Colors.black87) :
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
              Container(
                padding: EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      product.name,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,color: Colors.amber
                      ),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(parseHtmlString(product.shortDescription),
                        maxLines: 2,
                        style: TextStyle(
                          color: Theme.of(context).hintColor,
                          letterSpacing: 0.0,
                          fontSize: 12,
                        )),
                    SizedBox(
                      height: 6.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        onSale ? Text(
                          parseHtmlString(product.formattedSalesPrice),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ) : Container(),
                        SizedBox(
                          width: 4.0,
                        ),
                        (product.formattedPrice !=
                            null && product.formattedPrice.isNotEmpty)
                            ? Text(
                          (product.formattedPrice !=
                              null && product.formattedPrice.isNotEmpty)
                              ? parseHtmlString(product.formattedPrice)
                              : '',
                          style: TextStyle(
                              fontSize: onSale ? 12 : 16,
                              fontWeight: onSale ? FontWeight.w300 : FontWeight.w400,
                              decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
                              color: onSale ? Theme.of(context).textTheme.caption.color : Theme.of(context).colorScheme.onSurface),
                        ) : Container(),
                        percentOff != 0 ? Row(
                          children: <Widget>[
                            SizedBox(
                              width: 2.0,
                            ),
                            Text(
                              percentOff.toString() + '% OFF',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).textTheme.caption.color),
                            ),
                          ],
                        ) : Container(),
                      ],

                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RatingBar.builder(
                          itemSize: 12.0,
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {

                          },
                        ),
                        Text(
                          '(' + product.ratingCount.toString() + ')',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}