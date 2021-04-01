import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import './../../../../vendor/ui/products/vendor_detail/vendor_detail_home.dart';
import '../../../../../blocs/vendor/vendor_detail_state_model.dart';
import '../../../../../blocs/vendor/vendor_products_bloc.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/product_model.dart';
import '../../../../../resources/api_provider.dart';
import '../../../../../ui/products/product_grid/product_item4.dart';
import 'search.dart';

class VendorDetails extends StatefulWidget {
  final vendorProductsBloc = VendorProductsBloc();
  final VendorDetailStateModel vendorDetailModel = VendorDetailStateModel();
  final vendorId;

  VendorDetails({Key key, this.vendorId}) : super(key: key);

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails>
    with SingleTickerProviderStateMixin {
  var theme = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17];

  final textStyle = TextStyle(
      fontFamily: 'Lexend_Deca', fontSize: 16, fontWeight: FontWeight.w400);
  var _isVisible;
 // TabController _tabController;

  ScrollController _homeScrollController = new ScrollController();
  ScrollController _allProductsScrollController = new ScrollController();
  ScrollController _vendorDetailScrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  final apiProvider = ApiProvider();

  @override
  initState() {
    super.initState();
    widget.vendorDetailModel.filter['random'] = 'rand';
    if (appStateModel.blocks.vendorType == 'product_vendor') {
      widget.vendorProductsBloc.filter['wcpv_product_vendors'] =
          widget.vendorId;
      widget.vendorDetailModel.filter['wcpv_product_vendors'] = widget.vendorId;
    } else {
      widget.vendorProductsBloc.filter['vendor'] = widget.vendorId;
      widget.vendorDetailModel.filter['vendor'] = widget.vendorId;
    }
    apiProvider.filter['vendor'] = widget.vendorId;
    widget.vendorDetailModel.getDetails();
    widget.vendorProductsBloc.fetchAllProducts();
    widget.vendorDetailModel.getReviews();


    _isVisible = true;



    _allProductsScrollController.addListener(() async {
      if (_allProductsScrollController.position.pixels ==
          _allProductsScrollController.position.maxScrollExtent) {
        widget.vendorProductsBloc.loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    apiProvider.filter.removeWhere((key, value) => key == 'vendor');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      body: ScopedModel<VendorDetailStateModel>(
        model: widget.vendorDetailModel,
        child: VendorHome(
            homeScrollController: _homeScrollController,
            vendorDetailsModel: widget.vendorDetailModel),
      ),
    );
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = new List<Widget>();

    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data));
      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                widget.vendorProductsBloc.hasMoreItems
                    ? Container(
                    height: 60,
                    child: Center(child: CircularProgressIndicator()))
                    : Container()
              ]))));
    }

    return list;
  }

  Future openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Row buildStoreTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 55,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              enableFeedback: false,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Search(vendorId: widget.vendorId);
                }));
              },
              child: TextField(
                showCursor: false,
                enabled: false,
                decoration: InputDecoration(
                  hintText: appStateModel.blocks.localeText.searchProducts,
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Circular',
                  ),
                  //fillColor: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).inputDecorationTheme.fillColor : Colors.white,
                  filled: true,
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(
                      color: Theme.of(context).focusColor,
                      width: 0,
                    ),
                  ),
                  contentPadding: EdgeInsets.all(6),
                  prefixIcon: Icon(
                    FontAwesomeIcons.search,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
