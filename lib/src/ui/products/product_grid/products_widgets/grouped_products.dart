import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import './../../../../models/app_state_model.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';


class GroupedProduct extends StatefulWidget {

  GroupedProduct({
    Key key,
    @required this.id,
    @required this.product,
  }) : super(key: key);

  final int id;
  final Product product;
  final model = AppStateModel();

  @override
  _GroupedProductState createState() => _GroupedProductState();
}

class _GroupedProductState extends State<GroupedProduct> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon(),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.product.name),
          SizedBox(height: 4),
          _variationPrice()
        ],
      ),
      trailing: (getQty() != 0 || isLoading) ? SizedBox(
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.add_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
              //tooltip: 'Increase quantity by 1',
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
              child: Text(getQty().toString(), textAlign: TextAlign.center,),
            ),
            IconButton(
              padding: EdgeInsets.all(0.0),
              icon: Icon(Icons.remove_circle_outline, color: Theme.of(context).textTheme.bodyText1.color.withOpacity(0.6)),
              //tooltip: 'Decrease quantity by 1',
              onPressed: () {
                decreaseQty();
              },
            ),
          ],
        ),
      ) : SizedBox(
        width: 120,
        height: 35,
        child: RaisedButton(
          elevation: 0,
          shape: StadiumBorder(),
          child: Text(widget.model.blocks.localeText.add),
          onPressed: () => addToCart(context),
        ),
      ),
    );
  }

  Container leadingIcon() {
    return Container(
      width: 30,
      height: 30,
      child: CachedNetworkImage(
        imageUrl: widget.product.images[0].src != null ? widget.product.images[0].src : '',
        imageBuilder: (context, imageProvider) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          margin: EdgeInsets.all(0.0),
          //shape: StadiumBorder(),
          child: Ink.image(
            child: InkWell(
              onTap: () {
                //onCategoryClick(category);
              },
            ),
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
        placeholder: (context, url) => Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0.0,
          //shape: StadiumBorder(),
        ),
        errorWidget: (context, url, error) => Card(
          elevation: 0.0,
          color: Colors.white,
          //shape: StadiumBorder(),
        ),
      ),
    );
  }

  addToCart(BuildContext context) async {
    var data = new Map<String, dynamic>();
    data['product_id'] = widget.id.toString();
    data['add-to-cart'] = widget.id.toString();
    data['quantity[' + widget.product.id.toString() + ']'] = '1';
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
      return widget.model.shoppingCart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  _variationPrice() {
    if(widget.product.formattedPrice != null && widget.product.formattedSalesPrice == null) {
      return Text(parseHtmlString(widget.product.formattedPrice), style: TextStyle(
        fontWeight: FontWeight.bold,
      ));
    } else if(widget.product.formattedPrice != null && widget.product.formattedSalesPrice != null) {
      return Row(
        children: [
          Text(parseHtmlString(widget.product.formattedSalesPrice), style: TextStyle(
            fontWeight: FontWeight.bold,
          )),
          SizedBox(width: 4),
          Text(parseHtmlString(widget.product.formattedPrice), style: TextStyle(
              fontSize: 10,
              decoration: TextDecoration.lineThrough
          )),
        ],
      );
    }
  }
}