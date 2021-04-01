import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../ui/accounts/login/login.dart';
import '../../../ui/checkout/webview_checkout/webview_checkout.dart';
import '../../../blocs/checkout_bloc.dart';
import '../../../functions.dart';
import '../../../models/app_state_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/checkout/checkout_form_model.dart';
import '../../../models/country_model.dart';
import '../../../resources/countires.dart';
import '../address.dart';

const double _leftColumnWidth = 60.0;

class CartPage extends StatefulWidget {
  final checkoutBloc = CheckoutBloc();
  final appStateModel = AppStateModel();
  CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  TextEditingController _couponCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.appStateModel.getCart();
    widget.checkoutBloc.getCheckoutForm();
    widget.checkoutBloc.checkoutForm
        .listen((onData) => setAddressCountry(onData));
  }

  List<Widget> _createShoppingCartRows(CartModel shoppingCart) {
    return shoppingCart.cartContents
        .map((CartContent item) => ShoppingCartRow(product: item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.cart),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await widget.appStateModel.getCart();
            widget.checkoutBloc.getCheckoutForm();
            return;
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                  if (model.shoppingCart?.cartContents == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (model.shoppingCart.cartContents.length != 0) {
                    return buildCart(localTheme, model.shoppingCart);
                  } else {
                    return Stack(
                      children: <Widget>[
                        ListView(
                          children: <Widget>[
                            Container(),
                          ],
                        ),
                        Center(
                            child: Icon(
                          FlutterIcons.shopping_cart_fea,
                          size: 150,
                          color: Theme.of(context).focusColor,
                        ))
                      ],
                    );
                  }
                  ;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCart(ThemeData localTheme, CartModel shoppingCart) {
    return ListView(
      children: <Widget>[
        Column(
          children: _createShoppingCartRows(shoppingCart),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 16, 0, 4),
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 16,
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * .68,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _couponCodeController,
                    decoration: new InputDecoration(
                      errorStyle: TextStyle(
                        height: 0,
                      ),
                      filled: true,
                      border: InputBorder.none,
                      hintText:
                          widget.appStateModel.blocks.localeText.couponCode,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return widget.appStateModel.blocks.localeText
                            .pleaseEnterCouponCode;
                      }
                      return null;
                    },
                    onSaved: (value) {
                      widget.checkoutBloc.formData['coupon_code'] = value;
                    },
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width * .22,
                  alignment: Alignment.center,
                  height: 38,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.lightBlueAccent, width: 1),
                      borderRadius: BorderRadius.circular(4)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      widget.appStateModel.blocks.localeText.apply,
                      style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    widget.appStateModel
                        .applyCoupon(_couponCodeController.text);
                  }
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        ),
        SizedBox(
          height: 10,
        ),
        ShoppingCartSummary(cart: shoppingCart, model: widget.appStateModel),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.appStateModel.blocks.localeText.checkout),
            ),
            onPressed: () async {
              if (widget.appStateModel.blocks.settings.switchWebViewCheckout ==
                  1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewCheckout()));
              } else {
                if(widget.appStateModel.blocks.settings.disableGuestCheckout == 1 && (widget.appStateModel.user?.id == null || widget.appStateModel.user.id == 0)) {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      Login()
                  ));
                  if(widget.appStateModel.user?.id != null && widget.appStateModel.user.id > 0 ) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Address(homeBloc: widget.checkoutBloc)));
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Address(homeBloc: widget.checkoutBloc)));
                }
              }
            },
          ),
        ),
      ],
    );
  }

  setAddressCountry(CheckoutFormModel onData) {
    if (onData.billingCountry != null && onData.billingCountry.isNotEmpty) {
      widget.checkoutBloc.initialSelectedCountry = onData.billingCountry;
    }
    if (onData.billingState != null && onData.billingState.isNotEmpty) {
      List<CountryModel> countries =
          countryModelFromJson(JsonStrings.listOfSimpleObjects);
      CountryModel country =
          countries.singleWhere((item) => item.value == onData.billingCountry);
      if (country.regions != null &&
          country.regions.any((item) => item.value == onData.billingState)) {
        widget.checkoutBloc.formData['billing_state'] = onData.billingState;
      } else
        widget.checkoutBloc.formData['billing_state'] = null;
    }
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({
    @required this.cart,
    @required this.model,
  });

  final CartModel cart;
  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle = Theme.of(context).textTheme.bodyText2;
    final largeAmountStyle = Theme.of(context).textTheme.headline6;

    var feeWidgets = List<Widget>();
    for (var fee in cart.cartFees) {
      feeWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(fee.name),
              ),
              Text(
                parseHtmlString(fee.total.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    var couponsWidgets = List<Widget>();
    for (var item in cart.coupons) {
      couponsWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Text(item.code),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                        onTap: () => model.removeCoupon(item.code),
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              Text(
                parseHtmlString(item.amount.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        model.blocks.localeText.subtotal,
                        style: smallAmountStyle,
                      ),
                    ),
                    Text(
                      parseHtmlString(
                        cart.cartTotals.subtotal,
                      ),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        model.blocks.localeText.shipping,
                        style: smallAmountStyle,
                      ),
                    ),
                    Text(
                      parseHtmlString(cart.cartTotals.shippingTotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        model.blocks.localeText.tax,
                        style: smallAmountStyle,
                      ),
                    ),
                    Text(
                      parseHtmlString(cart.cartTotals.totalTax),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                feeWidgets.length > 0
                    ? Column(
                        children: [
                          const SizedBox(height: 6.0),
                          Column(
                            children: feeWidgets,
                          ),
                        ],
                      )
                    : Container(),
                couponsWidgets.length > 0
                    ? Column(
                        children: [
                          const SizedBox(height: 6.0),
                          Column(
                            children: couponsWidgets,
                          ),
                        ],
                      )
                    : Container(),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        model.blocks.localeText.discount,
                        style: smallAmountStyle,
                      ),
                    ),
                    Text(
                      parseHtmlString(cart.cartTotals.discountTotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Divider(
                  thickness: 0.5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        model.blocks.localeText.total,
                        style: largeAmountStyle,
                      ),
                    ),
                    Text(
                      parseHtmlString(cart.cartTotals.total),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShoppingCartRow extends StatefulWidget {
  ShoppingCartRow({@required this.product});

  final CartContent product;
  final appStateModel = AppStateModel();

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color.withOpacity(0.4);
    double detailsWidth = MediaQuery.of(context).size.width - 152;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      elevation: 0,
      margin: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(16),
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
                    imageUrl: widget.product.thumb,
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
                      height: 120,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: detailsWidth,
              height: 120,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 4.0, 0, 4.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.product.name,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyText2),
                        SizedBox(height: 4.0),
                        //TODO Product Oprions Or Variations
                        SizedBox(height: 4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: <Widget>[
                            Text(
                                parseHtmlString(
                                  widget.product.formattedPrice,
                                ),
                                style: Theme.of(context).textTheme.subtitle2)
                          ],
                        ),
                        SizedBox(height: 4.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: _removeItem,
                              child: Icon(Icons.delete_outline,
                                  color: Theme.of(context).hintColor),
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Color(0xffafc2cb).withOpacity(.1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: Color(0xffafc2cb)
                                              .withOpacity(.2)),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: _onDecreaseQty,
                                        child: Icon(
                                          Icons.remove,
                                          color: iconColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    isLoading
                                        ? Container(
                                            width: 30,
                                            height: 30,
                                            padding: EdgeInsets.all(5),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.0,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: 30,
                                            height: 30,
                                            alignment: Alignment.center,
                                            child: Text(
                                                widget.product.quantity
                                                    .toString(),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2)),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xffafc2cb).withOpacity(.2),
                                      ),
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        onTap: _onIncreaseQty,
                                        child: Icon(
                                          Icons.add,
                                          color: iconColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _removeItem() {
    widget.appStateModel.removeItemFromCart(widget.product.key);
  }

  _onIncreaseQty() async {
    setState(() {
      isLoading = true;
    });
    await widget.appStateModel
        .increaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onDecreaseQty() async {
    setState(() {
      isLoading = true;
    });
    await widget.appStateModel
        .decreaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }
}
