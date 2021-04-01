import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import '../variation_products/vatiation_product_list.dart';
import 'edit_product.dart';

double expandedAppBarHeight = 350;

class VendorProductDetail extends StatefulWidget {
  final vendorBloc = VendorBloc();
  final VendorProduct product;

  VendorProductDetail({
    Key key,
    this.product,
  }) : super(key: key);
  @override
  _VendorProductDetailState createState() =>
      _VendorProductDetailState(product);
}

class _VendorProductDetailState extends State<VendorProductDetail> {
  AppStateModel appStateModel = AppStateModel();

  final VendorProduct products;

  _VendorProductDetailState(this.products);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(appStateModel.blocks.localeText.product),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  widget.vendorBloc.deleteProduct(products);
                }),
          ],
          //  title: Text(widget.products.name),
        ),
        body: buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditVendorProduct(
                vendorBloc: widget.vendorBloc,
                product: widget.product,
              )),
        ),
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget buildList() {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      children: ListTile.divideTiles(
        context: context,
        tiles: [
          ListTile(
              //title: Text(appStateModel.blocks.localeText.images),
              subtitle: GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.images.length + 1,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4),
                  itemBuilder: (BuildContext context, int index) {
                    if (products.images.length != index) {
                      return Card(
                          clipBehavior: Clip.antiAlias,
                          
                          margin: EdgeInsets.all(4.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Image.network(products.images[index].src,
                              fit: BoxFit.cover));
                    } else {
                      return Container();
                    }
                  })),
          ListTile(
            title: Text("id"),
            subtitle: Text(products.id.toString()),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.name),
            subtitle: Text(products.name),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.regularPrice),
            subtitle: Text(products.regularPrice),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.salesPrice),
            subtitle: Text(products.salePrice),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.status),
            subtitle: Text(products.status),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.sku),
            subtitle: Text(products.sku),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.type),
            subtitle: Text(products.type),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.description),
            subtitle: Html(data: products.shortDescription),
          ),
          ListTile(
            title: Text(appStateModel.blocks.localeText.description + ' ' + appStateModel.blocks.localeText.description),
            subtitle: Html(data: products.description),
          ),
          widget.product.type == "variable"
              ? ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(appStateModel.blocks.localeText.variations),
                  trailing: Icon(CupertinoIcons.forward),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VariationProductList(
                          vendorBloc: widget.vendorBloc,
                          product: widget.product,
                        ),
                      ),
                    );
                  })
              : Container(),
        ],
      ).toList(),
    );
  }
}
