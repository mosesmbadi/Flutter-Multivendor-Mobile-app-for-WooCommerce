import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './../../../models/app_state_model.dart';
import './../../../models/cart/cart_model.dart';
import './../../../ui/products/product_detail/product_detail.dart';
import '../../../functions.dart';
import '../../../models/product_model.dart';



const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class ProductGrid extends StatefulWidget {

  final List<Product> products;
  final appStateModel = AppStateModel();
  ProductGrid({
    Key key,
    this.products,
  }) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  void initState() {
    super.initState();
    widget.appStateModel.getCart();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(_scaffoldPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2/0.75,
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

class ProductItem extends StatefulWidget {
  final Product product;
  final void Function(Product category) onProductClick;
  final CartContent cartContent;

  ProductItem({
    Key key,
    this.product,
    this.onProductClick,
    this.cartContent,
  }) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  int percentOff = 0;

  final appStateModel = AppStateModel();

  var addingToCart = false;

  var loading = false;

  @override
  Widget build(BuildContext context) {
/*    var price = [45.0,23.0,51.0,20.0,33.0,35.0,35.0,43.0,11.0];
    var regularPrice = [45.0,23.0,51.0,20.0,33.0,35.0,35.0,43.0,11.0];
    var salesPrice = [35.0,13.0,41.0,18.0,28.0,25.0,26.0,39.0,9.0];

    var formattedPrice = ['&#36;45.00','&#36;23.00','&#36;51.00','&#36;20.00','&#36;33.00','&#36;35.00',];
    var formattedSalesPrice = ['&#36;35.00','&#36;13.00','&#36;41.00','&#36;18.00','&#36;28.00','&#36;25.00',];

    var index = [0,1,2,3,4,5];
    int i = (index..shuffle()).first;
    product.price = price[i];
    product.regularPrice = regularPrice[i];
    product.salePrice = salesPrice[i];


    product.formattedPrice = formattedPrice[i];
    product.formattedSalesPrice = formattedSalesPrice[i];

    var list = ['4.5','4.0','5.0','2.0','4.0','3.0'];
    product.averageRating = (list..shuffle()).first;

    var count = [45,23,51,20,33,35,35,43,11];
    product.ratingCount = (count..shuffle()).first;*/
    final screenheight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;

    double detailsWidth = (screenWidth / crossAxisCount) - 150;

    if ((widget.product.salePrice != null && widget.product.salePrice != 0)) {
      percentOff = ((((widget.product.regularPrice - widget.product.salePrice) /
          widget.product.regularPrice *
          100))
          .round());
    }
    bool onSale = false;
    if (widget.product.regularPrice == null ||
        widget.product.regularPrice.isNaN) {
      widget.product.regularPrice = widget.product.price;
    }
    if (widget.product.salePrice != null && widget.product.salePrice != 0) {
      onSale = true;
    }

    return Container(
      decoration: BoxDecoration(
        /* borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),*/
        //color: Colors.pink[100],
          border:Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          )
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        splashColor: Theme.of(context).accentColor.withOpacity(0.1),
        onTap: () {
          widget.onProductClick(widget.product);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: screenWidth / 5,
              height: 80,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: widget.product.images[0].src,
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
            Expanded(
              child: Center(
                child: Container(
                  width: detailsWidth * 1.4,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16, 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                onSale?
                                Padding(
                                  padding:
                                  EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                  child: Container(
                                    decoration: new BoxDecoration(
                                      color: Colors.indigo[900],
                                      border: new Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius:
                                      new BorderRadius.circular(10.0),
                                    ),
                                    child: Text(
                                        onSale
                                            ? parseHtmlString(widget
                                            .product.formattedSalesPrice)
                                            : '',
                                        style: TextStyle(
                                          color: Colors.white,
                                          /*color: Theme.of(context)
                                              .hoverColor
                                              .withOpacity(0.7),*/
                                          fontWeight: FontWeight.w600,
                                          fontSize: 22,
                                        )),
                                  ),
                                ):Container(),
                                onSale
                                    ? SizedBox(width: 8.0)
                                    : SizedBox(width: 0.0),
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Container(
                                        decoration: new BoxDecoration(
                                          color: Colors.teal[400],
                                          border: new Border.all(
                                              color: Colors.white, width: 2.0),
                                          borderRadius:
                                          new BorderRadius.circular(10.0),
                                        ),
                                        child: Text(
                                            (widget.product.formattedPrice !=
                                                null &&
                                                widget
                                                    .product
                                                    .formattedPrice
                                                    .isNotEmpty)
                                                ? parseHtmlString(widget
                                                .product.formattedPrice)
                                                : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              /*color: Theme.of(context)
                                                  .hoverColor
                                                  .withOpacity(0.7),*/
                                              decoration: onSale
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              fontWeight: onSale
                                                  ? FontWeight.w300
                                                  : FontWeight.w600,
                                              fontSize: onSale ? 17 : 22,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(widget.product.name,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    letterSpacing: 0.0)),
                            SizedBox(height: 5.0),
                            Text(
                                parseHtmlString(
                                    widget.product.shortDescription),
                                maxLines: 2,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .hintColor
                                      .withOpacity(0.8),
                                  letterSpacing: 0.0,
                                  fontSize: 10,
                                )),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(iconSize:30,
                                    icon: const Icon(Icons.add_circle_outline,
                                    ),
                                    onPressed: () => addToCart(widget.product, context)),
                                SizedBox(width: 5.0),
                                Center(
                                  child: ScopedModelDescendant<AppStateModel>(
                                      builder: (context, child, model) {
                                        if (loading == true) {
                                          return Container(
                                              width: 25,
                                              height: 25,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                              ));
                                        } else if (model
                                            .shoppingCart?.cartContents !=
                                            null &&
                                            model.shoppingCart.cartContents.any(
                                                    (cartContent) =>
                                                cartContent.productId ==
                                                    widget.product.id)) {
                                          final cartContent = appStateModel
                                              .shoppingCart.cartContents
                                              .singleWhere((cartContent) =>
                                          cartContent.productId ==
                                              widget.product.id);

                                          return Text(
                                            cartContent.quantity.toString(),
                                            style: TextStyle(
                                                fontSize: 25.0
                                            ),);
                                        }
                                        return Text('0',
                                          style: TextStyle(
                                              fontSize: 25.0
                                          ),);
                                      }),
                                ),
                                SizedBox(width: 5.0),
                                IconButton(iconSize:30,
                                  icon: const Icon(Icons.remove_circle_outline,),
                                  onPressed: () =>
                                      removeFromCart(widget.product),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addToCart(Product product, BuildContext context) async {
    var data = new Map<String, dynamic>();
    data['product_id'] = product.id.toString();
    data['quantity'] = '1';
    setState(() {
      loading = true;
    });
    await appStateModel.addToCart(data);
    setState(() {
      loading = false;
    });
  }

  removeFromCart(Product product) async {
    if (appStateModel.shoppingCart?.cartContents != null) {
      if (appStateModel.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == product.id)) {
        final cartContent = appStateModel.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == product.id);
        setState(() {
          loading = true;
        });
        await appStateModel.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          loading = false;
        });
      }
    }
  }
}