import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../src/ui/widgets/MD5Indicator.dart';
import './../../../assets/presentation/m_store_icons_icons.dart';
import '../../blocs/products_bloc.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../checkout/cart/cart4.dart';
import 'clipper_design.dart';
import 'product_detail/product_detail.dart';
import 'product_filter/filter2.dart';
import 'product_filter/filter_product.dart';
import 'product_grid/product_item4.dart';

class ProductsWidget extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  final Map<String, dynamic> filter;
  final String name;
  AppStateModel model = AppStateModel();

  ProductsWidget({Key key, this.filter, this.name}) : super(key: key);

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController = new ScrollController();
  TabController _tabController;
  Category selectedCategory;
  List<Category> subCategories;

  @override
  void initState() {
    super.initState();
    widget.model.selectedRange =
        RangeValues(0, widget.model.blocks.maxPrice.toDouble());
    if(widget.filter['id'] == null) {
      widget.filter['id'] = '0';
    }
    widget.productsBloc.productsFilter = widget.filter;
    subCategories = widget.model.blocks.categories
        .where(
            (cat) => cat.parent.toString() == widget.productsBloc.productsFilter['id'])
        .toList();
    if (subCategories.length != 0) {
      subCategories.insert(
          0, Category(name: 'All', id: int.parse(widget.filter['id'])));
    }
    _tabController = TabController(vsync: this, length: subCategories.length);
    _tabController.index = 0;
    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
    widget.productsBloc.fetchProductsAttributes();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && widget.productsBloc.hasMoreItems.value == true) {
        widget.productsBloc.loadMore(widget.productsBloc.productsFilter['id']);
      }
    });
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if(widget.productsBloc.productsFilter['id'] != subCategories[_tabController.index].id.toString()) {
      widget.productsBloc.productsFilter['id'] =
          subCategories[_tabController.index].id.toString();
      widget.model.selectedRange =
          RangeValues(0, widget.model.blocks.maxPrice.toDouble());
      widget.productsBloc.fetchAllProducts(subCategories[_tabController.index].id.toString());
      if(_scrollController.hasClients) {
        _scrollController.jumpTo(0.0);
      }
      setState(() {
        selectedCategory = subCategories[_tabController.index];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.productsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey.withOpacity(.5),
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.black,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
            icon:Icon(Icons.arrow_back,color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,)
        ),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: subCategories.length != 0
            ? PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    //unselectedLabelColor: Theme.of(context).hintColor,
                    labelStyle: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w900,fontFamily: 'Lato'),
                    unselectedLabelStyle: TextStyle(fontSize: 16.0,fontFamily: 'Lato'),
                    unselectedLabelColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.white.withOpacity(.5): Colors.black.withOpacity(0.5),
                    labelColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.white: Colors.black,
                    indicator: MD2Indicator(
                        indicatorHeight: 5,
                        indicatorColor: Theme.of(context).primaryColorBrightness == Brightness.dark ? Colors.orangeAccent: Colors.black,//Theme.of(context).primaryColor,//Colors.white,//Theme.of(context).primaryColor,
                        indicatorSize: MD2IndicatorSize.normal  //3 different modes tiny-normal-full
                    ),
                    tabs: subCategories
                        .map<Widget>((Category category) => Tab(
                            text: category.name
                                .replaceAll(new RegExp(r'&amp;'), '&')))
                        .toList(),
                  ),
                ),
              )
            : null,
        title: widget.name != null
            ? Text(parseHtmlString(widget.name),style: TextStyle(
          color:Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Colors.white,
        ),)
            : Text(parseHtmlString(widget.name)),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              MStoreIcons.arrow_up_down_line,
              semanticLabel: 'filter',
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
            ),
              onPressed:() => _showPopupMenu()
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => FilterProduct2(
                        productsBloc: widget.productsBloc),
                  ));
            },
          ),
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  FlutterIcons.shopping_cart_fea,
                  semanticLabel: 'filter',
                  color:Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => CartPage(),
                      ));
                },
              ),
              Positioned(
                // draw a red marble
                top: 2,
                right: 2.0,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => CartPage(),
                        ));
                  },
                  child: ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                    if (model.count != 0) {
                      return Card(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.white,
                          child: Container(
                              padding: EdgeInsets.all(2),
                              constraints: BoxConstraints(minWidth: 20.0),
                              child: Center(
                                  child: Text(
                                model.count.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                ),
                              ))));
                    } else
                      return Container();
                  }),
                ),
              )
            ],
          ),
        ],
      ),
      body: Stack(
        overflow: Overflow.visible,
        children: [
          Container(
              height: 180,
              width: double.infinity,
              child: CustomPaint(
                painter:CurvePainter(color: Theme.of(context).brightness == Brightness.light ? Theme.of(context).primaryColor : Theme.of(context).primaryColor,),
              )),
              StreamBuilder(
              stream: widget.productsBloc.allProducts,
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length != 0) {
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: buildLisOfBlocks(snapshot),
                    );
                  } else {
                    return StreamBuilder<bool>(
                        stream: widget.productsBloc.isLoadingProducts,
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true) {
                            return Center(child: CircularProgressIndicator());
                          } else
                            return Center(
                              child: Icon(
                                FlutterIcons.smile_o_faw,
                                size: 150,
                                color: Theme.of(context).focusColor,
                              ),
                            );
                        });
                  }
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                return Center(child: CircularProgressIndicator());
              }),
            ],
      ),
    );
  }

  List<Widget> buildLisOfBlocks(AsyncSnapshot<List<Product>> snapshot) {
    List<Widget> list = new List<Widget>();

    /// UnComment this if you use rounded corner category list in body.
    //list.add(buildSubcategories());
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
                          ? Center(child: Text('No more products!'))
                          : Center(child: CircularProgressIndicator());
                    }
                    //child: Center(child: CircularProgressIndicator())
                    ))
          ]))));
    }

    return list;
  }

  Widget buildVerticalGridBlock(AsyncSnapshot<List<Product>> snapshot) {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  ProductItem(
                      product: snapshot.data[index]),
                  Divider(height: 0.0),
                ],
              );
            },
            childCount: snapshot.data.length,
          ),
        ));
  }

  Widget buildSubcategories() {
    return subCategories.length != 0
        ? SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
              height: 140,
              width: 120,
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
                            elevation: 0.5,
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
                                            name: subCategories[index].name)));
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

  void _showPopupMenu() async {
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(150, 100, 50, 100),
      items: [
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.date), value: ['date', 'ASC']
        ),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.priceHighToLow), value: ['price', 'DESC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.priceLowToHigh), value: ['price', 'ASC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.newArrivals), value: ['date', 'DESC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.popular), value: ['popularity', 'ASC']),
        PopupMenuItem<List>(
            child: Text(widget.model.blocks.localeText.rating), value: ['rating', 'ASC']),
      ],
      elevation: 4.0,
    );
    if(result != null)
    _sort(result[0], result[1]);
  }

  _sort(String orderBy, String order) {
    widget.productsBloc.productsFilter['order'] = order;
    widget.productsBloc.productsFilter['orderby'] = orderBy;
    widget.productsBloc.reset();

    widget.productsBloc.fetchAllProducts(widget.productsBloc.productsFilter['id']);
  }

  onProductClick(data) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: data);
    }));
  }
}

