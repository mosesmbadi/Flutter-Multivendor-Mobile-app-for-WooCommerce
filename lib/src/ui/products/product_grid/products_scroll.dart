import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../layout/text_scale.dart';
import './../../../ui/products/product_grid/product_item.dart';
import './../product_detail/product_detail.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/accounts/login/login.dart';
import '../products.dart';

double desktopCategoryMenuPageWidth({
  BuildContext context,
}) {
  return 232 * reducedTextScale(context);
}

class ProductScroll extends StatelessWidget {
  const ProductScroll({
    Key key,
    @required this.products,
    @required this.context,
    @required this.title,
    this.viewAllTitle,
    this.filter,
  }) : super(key: key);

  final List<Product> products;
  final BuildContext context;
  final String title;
  final String viewAllTitle;
  final Map<String, dynamic> filter;

  @override
  Widget build(BuildContext context) {
    if (products.length > 0) {
      return Container(
        child: SliverList(
          delegate: SliverChildListDelegate(
            [
              products.length != null
                  ? Container(
                decoration: new BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                ),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                        margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                        child: Text(title,
                            style: Theme.of(context).textTheme.headline6)),
                        viewAllTitle != null ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsWidget(
                                            filter: filter,
                                            name: title)));
                              },
                              child: Text(viewAllTitle,
                                  style: Theme.of(context).textTheme.bodyText2),
                            )) : Container(),
                      ],
                    ),
                  )
                  : Container(),
              Container(
                  height: 270,
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                  decoration: new BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
                  ),
                  child: ListView.builder(
                      padding: EdgeInsets.all(12.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            width: 170,
                            child: ProductScrollItem(
                                product: products[index]));
                      })),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: SliverToBoxAdapter(),
      );
    }
  }
}

class ProductScrollItem extends StatefulWidget {

  final Product product;

  ProductScrollItem({
    Key key,
    this.product,
  }) : super(key: key);

  @override
  _ProductScrollItemState createState() => _ProductScrollItemState();
}

class _ProductScrollItemState extends State<ProductScrollItem> {
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
         //color: Colors.red,
         elevation: 0,
         shape: RoundedRectangleBorder(
           borderRadius: const BorderRadius.all(
             Radius.circular(4.0),
           ),
         ),
         clipBehavior: Clip.antiAlias,
         child: InkWell(
           splashColor: Theme.of(context).splashColor.withOpacity(0.1),
           onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) {
               return ProductDetail(product: widget.product);
             }));
           },
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
               Container(
                 height: 160,
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
                           color: Theme.of(context).textTheme.bodyText2.color.withOpacity(0.6)
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
}