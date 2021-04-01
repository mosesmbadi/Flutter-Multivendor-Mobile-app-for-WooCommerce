import 'package:flutter/material.dart';
import './../../../../models/product_model.dart';
import '../../../../functions.dart';

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
        Text(onSale && (product.formattedSalesPrice != null &&
            product.formattedSalesPrice.isNotEmpty)
            ? parseHtmlString(product.formattedSalesPrice) : '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                )),
        onSale ? SizedBox(width: 4.0) : SizedBox(width: 0.0),
        Text(
            (product.formattedPrice != null &&
                    product.formattedPrice.isNotEmpty)
                ? parseHtmlString(product.formattedPrice)
                : '',
            style: TextStyle(
              fontWeight: onSale && (product.formattedSalesPrice != null &&
                  product.formattedSalesPrice.isNotEmpty) ? FontWeight.w400 : FontWeight.w800,
              color: onSale && (product.formattedSalesPrice != null &&
                  product.formattedSalesPrice.isNotEmpty)
                  ? Theme.of(context).hintColor
                  : Theme.of(context).textTheme.bodyText1.color,
              fontSize: onSale && (product.formattedSalesPrice != null &&
                  product.formattedSalesPrice.isNotEmpty) ? 14 : 16,
              decoration:
                  onSale && (product.formattedSalesPrice != null &&
                      product.formattedSalesPrice.isNotEmpty) ? TextDecoration.lineThrough : TextDecoration.none,
            )),
      ],
    );
  }
}
