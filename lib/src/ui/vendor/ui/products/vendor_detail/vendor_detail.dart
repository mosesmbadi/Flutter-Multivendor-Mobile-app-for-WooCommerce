import 'dart:async';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import './../../../../vendor/ui/products/vendor_detail/vendor_contacts1.dart';
import './../../../../vendor/ui/products/vendor_detail/vendor_home.dart';
import '../../../../../blocs/vendor/vendor_detail_state_model.dart';
import '../../../../../blocs/vendor/vendor_products_bloc.dart';
import '../../../../../chat/pages/chat_page.dart';
import '../../../../../models/app_state_model.dart';
import '../../../../../models/product_model.dart';
import '../../../../../resources/api_provider.dart';
import '../../../../../ui/accounts/login/login.dart';
import '../../../../../ui/products/product_grid/product_item4.dart';
import '../../../../../ui/widgets/MD5Indicator.dart';
import 'search.dart';
import 'vendor_reviews.dart';

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
  TabController _tabController;

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
      widget.vendorDetailModel.filter['wcpv_product_vendors'] = widget.vendorId.toString();
    } else {
      widget.vendorProductsBloc.filter['vendor'] = widget.vendorId.toString();
      widget.vendorDetailModel.filter['vendor'] = widget.vendorId.toString();
    }
    apiProvider.filter['vendor'] = widget.vendorId.toString();
    widget.vendorDetailModel.getDetails();
    widget.vendorProductsBloc.fetchAllProducts();
    widget.vendorDetailModel.getReviews();

    _tabController = TabController(vsync: this, length: 4);
    _isVisible = true;

    _tabController.addListener(_handleTabSelection);

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

  void _handleTabSelection() {
    //_allProductsScrollController.jumpTo(0.0);
    //_reviewScrollController.jumpTo(0.0);
    //_homeScrollController.jumpTo(0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      body: ScopedModel<VendorDetailStateModel>(
        model: widget.vendorDetailModel,
        child: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: NestedScrollView(
                //controller: _hideButtonController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                      expandedHeight: 140.0,
                      pinned: true,
                      floating: false,
                      //snap: true,
                      titleSpacing: 5,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20.0),
                            child: Padding(
                              padding: EdgeInsets.only(top: 65),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                height: 60,
                                child: ScopedModelDescendant<
                                        VendorDetailStateModel>(
                                    builder: (context, child, model) {
                                  return model.vendorDetails != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                CircleAvatar(
                                                  radius: 20.0,
                                                  backgroundImage:
                                                      NetworkImage(model
                                                          .vendorDetails
                                                          .store
                                                          .icon),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.8,
                                                  child: Text(
                                                      model.vendorDetails
                                                          .store.name,
                                                      maxLines: 1,
                                                      style: Theme.of(context)
                                                          .primaryTextTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            fontFamily:
                                                                'Lexend_Deca',
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900,
                                                          )),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                model.vendorDetails.store
                                                            .productsCount !=
                                                        0
                                                    ? Text(
                                                        model
                                                                .vendorDetails
                                                                .store
                                                                .productsCount
                                                                .toString() +
                                                            ' ' +
                                                            appStateModel
                                                                .blocks
                                                                .localeText
                                                                .products,
                                                        style: Theme.of(
                                                                context)
                                                            .primaryTextTheme
                                                            .bodyText1
                                                            .copyWith(
                                                              fontFamily:
                                                                  'Lexend_Deca',
                                                              fontSize: 12,
                                                              //color: Colors.grey,
                                                            ))
                                                    : Container()
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container();
                                }),
                              ),
                            ),
                          ),
                        ),
                      ),
                      title: buildStoreTitle(context),
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(90),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            isScrollable: true,
                            controller: _tabController,
                            indicator: MD2Indicator(
                                //it begins here
                                indicatorHeight: 5,
                                indicatorColor: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .color, //Theme.of(context).primaryColor,//Colors.white,//Theme.of(context).primaryColor,
                                indicatorSize: MD2IndicatorSize
                                    .full //3 different modes tiny-normal-full
                                ),
                            tabs: <Widget>[
                              Tab(
                                child: Text(
                                    appStateModel.blocks.localeText.home),
                              ),
                              Tab(
                                child: Text(
                                    appStateModel.blocks.localeText.products),
                              ),
                              Tab(
                                child: Text(
                                    appStateModel.blocks.localeText.reviews),
                              ),
                              Tab(
                                child: Text(
                                    appStateModel.blocks.localeText.contacts),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    VendorHome(
                        homeScrollController: _homeScrollController,
                        vendorDetailsModel: widget.vendorDetailModel),
                    StreamBuilder(
                        stream: widget.vendorProductsBloc.allProducts,
                        builder:
                            (context, AsyncSnapshot<List<Product>> snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Color(0xFFf2f3f7)
                                  : Colors.black,
                              child: CustomScrollView(
                                controller: _allProductsScrollController,
                                slivers: buildLisOfBlocks(snapshot),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          } else
                            return Center(child: CircularProgressIndicator());
                        }),

                    //Reviews

                    VendorReviewsList(vendorDetailModel: widget.vendorDetailModel),

                    ScopedModelDescendant<VendorDetailStateModel>(
                        builder: (context, child, model) {
                      return model.vendorDetails != null
                          ? CustomScrollView(
                              controller: _vendorDetailScrollController,
                              slivers: [
                                SliverToBoxAdapter(
                                  child: VendorContacts1(
                                      vendorDetailsBloc:
                                          widget.vendorDetailModel,
                                      store: model.vendorDetails.store),
                                )
                              ],
                            )
                          : CustomScrollView(
                              controller: _vendorDetailScrollController,
                              slivers: [
                                  SliverToBoxAdapter(
                                    child: Container(height: 750),
                                  ),
                                ]);
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              child: ScopedModelDescendant<VendorDetailStateModel>(
                  builder: (context, child, model) {
                if (model.vendorDetails?.store?.phone != null)
                  return FabCircularMenu(
                    fabOpenColor:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                    fabCloseColor:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                    fabOpenIcon: Icon(
                      Icons.chat_bubble,
                      color:
                          Theme.of(context).buttonTheme.colorScheme.onPrimary,
                    ),
                    fabCloseIcon: Icon(
                      Icons.close,
                      color:
                          Theme.of(context).buttonTheme.colorScheme.onPrimary,
                    ),
                    child: Container(),
                    ringColor:
                        Theme.of(context).buttonTheme.colorScheme.primary,
                    ringDiameter: 250.0,
                    ringWidth: 100.0,
                    options: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.chat_bubble,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary,
                          ),
                          onPressed: () {
                            if (appStateModel.user?.id != null &&
                                appStateModel.user.id > 0)
                            _chatWithVendor(appStateModel.user.id.toString() + model.vendorDetails.store.id.toString(), model.vendorDetails.store.id.toString(), model.vendorDetails.store.name, model.vendorDetails.store.icon);
                            else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                      model.vendorDetails?.store?.email != null
                          ? IconButton(
                              icon: Icon(
                                Icons.mail,
                                color: Theme.of(context)
                                    .buttonTheme
                                    .colorScheme
                                    .onPrimary,
                              ),
                              onPressed: () {
                                openLink(model.vendorDetails.store.email);
                              },
                              iconSize: 20.0,
                              color: Colors.black)
                          : null,
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary,
                          ),
                          onPressed: () {
                            final url = 'https://wa.me/' +
                                model.vendorDetails.store.phone;
                            openLink(url);
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                      IconButton(
                          icon: Icon(
                            Icons.message,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary,
                          ),
                          onPressed: () {
                            openLink(
                                'sms:' + model.vendorDetails.store.phone);
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                      IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme
                                .onPrimary,
                          ),
                          onPressed: () {
                            openLink(
                                'tel:' + model.vendorDetails.store.phone);
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                    ],
                  );
                else
                  return Container();
              }),
            )
          ],
        ),
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

  _chatWithVendor(String chatId, String id, String name, String icon,) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChatPage(
          chatId: chatId, vendorId: id, vendorName: name, vendorAvatar: icon
      );
    }));
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
