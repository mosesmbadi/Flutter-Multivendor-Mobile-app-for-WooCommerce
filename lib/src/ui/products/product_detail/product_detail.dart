import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/product_model.dart';
import './../../../models/app_state_model.dart';
import 'product_detail1.dart';
import 'product_detail2.dart';
import 'product_detail3.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    Key key,
    @required this.product,
  }) : super(key: key);
  final Product product;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          print(model.blocks.pageLayout.product);
      if (model.blocks.pageLayout.product == 'layout1') {
        return ProductDetail1(product: widget.product);
      } else if (model.blocks.pageLayout.product == 'layout2') {
        return ProductDetail2(product: widget.product);
      } else if (model.blocks.pageLayout.product == 'layout3') {
        return ProductDetail3(product: widget.product);
      } else {
        return ProductDetail2(product: widget.product);
      }
    });
  }
}
