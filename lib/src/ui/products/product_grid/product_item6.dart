
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../functions.dart';
import '../../../layout/adaptive.dart';
import '../../../layout/text_scale.dart';
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
      padding: const EdgeInsets.all(6.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: .7,
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
         // margin: EdgeInsets.all(0),
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            splashColor: Theme.of(context).splashColor.withOpacity(0.1),
            onTap: () {
              widget.onProductClick(widget.product);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 190,
                 // height: widget.containerWidth/widget.crossAxisCount,
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: widget.product.images[0].src,
                        imageBuilder: (context, imageProvider) => Ink.image(
                          image: imageProvider,
                          fit: BoxFit.fill,
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
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8,10,8,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        //textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontFamily: 'Lexend_Deca',
                          fontSize: 14,
                          color: Colors.grey,
                        )
                        //Theme.of(context).textTheme.bodyText2,
                      ),
                      //SizedBox(height: 6.0),
                      PriceWidget(onSale: onSale, product: widget.product),
                      //SizedBox(height: 8.0),
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
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        Text(onSale ? parseHtmlString(product.formattedSalesPrice)
            : product.formattedPrice,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
          fontFamily: 'Rubik',
          //fontStyle: FontStyle.italic,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        )),
        onSale ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
        onSale ? Text((product.formattedPrice !=
            null && product.formattedPrice.isNotEmpty)
            ? Html(data: product.formattedPrice).toString()
            : '', style: TextStyle(
          fontFamily: 'Rubik',
          fontWeight: onSale ? FontWeight.w400 : FontWeight.w800,
          fontSize: onSale ? 10 : 14,
          decoration: onSale ? TextDecoration.lineThrough : TextDecoration.none,
        )):Text(''),
      ],
    );
  }
}
