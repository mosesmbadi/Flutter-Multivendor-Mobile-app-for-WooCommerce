import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/app_state_model.dart';
import '../../../models/product_model.dart';
import '../../../ui/products/product_detail/product_detail.dart';
import '../../../ui/products/product_grid/products_widgets/add_to_cart_new.dart';
import '../../../ui/products/product_grid/products_widgets/price_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  const ProductGrid({Key key, this.products}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return ProductItem(product: widget.products[index]);
        },
        childCount: widget.products.length,
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {

    int percentOff = 0;

    double save = 0;

    if ((product.salePrice != null && product.salePrice != 0)) {
      percentOff = (((product.regularPrice - product.salePrice) / product.regularPrice) * 100).round();
      save = product.regularPrice - product.salePrice;
    }
    bool onSale = false;

    if(product.salePrice != 0) {
      onSale = true;
    }

    return Column(
      children: [
        InkWell(
          splashColor: Theme.of(context).accentColor.withOpacity(0.1),
          onTap: () {
            onProductClick(context, product);
          },
          child: Container(
            //color: Colors.redAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    child: CachedNetworkImage(
                      imageUrl: product.images[0].src,
                      imageBuilder: (context, imageProvider) => Card(
                        elevation: 0.0,
                        margin: EdgeInsets.all(0.0),
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.black12,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 0, 8, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Container(child: PriceWidget(onSale: onSale, product: product)),
                            SizedBox(height: 8),
                            save != 0 ? Text('You Save Rs. ' + save.toString(), style: TextStyle(
                                color: Color(0xff00a100)
                            ),) : Container(),
                            ScopedModelDescendant<AppStateModel>(
                                builder: (context, child, model) {
                                  return AddToCart(
                                    model: model,
                                    product: product,
                                  );
                                })
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        Divider()
      ],
    );
  }

  onProductClick(BuildContext context, Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }
}
