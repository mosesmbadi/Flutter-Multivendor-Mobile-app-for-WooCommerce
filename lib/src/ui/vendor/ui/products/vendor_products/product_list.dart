import 'package:flutter/material.dart';

import './products_grid/product_item.dart';
import '../../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/vendor/vendor_product_model.dart';
import 'add_product.dart';

class VendorProductList extends StatefulWidget {
  final vendorBloc = VendorBloc();
  final vendorId;
  VendorProductList({Key key, this.vendorId}) : super(key: key);
  @override
  _VendorProductListState createState() => _VendorProductListState();
}

class _VendorProductListState extends State<VendorProductList> {
  ScrollController _scrollController = new ScrollController();
  bool hasMoreProducts = true;
  AppStateModel appStateModel = AppStateModel();

  @override
  void initState() {
    super.initState();
    widget.vendorBloc.productFilter['vendor'] = widget.vendorId;
    widget.vendorBloc.fetchAllProducts();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMoreProducts) {
        hasMoreProducts = await widget.vendorBloc.loadMoreProducts();

        if (!hasMoreProducts) {
          setState(() {
            hasMoreProducts;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      appBar: AppBar(title: Text(appStateModel.blocks.localeText.products), actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            semanticLabel: 'add',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddVendorProduct(vendorBloc: widget.vendorBloc)),
            );
          },
        ),
      ]),
      body: StreamBuilder(
          stream: widget.vendorBloc.allVendorProducts,
          builder: (context, AsyncSnapshot<List<VendorProduct>> snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: buildLisOfBlocks(snapshot),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<List<VendorProduct>> snapshot) {
    List<Widget> list = new List<Widget>();
    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data));
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: hasMoreProducts
                    ? Center(child: CircularProgressIndicator())
                    : Container())
          ]))));
    }

    return list;
  }
}
