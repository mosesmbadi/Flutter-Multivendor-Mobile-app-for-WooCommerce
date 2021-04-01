import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../layout/adaptive.dart';
import './../../../layout/text_scale.dart';
import '../../../functions.dart';
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

    final containerWidth = isDesktop ? MediaQuery.of(context).size.width - desktopCategoryMenuPageWidth(context: context) : MediaQuery.of(context).size.width;

    final crossAxisCount = containerWidth ~/ (isDesktop ? 200 : 180);

    return SliverPadding(
      padding: const EdgeInsets.all(5.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.60,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return ProductItem(crossAxisCount: crossAxisCount, containerWidth: containerWidth,
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

class ProductItem extends StatefulWidget {

  final Product product;
  final crossAxisCount;
  final containerWidth;
  final void Function(Product category) onProductClick;

  ProductItem({
    Key key,
    this.product,
    this.onProductClick,
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
      percentOff = (((widget.product.regularPrice - widget.product.salePrice / widget.product.regularPrice)).round());
    }
    bool onSale = false;

    if(widget.product.salePrice != 0) {
      onSale = true;
    }

   return Container(
      child: ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
          return Card(
            margin: EdgeInsets.all(0),
            //color: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                //splashColor: Theme.of(context).splashColor.withOpacity(0.001),
                onTap: () {
                  widget.onProductClick(widget.product);
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
                                    color: Theme.of(context).splashColor,
                                  ),
                                  errorWidget: (context, url, error) => Container(color: Theme.of(context).splashColor),
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
                                  )
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
                              widget.product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle.copyWith(
                                  fontSize: 12,
                                color: Theme.of(context).textTheme.caption.color
                              ),
                            ),
                            SizedBox(height: 4.0),
                            PriceWidget(onSale: onSale, product: widget.product),
                            SizedBox(height: 8.0),
                            if(getQty(model) != 0 || isLoading)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  tooltip: 'Increase volume by 1',
                                  onPressed: () {
                                    increaseQty();
                                  },
                                ),
                                isLoading ? SizedBox(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                  height: 20.0,
                                  width: 20.0,
                                ) :  SizedBox(
                                  width: 20.0,
                                  child: Text(getQty(model).toString(), textAlign: TextAlign.center,),
                                ),
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  tooltip: 'Increase volume by 1',
                                  onPressed: () {
                                    decreaseQty();
                                  },
                                ),
                              ],
                            )
                            else RaisedButton(
                              elevation: 0,
                              shape: StadiumBorder(),
                              child: const Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Text("ADD"),
                              ),
                              onPressed: () {
                                addToCart(context);
                              },
                            ),
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

  addToCart(BuildContext context) async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.product.id.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    await appStateModel.addToCart(data);
    setState(() {
      isLoading = false;
    });
  }

  decreaseQty() async {
    if (appStateModel.shoppingCart?.cartContents != null) {
      if (appStateModel.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = appStateModel.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        await appStateModel.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    if (appStateModel.shoppingCart?.cartContents != null) {
      if (appStateModel.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = appStateModel.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        bool status = await appStateModel.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getQty(AppStateModel model) {
    if(model.shoppingCart.cartContents.any((element) => element.productId == widget.product.id)) {
      return model.shoppingCart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return 0;
  }
}

class PriceWidget extends StatelessWidget {
  const PriceWidget({
    Key key,
    @required this.onSale,
    @required this.product,
  }) : super(key: key);

  final bool onSale;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        Text(onSale ? parseHtmlString(product.formattedSalesPrice)
            : '', textAlign: TextAlign.left, style: Theme.of(context).textTheme.bodyText2.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        )),
        onSale ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
        Text((product.formattedPrice !=
            null && product.formattedPrice.isNotEmpty)
            ? parseHtmlString(product.formattedPrice)
            : '', textAlign: TextAlign.left, style: TextStyle(
          fontWeight: onSale ? FontWeight.w400 : FontWeight.w600,
          fontSize: onSale ? 12 : 14,
          decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
        )),
      ],
    );
  }
}