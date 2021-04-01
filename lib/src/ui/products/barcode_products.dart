import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../blocs/product_detail_bloc.dart';
import '../../models/product_model.dart';
import '../../ui/products/product_detail/product_detail.dart';

class FindBarCodeProduct extends StatefulWidget {
  const FindBarCodeProduct({
    Key key,
    @required this.result,
    @required this.context,
  }) : super(key: key);

  final String result;
  final BuildContext context;

  @override
  _FindBarCodeProductState createState() => _FindBarCodeProductState();
}

class _FindBarCodeProductState extends State<FindBarCodeProduct> {
  bool loading = false;
  Product product = Product();
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();

  @override
  void initState() {
    _getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (product.name != null) {
      return AlertDialog(
        content: ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            width: 60,
            height: 60,
            child: CachedNetworkImage(
              imageUrl: product.images[0].src,
              imageBuilder: (context, imageProvider) => Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Ink.image(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return ProductDetail(product: product);
                      }));
                    },
                  ),
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              placeholder: (context, url) => Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.black12,
              ),
            ),
          ),
          title: Text(product.name),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
            //color: const Color(0xFF1BC0C5),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProductDetail(product: product);
              }));
            },
            child: Text("VIEW"),
            //color: const Color(0xFF1BC0C5),
          ),
        ],
      );
    } else {
      return AlertDialog(
        content: loading
            ? Container(
            height: 100, child: Center(child: CircularProgressIndicator()))
            : Text('Product not found!'),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("CANCEL"),
            //color: const Color(0xFF1BC0C5),
          ),
        ],
      );
    }
  }

  _getProduct() async {
    setState(() {
      loading = true;
    });
    Product newProduct =
    await productDetailBloc.getProductBySKU(widget.result);
    if (newProduct.name != null) {
      setState(() {
        product = newProduct;
      });
    }
    setState(() {
      loading = false;
    });
  }
}
