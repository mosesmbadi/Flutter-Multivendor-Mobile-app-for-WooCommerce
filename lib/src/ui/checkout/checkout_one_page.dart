import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../widgets/buttons/button_text.dart';
import '../../blocs/checkout_bloc.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout/order_result_model.dart';
import '../../models/checkout/order_review_model.dart';
import '../../models/checkout/stripeSource.dart';
import '../../models/checkout/stripe_token.dart';
import '../../ui/checkout/webview.dart';
import '../color_override.dart';
import 'order_summary.dart';
import 'payment/payment_card.dart';

class CheckoutOnePage extends StatefulWidget {
  final CheckoutBloc homeBloc;
  final appStateModel = AppStateModel();
  CheckoutOnePage({this.homeBloc});
  @override
  _CheckoutOnePageState createState() => _CheckoutOnePageState();
}

class _CheckoutOnePageState extends State<CheckoutOnePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String _error;

  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.checkout),
      ),
      body: SafeArea(
        child: StreamBuilder<OrderReviewModel>(
            stream: widget.homeBloc.orderReview,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? _buildCheckoutForm(snapshot, context)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            }),
      ),
    );
  }

  Widget _buildCheckoutForm(
      AsyncSnapshot<OrderReviewModel> snapshot, BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
      return CustomScrollView(
        slivers: slivers(snapshot, context, model),
      );
    });
  }

  List<Widget> slivers(AsyncSnapshot<OrderReviewModel> snapshot,
      BuildContext context, AppStateModel model) {
    TextStyle subhead = Theme.of(context)
        .textTheme
        .subtitle1
        .copyWith(fontWeight: FontWeight.w600);

    List<Widget> list = new List<Widget>();

    if (snapshot.data.shipping.length > 0) {
      for (var i = 0; i < snapshot.data.shipping.length; i++) {
        if (snapshot.data.shipping[i].shippingMethods.length > 0) {
          list.add(SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
            child: Text(
              snapshot.data.shipping[i].packageName,
              style: subhead,
            ),
          )));

          list.add(_buildShippingList(snapshot, i));
        }
      }

      list.add(SliverToBoxAdapter(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
        child: Divider(
          color: Theme.of(context).dividerColor,
          height: 10.0,
        ),
      )));
    }

    list.add(SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      child: Text(
        widget.appStateModel.blocks.localeText.paymentMethod,
        // widget.appStateModel.blocks.localeText.payment,
        style: subhead,
      ),
    )));

    list.add(_buildPaymentList(snapshot));

    list.add(SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 8.0),
      child: Text(
        widget.appStateModel.blocks.localeText.order,
        style: subhead,
      ),
    )));
    list.add(_buildOrderList(snapshot));

    list.add(SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              child: ButtonText(
                  isLoading: isLoading,
                  text: widget
                      .appStateModel.blocks.localeText.localeTextContinue),
              onPressed: () => isLoading ? null : _placeOrder(snapshot),
            ),
            StreamBuilder<OrderResult>(
                stream: widget.homeBloc.orderResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data.result == "failure") {
                    return Center(
                      child: Container(
                          padding: EdgeInsets.all(4.0),
                          child: Text(parseHtmlString(snapshot.data.messages),
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle
                                  .copyWith(
                                      color: Theme.of(context).errorColor))),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data.result == "success") {
                    return Container();
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    ));

    return list;
  }

  _buildShippingList(AsyncSnapshot<OrderReviewModel> snapshot, int i) {
    print(snapshot.data.shipping[i].shippingMethods.length);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          print(snapshot.data.shipping[i].shippingMethods[index].label);
          return RadioListTile<String>(
            value: snapshot.data.shipping[i].shippingMethods[index].id,
            groupValue: snapshot.data.shipping[i].chosenMethod,
            onChanged: (String value) {
              setState(() {
                snapshot.data.shipping[i].chosenMethod = value;
              });
              widget.homeBloc.updateOrderReview2();
            },
            title: Text(snapshot.data.shipping[i].shippingMethods[index].label +
                ' ' +
                parseHtmlString(
                    snapshot.data.shipping[i].shippingMethods[index].cost)),
          );
        },
        childCount: snapshot.data.shipping[i].shippingMethods.length,
      ),
    );
  }

  _buildPaymentList(AsyncSnapshot<OrderReviewModel> snapshot) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          Widget paymentTitle = snapshot.data.paymentMethods[index].id == 'wallet' ? Row(
            children: [
              Text(parseHtmlString(snapshot.data.paymentMethods[index].title)),
              SizedBox(width: 8),
              Text(parseHtmlString(snapshot.data.balanceFormatted), style: Theme.of(context).textTheme.subtitle2,)
            ],
          ) : Text(parseHtmlString(snapshot.data.paymentMethods[index].title));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Radio<String>(
                  value: snapshot.data.paymentMethods[index].id,
                  groupValue: widget.homeBloc.formData['payment_method'],
                  onChanged: (String value) {
                    setState(() {
                      isLoading = false;
                      widget.homeBloc.formData['payment_method'] = value;
                    });
                    widget.homeBloc.updateOrderReview2();
                  },
                ),
                Container(width: cWidth, child: paymentTitle),
              ],
            ),
          );
        },
        childCount: snapshot.data.paymentMethods.length,
      ),
    );
  }

  _buildOrderList(AsyncSnapshot<OrderReviewModel> snapshot) {
    final smallAmountStyle = Theme.of(context).textTheme.body1;
    final largeAmountStyle = Theme.of(context).textTheme.title;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 0.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.subtotal + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.subtotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: Text(
                      widget.appStateModel.blocks.localeText.shipping + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.shippingTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: [
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.tax + ':'),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.totalTax),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 4.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(widget.appStateModel.blocks.localeText.discount),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.discountTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.appStateModel.blocks.localeText.total,
                    style: largeAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(snapshot.data.totals.total),
                  style: largeAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: PrimaryColorOverride(
                      child: TextFormField(
                        maxLines: 2,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          labelText: widget.appStateModel.blocks.localeText.orderNote,
                          errorMaxLines: 1,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 0.5),
                          ),
                        ),
                        onChanged: (value) {
                          widget.homeBloc.formData['order_comments'] = value;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  openWebView(String url)  async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebViewPage(
                url: url,
                selectedPaymentMethod:
                    widget.homeBloc.formData['payment_method'])));
    setState(() {
      isLoading = false;
    });
  }

  void orderDetails(OrderResult orderResult) {
    var orderId = getOrderIdFromUrl(orderResult.redirect);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
                  id: orderId,
                )));
  }

  _placeOrder(AsyncSnapshot<OrderReviewModel> snapshot) async {
    setState(() {
      isLoading = true;
    });
    if (widget.homeBloc.formData['payment_method'] == 'stripe') {
      _processStripePayment(snapshot);
    } else {
      OrderResult orderResult = await widget.homeBloc.placeOrder();
      if (orderResult.result == 'success') {
        if (widget.homeBloc.formData['payment_method'] == 'cod' ||
            widget.homeBloc.formData['payment_method'] == 'wallet' ||
            widget.homeBloc.formData['payment_method'] == 'cheque' ||
            widget.homeBloc.formData['payment_method'] == 'bacs' ||
            widget.homeBloc.formData['payment_method'] == 'paypalpro') {
          orderDetails(orderResult);
          setState(() {
            isLoading = false;
          });
        } else if (widget.homeBloc.formData['payment_method'] == 'payuindia' ||
            widget.homeBloc.formData['payment_method'] == 'paytm') {
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
          //Navigator.push(context, MaterialPageRoute(builder: (context) => PaytmPage()));
        } else if (widget.homeBloc.formData['payment_method'] == 'woo_mpgs') {
          bool status = await widget.homeBloc
              .processCredimaxPayment(orderResult.redirect);
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
        } else if (widget.homeBloc.formData['payment_method'] == 'razorpay') {
          openWebView(orderResult.redirect);
          //processRazorPay(snapshot, orderResult); // Uncomment this for SDK Payment
          //openWebView(orderResult.redirect); // Uncomment this for Webview Payment
        } else if (widget.homeBloc.formData['payment_method'] == 'paystack') {
          openWebView(orderResult.redirect);
          //processPayStack(snapshot, orderResult); // Uncomment this for SDK Payment
          //openWebView(orderResult.redirect); // Uncomment this for Webview Payment
        } else {
          openWebView(orderResult.redirect);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        // Order result is faliure
      }
    }
  }

  /// PayStack Payment.
  Future<void> processPayStack(
      AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) async {
    var orderId = getOrderIdFromUrl(orderResult.redirect);
    var publicKey = snapshot.data.paymentMethods
        .singleWhere((method) => method.id == 'paystack')
        .payStackPublicKey;
    await PaystackPlugin.initialize(publicKey: publicKey);
    setState(() {
      isLoading = false;
    });
    Charge charge = Charge()
      ..amount = num.parse(snapshot.data.totalsUnformatted.total).round() * 100
      ..reference = orderId
      ..email = widget.homeBloc.formData['billing_email'];
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.message == 'success') {}
  }

  /// RazorPay Payment.
  Future<void> processRazorPay(
      AsyncSnapshot<OrderReviewModel> snapshot, OrderResult orderResult) {
    /*
    var orderId = getOrderIdFromUrl(orderResult.redirect);
    Razorpay _razorPay;
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS"+response.paymentId);
      orderDetails(orderResult);
    });
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': snapshot.data.paymentMethods.singleWhere((method) => method.id == 'razorpay').settings.razorPayKeyId,
      'amount': num.parse(snapshot.data.totalsUnformatted.total) * 100,
      'name': widget.homeBloc.formData['billing_name'],
      'description': 'Payment for Order' + orderId,
      'profile': {'contact': '', 'email': widget.homeBloc.formData['billing_email'],
        'external': {
          'wallets': ['paytm']
        }}
    };
    try{
      _razorPay.open(options);
      setState(() { isLoading = false; });
    }
    catch(e){
      setState(() { isLoading = false; });
      debugPrint(e);
    }*/
  }

  /*void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "SUCCESS"+response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "ERROR"+response.code.toString()+ '-' + response.message) ;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET" + response.walletName);
  }*/

  Future<void> _processStripePayment(
      AsyncSnapshot<OrderReviewModel> snapshot) async {
    String stripePublicKey = snapshot.data.paymentMethods
        .singleWhere((method) => method.id == 'stripe')
        .stripePublicKey;

    StripePayment.setOptions(StripeOptions(
        publishableKey: stripePublicKey,
        merchantId: "Test",
        androidPayMode: 'test'));

    Charge charge = Charge()
      ..amount = num.parse(snapshot.data.totalsUnformatted.total).round()
      ..email = widget.homeBloc.formData['billing_email'];

    PaymentCard paymentMethod = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CheckoutWidget(
              charge: charge,
              fullscreen: false,
              total: snapshot.data.totals.total,
              logo: Container(
                child:
                    Image.asset('lib/assets/images/stripe_logo_slate_sm.png'),
              ),
            ));
    if (paymentMethod != null) {
      var stripeTokenParams = new Map<String, dynamic>();

      stripeTokenParams['key'] = stripePublicKey;
      stripeTokenParams['payment_user_agent'] =
          'stripe.js/477704d9; stripe-js-v3/477704d9';
      stripeTokenParams['card[number]'] = paymentMethod.number.toString();
      stripeTokenParams['card[cvc]'] = paymentMethod.cvc.toString();
      stripeTokenParams['card[exp_month]'] =
          paymentMethod.expiryMonth.toString();
      stripeTokenParams['card[exp_year]'] = paymentMethod.expiryYear.toString();
      stripeTokenParams['card[name]'] =
          widget.homeBloc.formData['billing_last_name'];
      stripeTokenParams['card[address_line1]'] =
          widget.homeBloc.formData['billing_address_1'] != null
              ? widget.homeBloc.formData['billing_address_1']
              : '';
      stripeTokenParams['card[address_line2]'] =
          widget.homeBloc.formData['billing_address_2'] != null
              ? widget.homeBloc.formData['billing_address_2']
              : '';
      stripeTokenParams['card[address_state]'] =
          widget.homeBloc.formData['billing_state'] != null
              ? widget.homeBloc.formData['billing_state']
              : '';
      stripeTokenParams['card[address_city]'] =
          widget.homeBloc.formData['billing_city'] != null
              ? widget.homeBloc.formData['billing_city']
              : '';
      stripeTokenParams['card[address_zip]'] =
          widget.homeBloc.formData['billing_postcode'] != null
              ? widget.homeBloc.formData['billing_postcode']
              : '';
      stripeTokenParams['card[address_country]'] =
          widget.homeBloc.formData['billing_country'] != null
              ? widget.homeBloc.formData['billing_country']
              : '';

      StripeTokenModel stripeToken =
          await widget.homeBloc.getStripeToken(stripeTokenParams);

      var stripeSourceParams = new Map<String, dynamic>();
      stripeSourceParams['type'] = 'card';
      stripeSourceParams['token'] = stripeToken.id;
      stripeSourceParams['key'] = stripeTokenParams['key'];

      StripeSourceModel stripeSource =
          await widget.homeBloc.getStripeSource(stripeSourceParams);

      widget.homeBloc.formData['stripe_source'] = stripeSource.id;
      widget.homeBloc.formData['wc-stripe-payment-token'] = 'new';

      OrderResult orderResult = await widget.homeBloc.placeOrder();

      orderDetails(orderResult);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setError(dynamic error) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(error.toString())));
    setState(() {
      _error = error.toString();
    });
  }
}
