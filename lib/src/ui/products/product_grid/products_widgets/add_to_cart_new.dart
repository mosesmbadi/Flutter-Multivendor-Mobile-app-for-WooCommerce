import 'package:cached_network_image/cached_network_image.dart';

import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import 'package:flutter/material.dart';


import 'grouped_products.dart';
import 'variations_products.dart';

class AddToCart extends StatefulWidget {

  AddToCart({
    Key key,
    @required this.product,
    @required this.model,
  }) : super(key: key);

  final Product product;
  final AppStateModel model;

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    if(getQty() != 0 || isLoading)
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ButtonBar(
            alignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            buttonPadding: EdgeInsets.all(0), // this will take space as minimum as posible(to center)
            children: <Widget>[
              SizedBox(
                height: 30,
                width: 30,
                child: new RaisedButton(
                  elevation: 0,
                  color: Theme.of(context).buttonColor.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                  ),
                  child: new Icon(Icons.remove),
                  onPressed: () {
                    if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                      _bottomSheet(context);
                    } else decreaseQty();
                  },
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: new FlatButton(
                  //elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                  ),
                  child: isLoading ? SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 2),
                    height: 16.0,
                    width: 16.0,
                  ) :  SizedBox(
                    width: 20.0,
                    child: Text(
                      getQty().toString(), textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 16
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              SizedBox(
                height: 30,
                width: 30,
                child: new RaisedButton(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.all(Radius.circular(15)),
                  ),
                  child: new Icon(Icons.add),
                  onPressed: () {
                    if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                      _bottomSheet(context);
                    } else increaseQty();
                  },
                ),
              ),
            ],
          ),
        ],
      );
    else return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ButtonBar(
          buttonPadding: EdgeInsets.all(0),
          children: [
            SizedBox(
              height: 30,
              width: 60,
              child: RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                ),
                child: Text(widget.model.blocks.localeText.add.toUpperCase()),
                onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
                  if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    addToCart();
                  }
                },
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: new RaisedButton(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                ),
                child: new Icon(Icons.add),
                onPressed: widget.product.stockStatus == 'outofstock' ? null : () {
                  if(widget.product.type == 'variable' || widget.product.type == 'grouped') {
                    _bottomSheet(context);
                  } else {
                    addToCart();
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  addToCart() async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.product.id.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    await widget.model.addToCart(data);
    setState(() {
      isLoading = false;
    });
  }

  decreaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        await widget.model.decreaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  increaseQty() async {
    if (widget.model.shoppingCart?.cartContents != null) {
      if (widget.model.shoppingCart.cartContents
          .any((cartContent) => cartContent.productId == widget.product.id)) {
        final cartContent = widget.model.shoppingCart.cartContents
            .singleWhere((cartContent) => cartContent.productId == widget.product.id);
        setState(() {
          isLoading = true;
        });
        bool status = await widget.model.increaseQty(cartContent.key, cartContent.quantity);
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getQty() {
    var count = 0;
    if(widget.model.shoppingCart.cartContents.any((element) => element.productId == widget.product.id)) {
      if(widget.product.type == 'variable') {
        widget.model.shoppingCart.cartContents.where((variation) => variation.productId == widget.product.id).toList().forEach((e) => {
          count = count + e.quantity
        });
        return count;
      } else return widget.model.shoppingCart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  void _bottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          //color: Colors.amber,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (widget.product.type == 'variable') Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(id: widget.product.id, variation: widget.product.availableVariations[Index]);
                      }
                  ),
                ) else widget.product.children.length > 0 ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GroupedProduct(id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
