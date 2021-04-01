import '../../../functions.dart';
import './../../checkout/webview_checkout/webview_checkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/login/buttons.dart';
import '../../../blocs/checkout_bloc.dart';
import '../../../models/cart/cart_model.dart';
import 'package:intl/intl.dart';
import '../../../models/checkout/checkout_form_model.dart';
import '../../../models/country_model.dart';
import '../../../resources/countires.dart';
import '../../color_override.dart';
import '../address.dart';

const double _leftColumnWidth = 60.0;

class CartPage extends StatefulWidget {
  final homeBloc = CheckoutBloc();
  final appStateModel = AppStateModel();
  final hideArrowButton;
  CartPage({Key key, this.hideArrowButton}) : super(key: key);

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
    widget.homeBloc.getCheckoutForm();
    widget.homeBloc.checkoutForm.listen((onData) => setAddressCountry(onData));
  }

  List<Widget> _createShoppingCartRows(CartModel shoppingCart) {
    int id;
    return shoppingCart.cartContents
        .map(
          (CartContent content) => ShoppingCartRow(
            product: content,
            onPressed: () {
              widget.appStateModel.removeItemFromCart(content.key);
            },
            onIncreaseQty: () {
              widget.appStateModel.increaseQty(content.key, content.quantity);
            },
            onDecreaseQty: () {
              widget.appStateModel.decreaseQty(content.key, content.quantity);
            },
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async  {
            await widget.appStateModel.getCart();
            widget.homeBloc.getCheckoutForm();
            return;
          },
          child: Column(
            children: <Widget>[
              widget.hideArrowButton != true
                  ? Row(
                      children: <Widget>[
                        SizedBox(
                          width: _leftColumnWidth,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        Text(
                          widget.appStateModel.blocks.localeText.cart,
                          //style: Theme.of(context).appBarTheme.textTheme.title,
                        ),
                        SizedBox( width: 16,),
                        ScopedModelDescendant<AppStateModel>(
                            builder: (context, child, model) {
                              if (model.shoppingCart?.cartContents != null && model.shoppingCart.cartContents.length != 0) {
                                return Text(
                                    '${model.shoppingCart.cartContents.length} ${widget.appStateModel.blocks.localeText.items}',
                                  //style: Theme.of(context).appBarTheme.textTheme.title,
                                );
                              } else {
                                return Container();
                              }

                        }),
                      ],
                    )
                  : Container(),
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
                        Center(child: Icon(FlutterIcons.shopping_cart_fea, size: 150, color: Theme.of(context).focusColor,))
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

  Stack buildCart(ThemeData localTheme, CartModel shoppingCart) {
    return Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            SizedBox( height: 16,),
            Column(
              children: _createShoppingCartRows(shoppingCart),
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: _leftColumnWidth,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - _leftColumnWidth,
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 16.0),
                        child: PrimaryColorOverride(
                          child: TextFormField(
                            controller: _couponCodeController,
                            decoration: InputDecoration(
                                hintText:
                                widget.appStateModel.blocks.localeText.couponCode,
                                suffix: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(widget.appStateModel.blocks.localeText
                                        .apply
                                        .toUpperCase()),
                                  ),
                                  onTap: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      widget.appStateModel.applyCoupon(
                                          _couponCodeController.text);
                                    }
                                  },
                                )),
                            validator: (value) {
                              if (value.isEmpty) {
                                return widget.appStateModel.blocks.localeText.pleaseEnterCouponCode;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              widget.homeBloc.formData['coupon_code'] = value;
                            },
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            ShoppingCartSummary(
                cartTotals: shoppingCart.cartTotals,
                currency: shoppingCart.currency, model: widget.appStateModel),
            const SizedBox(height: 100.0),
          ],
        ),
        Positioned(
          bottom: 16.0,
          left: 16.0,
          right: 16.0,

          child:Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                    side: BorderSide(color: Colors.red)
                ),
                elevation:0,
                color: Colors.deepOrangeAccent,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal:0, vertical: 10.0),
                  child:  Text("Checkout", style:TextStyle(
                      fontFamily: 'Monteserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                  ),),
                ),
                onPressed: () async {
              if(widget.appStateModel.blocks.settings.switchWebViewCheckout == 1 && widget.appStateModel.loggedIn) {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>
                    WebViewCheckout()
                ));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Address(homeBloc: widget.homeBloc)));
              }
            },
              ),
            ),
          )
//          AccentButton(
//            onPressed: () async {
//              if(widget.appStateModel.blocks.settings.switchWebViewCheckout == 1 && widget.appStateModel.loggedIn) {
//                Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                    WebViewCheckout()
//                ));
//              } else {
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) =>
//                            Address(homeBloc: widget.homeBloc)));
//              }
//            },
//            showProgress: false,
//            text: widget.appStateModel.blocks.localeText.checkout,
//          ),
          /*RaisedButton(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(2.0)),
            ),
            //color: Colors.red,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(AppLocalizations.of(context).checkout),
            ),
            onPressed: () {
              //model.clearCart();
              //ExpandingBottomSheet.of(context).close();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Address(homeBloc: widget.homeBloc)));
            },
          ),*/
        ),
      ],
    );
  }

  setAddressCountry(CheckoutFormModel onData) {
    if (onData.billingCountry != null && onData.billingCountry.isNotEmpty) {
      widget.homeBloc.initialSelectedCountry = onData.billingCountry;
    }
    if (onData.billingState != null && onData.billingState.isNotEmpty) {
      List<CountryModel> countries =
          countryModelFromJson(JsonStrings.listOfSimpleObjects);
      CountryModel country =
          countries.singleWhere((item) => item.value == onData.billingCountry);
      if (country.regions != null &&
          country.regions.any((item) => item.value == onData.billingState)) {
        widget.homeBloc.formData['billing_state'] = onData.billingState;
      } else
        widget.homeBloc.formData['billing_state'] = null;
    }
  }
}

class ShoppingCartSummary extends StatelessWidget {
  const ShoppingCartSummary({
    @required this.cartTotals,
    @required this.currency,
    @required this.model,
  });

  final CartTotals cartTotals;
  final String currency;
  final AppStateModel model;

  @override
  Widget build(BuildContext context) {
    final smallAmountStyle = Theme.of(context).textTheme.body1;
    final largeAmountStyle = Theme.of(context).textTheme.title;

    return Row(
      children: <Widget>[
        const SizedBox(width: _leftColumnWidth),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(model.blocks.localeText.total),
                    ),
                    Text(
                      parseHtmlString(cartTotals.total),
                      style: largeAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(model.blocks.localeText.subtotal),
                    ),
                    Text(
                      parseHtmlString(cartTotals.subtotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(model.blocks.localeText.shipping),
                    ),
                    Text(
                      parseHtmlString(cartTotals.shippingTotal),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(model.blocks.localeText.tax),
                    ),
                    Text(
                      parseHtmlString(cartTotals.totalTax),
                      style: smallAmountStyle,
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(model.blocks.localeText.discount),
                    ),
                    Text(
                      parseHtmlString(cartTotals.discountTotal),
                      style: smallAmountStyle,
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
   ShoppingCartRow(
      {@required this.product,
      this.onPressed,
      this.onIncreaseQty,
      this.onDecreaseQty});

  final CartContent product;
  final VoidCallback onPressed;
  final VoidCallback onIncreaseQty;
  final VoidCallback onDecreaseQty;
  final appStateModel = AppStateModel();

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData localTheme = Theme.of(context);

    final iconColor = Theme.of(context).iconTheme.color.withOpacity(0.4);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        key: ValueKey<int>(widget.product.productId),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: _leftColumnWidth,
            child: IconButton(
              icon: Icon(Icons.remove_circle_outline, color: iconColor),
              onPressed: _removeItem,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        widget.product.thumb,
                        //package: product.assetPackage,
                        fit: BoxFit.cover,
                        width: 75.0,
                        height: 75.0,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.product.name,
                              style: localTheme.textTheme.bodyText1
                                  .copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(parseHtmlString(widget.product.formattedPrice)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline, color: iconColor,),
                                  onPressed: _onDecreaseQty,
                                ),
                                isLoading
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                        ))
                                    : Container(
                                        width: 20,
                                        height: 16,
                                        child: Center(
                                            child: Text(
                                                widget.product.quantity.toString()))),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: _onIncreaseQty,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Divider(
                    color: Colors.black26,
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
        ],
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
    await widget.appStateModel.increaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onDecreaseQty() async {
    setState(() {
      isLoading = true;
    });
    await widget.appStateModel.decreaseQty(widget.product.key, widget.product.quantity);
    setState(() {
      isLoading = false;
    });
  }

}
