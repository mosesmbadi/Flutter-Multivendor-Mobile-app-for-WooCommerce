import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../functions.dart';
import '../../resources/api_provider.dart';
import '../../models/post_model.dart';
import '../../ui/pages/page_detail.dart';
import '../../ui/pages/post_detail.dart';
import '../../ui/pages/webview.dart';
import '../../ui/products/product_grid/products_scroll.dart';
import '../../data/gallery_options.dart';
import '../../blocs/products_bloc.dart';
import '../checkout/cart/cart4.dart';
import '../home/search.dart';
import '../products/barcode_products.dart';
import '../widgets/MD5Indicator.dart';
import '../blocks/count_down.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/app_state_model.dart';
import '../products/product_grid/product_item4.dart';
import '../../models/product_model.dart';
import '../blocks/banner_slider.dart';
import '../blocks/banner_slider2.dart';
import '../blocks/banner_slider3.dart';
import '../blocks/banner_grid_list.dart';
import '../blocks/banner_scroll_list.dart';
import '../blocks/banner_slider1.dart';
import '../blocks/category_grid_list.dart';
import '../blocks/category_scroll_list.dart';
import '../blocks/product_grid_list.dart';
import '../blocks/product_scroll_list.dart';
import '../../models/category_model.dart';
import '../products/product_detail/product_detail.dart';
import '../products/products.dart';
import '../../models/blocks_model.dart' hide Image, Key, Theme;
import 'package:flutter/rendering.dart';

import 'drawer/drawer6.dart';

class Home extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  Home({Key key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  TabController _controller;
  Category selectedCategory;

//  final cookieManager = WebviewCookieManager();


  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');
    widget.productsBloc.fetchProductsAttributes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print(_controller.index);
        if(_controller.index == 0) {
          appStateModel.loadMoreRecentProducts();
        } else {
          widget.productsBloc.loadMore(widget.productsBloc.productsFilter['id']);
        }
      }
    });
    _controller = TabController(vsync: this, length: appStateModel.mainCategories.length);
    _controller.index = 0;
    _controller.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(widget.productsBloc.productsFilter['id'] != appStateModel.mainCategories[_controller.index].id.toString()) {
      widget.productsBloc.productsFilter['id'] =
          appStateModel.mainCategories[_controller.index].id.toString();
      widget.productsBloc.fetchAllProducts(appStateModel.mainCategories[_controller.index].id.toString());
      if(_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      setState(() {
        selectedCategory = appStateModel.mainCategories[_controller.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
        return Scaffold(
           // drawer: MyDrawer(),
          appBar: AppBar(
            title: buildHomeTitle(context),
            bottom: TabBar(
              controller: _controller,
              isScrollable: true,
              //labelColor: Theme.of(context).primaryColor,
              //unselectedLabelColor: Theme.of(context).hintColor,
              //unselectedLabelStyle: Theme.of(context).textTheme.subtitle2,
              indicatorSize: TabBarIndicatorSize.label,
              //labelPadding: EdgeInsets.symmetric(horizontal: 10),
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
              tabs: model.mainCategories.map<Widget>((Category category) => Tab(
                  text: category.name
                      .replaceAll(new RegExp(r'&amp;'), '&')))
                  .toList(),
            ),
          ),
          body: _controller.index == 0 ?
            RefreshIndicator(
                onRefresh: () async {
                  await model.fetchAllBlocks();
                  return;
                },
                child: model.blocks != null
                    ? Container(
                  color: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: buildLisOfBlocks(model.blocks),
                  ),
                )
                    : Center(
                  child: CircularProgressIndicator(),
                )
            ) : _buildCategoryPage()
        );
      }
    );
  }

  _buildCategoryPage() {
    return StreamBuilder(
        stream: widget.productsBloc.allProducts,
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.grey[900],
              child: CustomScrollView(
                controller: _scrollController,
                slivers: buildLisOfCategoryBlocks(snapshot),
              ),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  List<Widget> buildLisOfCategoryBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = new List<Widget>();

    list.add(addCategoryBanner());

    /// UnComment this if you use rounded corner category list in body.
    list.add(buildSubcategories());
    if (snapshot.data != null) {
      list.add(ProductGrid(products: snapshot.data));

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    height: 60,
                    child: StreamBuilder(
                        stream: widget.productsBloc.hasMoreItems,
                        builder: (context, AsyncSnapshot<bool> snapshot) {
                          return snapshot.hasData && snapshot.data == false
                              ? Container()
                              : Center(child: CircularProgressIndicator());
                        }
                      //child: Center(child: CircularProgressIndicator())
                    ))
              ]))));
    }

    return list;
  }

  Widget buildSubcategories() {
    List<Category> subCategories = appStateModel.blocks.categories
        .where((element) => element.parent == selectedCategory.id)
        .toList();
    return subCategories.length != 0
        ? SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
        height: 140,
        width: 120,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: subCategories.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                height: 100,
                width: 100,
                child: Column(
                  children: <Widget>[
                    Card(
                      shape: StadiumBorder(),
                      margin: EdgeInsets.all(5.0),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0,
                      child: InkWell(
                        onTap: () {
                          var filter = new Map<String, dynamic>();
                          filter['id'] =
                              subCategories[index].id.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsWidget(
                                      filter: filter,
                                      name: parseHtmlString(subCategories[index].name))));
                        },
                        child: Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 18 / 18,
                              child: subCategories[index].image != null
                                  ? Image.network(
                                subCategories[index].image,
                                fit: BoxFit.cover,
                              )
                                  : Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    InkWell(
                      onTap: () {
                        var filter = new Map<String, dynamic>();
                        filter['id'] = subCategories[index].id.toString();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductsWidget(
                                    filter: filter,
                                    name: subCategories[index].name)));
                      },
                      child: Text(
                        subCategories[index].name,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    )
        : SliverToBoxAdapter();
  }

  Widget addCategoryBanner() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 16.0, 10.0, 10.0),
        height: 170,
        width: 50,
        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
        child: Card(
          elevation: 0.5,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: CachedNetworkImage(
            imageUrl:
            selectedCategory.image != null ? selectedCategory.image : '',
            imageBuilder: (context, imageProvider) => Ink.image(
              child: InkWell(
                onTap: () => _categoryBannerClick(selectedCategory),
              ),
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.black12),
          ),
        ),
      ),
    );
  }

  _categoryBannerClick(Category selectedCategory) {
    var filter = new Map<String, dynamic>();
    filter['id'] = selectedCategory.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: selectedCategory.name)));

  }

  List<Widget> buildLisOfBlocks(BlocksModel snapshot) {
    List<Widget> list = new List<Widget>();

    for (var i = 0; i < snapshot.blocks.length; i++) {
      if (snapshot.blocks[i].blockType == 'banner_block') {
        if (snapshot.blocks[i].style == 'grid') {
          list.add(buildGridHeader(snapshot, i));
          list.add(BannerGridList(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'scroll') {
          list.add(BannerScrollList(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider') {
          list.add(BannerSlider(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider1') {
          list.add(BannerSlider1(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider2') {
          list.add(BannerSlider2(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }

        if (snapshot.blocks[i].style == 'slider3') {
          list.add(BannerSlider3(
              block: snapshot.blocks[i], onBannerClick: onBannerClick));
        }
      }

      if (snapshot.blocks[i].blockType == 'category_block' &&
          snapshot.blocks[i].style == 'scroll') {
        if (snapshot.blocks[i].borderRadius == 50) {
          list.add(CategoryScrollStadiumList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        } else {
          list.add(CategoryScrollList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        }
      }

      if (snapshot.blocks[i].blockType == 'category_block' &&
          snapshot.blocks[i].style == 'grid') {
        list.add(buildGridHeader(snapshot, i));
        if (snapshot.blocks[i].borderRadius == 50) {
          list.add(CategoryStadiumGridList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        } else {
          list.add(CategoryGridList(
              block: snapshot.blocks[i],
              categories: snapshot.categories,
              onCategoryClick: onCategoryClick));
        }
      }

      if ((snapshot.blocks[i].blockType == 'product_block' || snapshot.blocks[i].blockType == 'flash_sale_block') &&
          snapshot.blocks[i].style == 'scroll') {
        list.add(ProductScrollList(
            block: snapshot.blocks[i], onProductClick: onProductClick));
      }

      if ((snapshot.blocks[i].blockType == 'product_block' || snapshot.blocks[i].blockType == 'flash_sale_block') &&
          snapshot.blocks[i].style == 'grid') {
        list.add(buildGridHeader(snapshot, i));
        list.add(ProductGridList(
            block: snapshot.blocks[i], onProductClick: onProductClick));
      }
    }

    if(snapshot.settings.showOnsale == 1 && snapshot.onSale.length > 0) {
      var filter = new Map<String, dynamic>();
      filter['on_sale'] = '1';
      list.add(ProductScroll(products: snapshot.onSale, context: context, title: snapshot.localeText.sale, viewAllTitle: snapshot.localeText.viewAll, filter: filter));
    }

    if(snapshot.settings.showFeatured == 1 && snapshot.featured.length > 0) {
      var filter = new Map<String, dynamic>();
      filter['featured'] = '1';
      list.add(ProductScroll(products: snapshot.featured, context: context, title: snapshot.localeText.featured, viewAllTitle: snapshot.localeText.viewAll, filter: filter));
    }

    if(snapshot.settings.showBestSelling == 1 && snapshot.bestSelling.length > 0) {
      var filter = new Map<String, dynamic>();
      filter['popularity'] = '1';
      list.add(ProductScroll(products: snapshot.bestSelling, context: context, title: snapshot.localeText.bestSelling, viewAllTitle: snapshot.localeText.viewAll, filter: filter));
    }

    if (snapshot.recentProducts != null && snapshot.recentProducts.length > 0 && snapshot.settings.showLatest == 1) {
      list.add(buildRecentProductGridList(snapshot));

      list.add(SliverPadding(
          padding: EdgeInsets.all(0.0),
          sliver: SliverList(
              delegate: SliverChildListDelegate([
            Container(
                height: 60,
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                  if (model.blocks?.recentProducts != null && model.hasMoreRecentItem == false) {
                    return Center(
                      child: Text(
                        model.blocks.localeText.noMoreProducts,
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }))
          ]))));
    }

    return list;
  }

  double _headerAlign(String align) {
    switch (align) {
      case 'top_left':
        return -1;
      case 'top_right':
        return 1;
      case 'top_center':
        return 0;
      case 'floating':
        return 2;
      case 'none':
        return null;
      default:
        return -1;
    }
  }

  Widget buildRecentProductGridList(BlocksModel snapshot) {
    return ProductGrid(
        products: snapshot.recentProducts);
  }

  Widget buildListHeader(AsyncSnapshot<BlocksModel> snapshot, int childIndex) {
    Color bgColor = HexColor(snapshot.data.blocks[childIndex].bgColor);
    double textAlign =
        _headerAlign(snapshot.data.blocks[childIndex].headerAlign);
    return textAlign != null
        ? SliverToBoxAdapter(child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
            return Container(
                padding: EdgeInsets.fromLTRB(
                    snapshot.data.blocks[childIndex].paddingBetween,
                    double.parse(
                        snapshot.data.blocks[childIndex].paddingTop.toString()),
                    snapshot.data.blocks[childIndex].paddingBetween,
                    16.0),
                color: GalleryOptions.of(context).themeMode == ThemeMode.light
                    ? bgColor
                    : Theme.of(context).scaffoldBackgroundColor,
                alignment: Alignment(textAlign, 0),
                child: Text(
                  snapshot.data.blocks[childIndex].title,
                  textAlign: TextAlign.start,
                  style: GalleryOptions.of(context).themeMode == ThemeMode.light
                      ? Theme.of(context).textTheme.headline6.copyWith(
                            color: HexColor(
                                snapshot.data.blocks[childIndex].titleColor),
                          )
                      : Theme.of(context).textTheme.headline6,
                ));
          }))
        : SliverToBoxAdapter(
            child: ScopedModelDescendant<AppStateModel>(
                builder: (context, child, model) {
              return Container(
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.fromLTRB(
                    snapshot.data.blocks[childIndex].paddingBetween,
                    double.parse(
                        snapshot.data.blocks[childIndex].paddingTop.toString()),
                    snapshot.data.blocks[childIndex].paddingBetween,
                    0.0),
                color: GalleryOptions.of(context).themeMode == ThemeMode.light
                    ? bgColor
                    : Theme.of(context).scaffoldBackgroundColor,
              );
            }),
          );
  }

  Widget buildGridHeader(BlocksModel snapshot, int childIndex) {
    double textAlign = _headerAlign(snapshot.blocks[childIndex].headerAlign);
    TextStyle subhead = Theme.of(context).brightness != Brightness.dark
        ? Theme.of(context).textTheme.headline6.copyWith(color: HexColor(snapshot.blocks[childIndex].titleColor))
        : Theme.of(context)
            .textTheme
            .headline6;

    TextStyle _textStyleCounter = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(color: Colors.white, fontSize: 12);

    if(snapshot.blocks[childIndex].blockType == 'flash_sale_block') {
      var dateTo = DateFormat('M/d/yyyy mm:ss').parse(snapshot.blocks[childIndex].saleEnds);
      var dateFrom = DateTime.now();
      final difference = dateTo.difference(dateFrom).inSeconds;

      return !difference.isNegative ? SliverToBoxAdapter(
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.fromLTRB(
                snapshot.blocks[childIndex].paddingBetween + 4,
                double.parse(snapshot.blocks[childIndex].paddingTop.toString()),
                snapshot.blocks[childIndex].paddingBetween + 4,
                0.0),
            alignment: Alignment(textAlign, 0),
            height: 60,
            child: Countdown(
              duration: Duration(seconds: difference),
              builder: (BuildContext ctx, Duration remaining) {
                return Row(
                  mainAxisAlignment: snapshot.blocks[childIndex].headerAlign == 'top_center' ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        child: Text(
                          snapshot.blocks[childIndex].title,
                          textAlign: TextAlign.start,
                          style: subhead,
                        )),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                new BorderRadius.all(Radius.circular(2.0))),
                            margin: EdgeInsets.all(4),
                            child: Center(
                                child: Text('${remaining.inHours.clamp(0, 99)}',
                                    maxLines: 1,
                                    style: _textStyleCounter)),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            margin: EdgeInsets.all(4),
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                new BorderRadius.all(Radius.circular(2.0))),
                            child: Center(
                                child: Text(
                                    '${remaining.inMinutes.remainder(60)}',
                                    style: _textStyleCounter)),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: new BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                new BorderRadius.all(Radius.circular(2.0))),
                            margin: EdgeInsets.all(4),
                            child: Center(
                                child: Text(
                                    '${remaining.inSeconds.remainder(60)}',
                                    style: _textStyleCounter)),
                          ),
                        ]),
                  ],
                );
              },
            ),
          ),
        ),
      ) : Container();
    }

    return textAlign != null
        ? SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    double.parse(snapshot.blocks[childIndex].paddingLeft
                            .toString()) +
                        4,
                    double.parse(
                        snapshot.blocks[childIndex].paddingTop.toString()),
                    double.parse(snapshot.blocks[childIndex].paddingRight
                            .toString()) +
                        4,
                    16.0),
                alignment: Alignment(textAlign, 0),
                child: Text(
                  snapshot.blocks[childIndex].title,
                  textAlign: TextAlign.start,
                  style: subhead,
                )))
        : SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  snapshot.blocks[childIndex].paddingBetween,
                  double.parse(
                      snapshot.blocks[childIndex].paddingTop.toString()),
                  snapshot.blocks[childIndex].paddingBetween,
                  0.0),
            ),
          );
  }

  onProductClick(product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(
        product: product
      );
    }));
  }

  onBannerClick(Child data) async {


/*
cookieManager.clearCookies();
ApiProvider apiProvider = ApiProvider();
List<Cookie> cook = apiProvider.generateCookies();
apiProvider.cookieList.forEach((element) {
 print('name: '+ element.name);
 print('value: '+ element.value);

  print('expires: '+ element.expires.toString());
  print('httpOnly: '+ element.httpOnly.toString());

  print(element.path);

  cookieManager.setCookies([
    Cookie(element.name, element.value)
      ..domain = '35.226.27.186'
      //..expires = DateTime.now().add(Duration(days: 10))
      //..httpOnly = true
  ]);

});*/

    if (data.url.isNotEmpty) {
      if (data.description == 'category') {
        var filter = new Map<String, dynamic>();
        filter['id'] = data.url;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductsWidget(
                    filter: filter,
                    name: data.title)));
      }
      else if (data.description == 'product') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                  product: Product(
                    id: int.parse(data.url),
                    name: data.title,
                  ),
                )));
      }
      else if(data.description == 'page') {
        var post = Post();
        post.id = int.parse(data.url);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PageDetail(post: post)));
      } else if(data.description == 'post') {
        var post = Post();
        post.id = int.parse(data.url);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PostDetail(post: post)));
      } else if(data.description == 'link') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebViewPage(url: data.url, title: data.title)));
      }
    }
  }

  onCategoryClick(Category category, List<Category> categories) {
    var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductsWidget(
                filter: filter,
                name: category.name)));
  }

  Row buildHomeTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        //Uncomment this comment search bar, If you want to put a logo instead of search bar
        Container(
          height: 55,
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Image.asset('lib/assets/images/logo.png'),
        ),
        /*Container(
          child: InkWell(
            onTap: () => _scanBarCode(),
            child: Icon(
              FlutterIcons.camera_fea,
              color: Theme.of(context).hintColor, //Theme.of(context).primaryIconTheme.color,Theme.of(context).hintColor,
            ),
          ),
        ),*/
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
                  return Search();
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
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => CartPage(),
                  fullscreenDialog: true,
                ));
          },
          child: Stack(children: <Widget>[
            Icon(
              FlutterIcons.shopping_cart_fea,
              color: Theme.of(context).hintColor, //Theme.of(context).hintColor
            ),
            new Positioned(
              top: -3.0,
              right: -3.0,
              child: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                    if (model.count != 0) {
                      return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: StadiumBorder(),
                          color: Colors.red,
                          child: Container(
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints(minWidth: 20.0),
                              child: Center(
                                  child: Text(
                                    model.count.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      backgroundColor: Colors.red,
                                    ),
                                  ))));
                    } else
                      return Container();
                  }),
            ),
          ]),
        ),
        /*InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Search();
            }));
          },
          child: Icon(FlutterIcons.search_fea),
        )*/
      ],
    );
  }

  _scanBarCode() async {
    /*String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(
          context: context,
          child: FindBarCodeProduct(result: barcodeScanRes, context: context));
    }*/
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
