import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/orders_model.dart';
import '../../../../models/vendor/product_variation_model.dart';
import '../../../../models/vendor/vendor_product_model.dart';
import 'add_variations.dart';

class ProductItem extends StatefulWidget {
  final VendorBloc vendorBloc;
  final VendorProduct product;
  final Order order;
  final ProductVariation variation;
  ProductItem({Key key, this.vendorBloc, this.product, this.order,this.variation})
      : super(key: key);
  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  AppStateModel _appStateModel = AppStateModel();
  NumberFormat formatter;
  var qty = 0;

  @override
  void initState() {
    super.initState();
    widget.vendorBloc.getVariationProducts(widget.product.id);
  }

  @override
  Widget build(BuildContext context) {


    if (widget.order.lineItems != null &&
        widget.order.lineItems
            .any((lineItems) => lineItems.productId == widget.product.id)) {

      if(widget.product.type != 'variable') {
        qty = widget.order.lineItems
            .singleWhere((lineItems) => lineItems.productId == widget.product.id)
            .quantity;
      }
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            height: 130,
            child: new ListTile(
                leading: AspectRatio(
                  aspectRatio: 18.0 / 20,
                  child: Image.network(
                    widget.product.images[0].src,
                    fit: BoxFit.cover,
                  ),
                ),
                //TODO ADD Plus minus button if product is already there in order lineitems

                title: new Text(
                  widget.product.name,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        formatter.format((double.parse(widget.product.price)))),
                    qty != 0
                        ? Container(
                            // width: 200,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      //TODO for decrease qty and if qty is 0 remove line item
                                      _decreaseQty();
                                    }),
                                Text(qty.toString()),
                                IconButton(
                                    icon: Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      //TODO Containe? increase qty : Add line item
                                      _increaseQty();
                                    }),
                              ],
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    _addProduct();
                                  }),
                            ],
                          ),
                  ],
                )

                // onTap: () => openDetail(snapshot.data, index),

                ),
          ),
        ],
      ),
    );
  }

  void _addProduct() {
    if (widget.product.type == 'variable') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddVariations(
                  vendorBloc: widget.vendorBloc,
                  product: widget.product,
                 order: widget.order,
                )),
      );
    } else {
      final lineItem = LineItem();
      lineItem.productId = widget.product.id;
      lineItem.quantity = 1;
      lineItem.name = widget.product.name;
      lineItem.price = double.parse(widget.product.price);
      lineItem.total =
          (lineItem.quantity * double.parse(widget.product.price)).toString();
      setState(() {
        widget.order.lineItems.add(lineItem);
      });
    }
  }

  void _increaseQty() {
    if (widget.order.lineItems
        .any((lineItems) => lineItems.productId == widget.product.id)) {
      widget.order.lineItems
          .singleWhere((lineItems) => lineItems.productId == widget.product.id)
          .quantity++;

      widget.order.lineItems
          .singleWhere((lineItems) => lineItems.productId == widget.product.id)
          .total = (widget.order.lineItems
                  .singleWhere(
                      (lineItems) => lineItems.productId == widget.product.id)
                  .price *
              (qty + 1))
          .toString();
      setState(() {
        qty = qty + 1;
      });
    } else
      _addProduct();
    // print(qty);
  }

  void _decreaseQty() {
    if (widget.order.lineItems
        .any((lineItems) => lineItems.productId == widget.product.id)) {
      if (widget.order.lineItems
              .singleWhere(
                  (lineItems) => lineItems.productId == widget.product.id)
              .quantity ==
          0) {
        widget.order.lineItems.removeWhere(
            (lineItems) => lineItems.productId == widget.product.id);
        setState(() {
          qty = 0;
        });
      } else {
        widget.order.lineItems
            .singleWhere(
                (lineItems) => lineItems.productId == widget.product.id)
            .quantity--;
        widget.order.lineItems
            .singleWhere(
                (lineItems) => lineItems.productId == widget.product.id)
            .total = (widget.order.lineItems
                    .singleWhere(
                        (lineItems) => lineItems.productId == widget.product.id)
                    .price *
                (qty - 1))
            .toString();
        setState(() {
          qty = qty - 1;
        });
      }
    }
  }
}
