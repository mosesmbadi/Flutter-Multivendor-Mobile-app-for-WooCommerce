import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../ui/products/product_grid/products_widgets/add_to_cart_new.dart';
import './../../blocs/wishlist_bloc.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/product_model.dart';
import '../products/product_detail/product_detail.dart';

class WishList extends StatefulWidget {
  final appStateModel = AppStateModel();
  final wishListBloc = WishListBloc();
  WishList({Key key}) : super(key: key);
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  int index;
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    widget.wishListBloc.getWishList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.wishListBloc.loadMoreWishList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.wishlist),
      ),
      body: StreamBuilder(
          stream: widget.wishListBloc.wishList,
          builder: (context, AsyncSnapshot<List<Product>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length == 0) {
                return Center(
                  child: Text(widget.appStateModel.blocks.localeText.noWishlist+'!'),
                );
              } else {
                return CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      ProductGrid(products: snapshot.data, wishListBloc: widget.wishListBloc),
                      buildLoadMore(),
                    ]);
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildList(AsyncSnapshot<List<Product>> snapshot) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {

          return ProductItem(
              product: snapshot.data[index]);

         /* int percentOff = 0;

          if ((snapshot.data[index].salePrice != null && snapshot.data[index].salePrice != 0)) {
            percentOff = (((snapshot.data[index].regularPrice - snapshot.data[index].salePrice) / snapshot.data[index].regularPrice) * 100).round();
          }

          bool onSale = false;

          if(snapshot.data[index].salePrice != 0) {
            onSale = true;
          }

          return Card(
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.all(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: InkWell(
              onTap: () {
                openDetail(snapshot.data, index);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    child: CachedNetworkImage(
                      imageUrl: snapshot.data[index].images[0].src,
                      imageBuilder: (context, imageProvider) => Container(
                        child: Ink.image(
                          child: InkWell(
                              //  onTap: () {openDetail(snapshot.data, index,);},
                              ),
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      placeholder: (context, url) => Container(
                        width: 120,
                        height: 120,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      errorWidget: (context, url, error) => Container(color: Colors.black12),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0.0, 0, 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text(parseHtmlString(snapshot.data[index].name),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                              ),
                              IconButton(
                                onPressed: () => {
                                  widget.wishListBloc.removeItemFromWishList(
                                      snapshot.data[index].id)
                                },
                                icon: Icon(
                                  Icons.remove_circle_outline,
                                  size: 22,
                                  color: Theme.of(context).hintColor,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 2),
                          Text(parseHtmlString(snapshot.data[index].shortDescription),
                              maxLines: 2,
                              style: TextStyle(
                                  color: Theme.of(context).textTheme.caption.color.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  letterSpacing: 0.07)),
                          SizedBox(height: 8),
                          PriceWidget(onSale: onSale, product: snapshot.data[index]),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );*/
        },
        childCount: snapshot.data.length,
      ),
    );
  }

  buildLoadMore() {
    return SliverPadding(
        padding: EdgeInsets.all(0.0),
        sliver: SliverList(
            delegate: SliverChildListDelegate([
          Container(
              height: 60,
              child: StreamBuilder(
                  stream: widget.wishListBloc.hasMoreWishlistItems,
                  builder: (context, AsyncSnapshot<bool> snapshot) {
                    return snapshot.hasData && snapshot.data == false
                        ? Center(child: Text(widget.appStateModel.blocks.localeText.noMoreWishlist+'!'))
                        : Center(child: CircularProgressIndicator());
                  }
                  //child: Center(child: CircularProgressIndicator())
                  ))
        ])));
  }
}

const double _scaffoldPadding = 10.0;
const double _minWidthPerColumn = 350.0 + _scaffoldPadding * 2;

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final WishListBloc wishListBloc;
  const ProductGrid({Key key, this.products, this.wishListBloc}) : super(key: key);
  @override
  _ProductGridState createState() => _ProductGridState();
}


class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;
    return SliverPadding(
      padding: const EdgeInsets.all(10.0),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 2.3,
          crossAxisCount: crossAxisCount,
        ),
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return ProductItem(
                product: widget.products[index],
                onProductClick: onProductClick,
                wishListBloc: widget.wishListBloc);
          },
          childCount: widget.products.length,
        ),
      ),
    );
  }

  onProductClick(Product product) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ProductDetail(product: product);
    }));
  }
}

class ProductItem extends StatelessWidget {
  final Product product;
  final WishListBloc wishListBloc;
  final void Function(Product category) onProductClick;
  int percentOff = 0;

  ProductItem({
    Key key,
    this.product,
    this.onProductClick, this.wishListBloc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < _minWidthPerColumn
        ? 1
        : screenWidth ~/ _minWidthPerColumn;

    double detailsWidth = (screenWidth / crossAxisCount) - 160;
    if ((product.salePrice != null && product.salePrice != 0)) {
      percentOff = ((((product.regularPrice - product.salePrice) /
          product.regularPrice *
          100))
          .round());
    }
    bool onSale = false;
    if (product.regularPrice == null || product.regularPrice.isNaN) {
      product.regularPrice = product.price;
    }
    if (product.salePrice != null && product.salePrice != 0) {
      onSale = true;
    }
    return InkWell(
      splashColor: Theme.of(context).accentColor.withOpacity(0.1),
      onTap: () {
        onProductClick(product);
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 120,
              height: 120,
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
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
                      width: 120,
                      height: 160,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                    ),
                  ),
                  percentOff != 1
                      ? Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4.0),
                            bottomRight: Radius.circular(4.0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      elevation: 0.0,
                      margin: EdgeInsets.all(0.0),
                      color: Theme.of(context).accentColor,
                      child: percentOff != 0
                          ? Center(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              8.0, 4.0, 8.0, 4.0),
                          child: Text(
                            '-' + percentOff.toString() + '%',
                            style: Theme.of(context)
                                .accentTextTheme
                                .body2
                                .copyWith(fontSize: 12.0),
                          ),
                        ),
                      )
                          : Container(),
                    ),
                  )
                      : Container()
                ],
              ),
            ),
            Container(
              width: detailsWidth,
              height: 130,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16, 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(product.name,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.w600)),
                        SizedBox(height: 4.0),
                        Text(parseHtmlString(product.shortDescription),
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).hintColor,
                              letterSpacing: 0.0,
                              fontSize: 12,
                            )),
                        SizedBox(height: 6.0),
                        Row(
                          //crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                                onSale
                                    ? parseHtmlString(
                                    product.formattedSalesPrice)
                                    : '',
                                style:
                                Theme.of(context).textTheme.body1.copyWith(
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w600,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface,
                                )),
                            onSale
                                ? SizedBox(width: 6.0)
                                : SizedBox(width: 0.0),
                            Text(
                                (product.formattedPrice != null &&
                                    product.formattedPrice.isNotEmpty)
                                    ? parseHtmlString(product.formattedPrice)
                                    : '',
                                style: TextStyle(
                                  fontWeight: onSale
                                      ? FontWeight.w200
                                      : FontWeight.w600,
                                  fontSize: onSale ? 11 : 16,
                                  color: onSale
                                      ? Theme.of(context).hintColor
                                      : Theme.of(context).colorScheme.onSurface,
                                  decoration: onSale
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                )),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => {
                            wishListBloc.removeItemFromWishList(
                              product.id)
                          },
                          icon: Icon(
                            Icons.remove_circle_outline,
                            size: 22,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        /*ScopedModelDescendant<AppStateModel>(
                            builder: (context, child, model) {
                              return AddToCart(model: model,
                                product: product,
                              );
                            }),*/
                      ],
                    )
                    /* Row(
                      children: [
                        Row(
                          children: <Widget>[
                            RatingBar(
                              initialRating:
                                  double.parse(product.averageRating),
                              itemSize: 10,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              ignoreGestures: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 0.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              unratedColor:
                                  Theme.of(context).hintColor.withOpacity(0.3),
                              onRatingUpdate: (rating) {},
                            ),
                            product.averageRating != '0.00'
                                ? Row(
                                    children: <Widget>[
                                      SizedBox(width: 4.0),
                                      Text(
                                          '(' +
                                              product.ratingCount.toString() +
                                              ')',
                                          maxLines: 2,
                                          style: TextStyle(
                                            color: Theme.of(context).hintColor,
                                            fontSize: 12,
                                          )),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    )*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}