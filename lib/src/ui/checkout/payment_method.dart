import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../blocs/checkout_bloc.dart';
import '../../functions.dart';
import '../../models/app_state_model.dart';
import '../../models/checkout/order_result_model.dart';
import '../../models/checkout/order_review_model.dart';
import '../../ui/checkout/webview.dart';
import 'order_summary.dart';

class ShippingPayment extends StatefulWidget {
  final CheckoutBloc homeBloc;
  final appStateModel = AppStateModel();
  ShippingPayment({Key key, this.homeBloc}) : super(key: key);

  @override
  _ShippingPaymentState createState() => _ShippingPaymentState();
}

class _ShippingPaymentState extends State<ShippingPayment> {
  String _selectedPaymentMethod = 'cod';

  @override
  void initState() {
    widget.homeBloc.updateOrderReview();
    widget.homeBloc.orderResult.listen((result) => processOrder(result));
    super.initState();
  }

  void handlePaymentMethodChanged(String value) {
    widget.homeBloc.choosePayment(value);
    setState(() {
      _selectedPaymentMethod = value;
    });
    widget.homeBloc.formData['payment_method'] = value;
  }

  void handleShippingMethodChanged(String value) {
    widget.homeBloc.chooseShipping(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(widget.appStateModel.blocks.localeText.checkout,),
      ),
      body: StreamBuilder<OrderReviewModel>(
          stream: widget.homeBloc.orderReview,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                widget.homeBloc.orderReviewData.paymentMethods != null) {
              for (var i = 0;
                  i < widget.homeBloc.orderReviewData.paymentMethods.length;
                  i++) {
                if (widget.homeBloc.orderReviewData.paymentMethods[i].chosen ==
                    true) {
                  _selectedPaymentMethod =
                      widget.homeBloc.orderReviewData.paymentMethods[i].id;
                }
              }
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: snapshot.hasData
                  ? CustomScrollView(slivers: <Widget>[
                      snapshot.data.shipping.length != 0
                          ? SliverToBoxAdapter(
                              child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                widget.appStateModel.blocks.localeText.shipping,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ))
                          : SliverToBoxAdapter(),
                      snapshot.data.shipping.length != 0
                          ? ShippingMethods(
                              shipping: snapshot.data.shipping,
                              handleShippingMethodChanged:
                                  handleShippingMethodChanged)
                          : SliverToBoxAdapter(),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.appStateModel.blocks.localeText.payment,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      )),
                      PaymentMethods(
                          methods: snapshot.data.paymentMethods,
                          handlePaymentMethodChanged:
                              handlePaymentMethodChanged,
                          selectedPaymentMethod: _selectedPaymentMethod),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              RaisedButton(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                ),
                                padding: EdgeInsets.all(12.0),
                                onPressed: () {
                                  widget.homeBloc.placeOrder();
                                },
                                child: StreamBuilder<bool>(
                                    stream: widget.homeBloc.placingOrder,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data == true) {
                                        return Container(
                                            width: 17,
                                            height: 17,
                                            child: CircularProgressIndicator(
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(Colors.white),
                                                strokeWidth: 2.0));
                                      } else {
                                        return Text(widget.appStateModel.blocks.localeText.localeTextContinue);
                                      }
                                    }),
                              ),
                              StreamBuilder<OrderResult>(
                                  stream: widget.homeBloc.orderResult,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data.result == "failure") {
                                      return Center(
                                        child: Container(
                                            padding: EdgeInsets.all(4.0),
                                            child: Text(
                                                parseHtmlString(
                                                    snapshot.data.messages),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .errorColor))),
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
                      ),
                    ])
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            );
          }),
    );
  }

  openWebView(String url) {
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
      WebViewPage(
        url: url, selectedPaymentMethod: _selectedPaymentMethod
      )
    ));
  }

  processOrder(OrderResult orderResult) async {
    if (orderResult.result == 'success') {
      if (_selectedPaymentMethod == 'cod' ||
          _selectedPaymentMethod == 'wallet' ||
          _selectedPaymentMethod == 'cheque' ||
          _selectedPaymentMethod == 'bacs' ||
          _selectedPaymentMethod == 'paypalpro' ||
          _selectedPaymentMethod == 'stripe') {
        orderDetails(orderResult);
      } else if (_selectedPaymentMethod == 'payuindia' ||
          _selectedPaymentMethod == 'paytm') {
        openWebView(orderResult.redirect);
      } else if (_selectedPaymentMethod == 'woo_mpgs'){
        bool status = await widget.homeBloc.processCredimaxPayment(orderResult.redirect);
        openWebView(orderResult.redirect);
      } else {
        openWebView(orderResult.redirect);
      }
    } else {
      // Order result is faliure
    }
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
}

class ShippingMethods extends StatefulWidget {
  final List<Shipping> shipping;
  final Function(String value) handleShippingMethodChanged;
  ShippingMethods({
    Key key,
    this.shipping,
    this.handleShippingMethodChanged,
  }) : super(key: key);

  @override
  _ShippingMethodsState createState() => _ShippingMethodsState();
}

class _ShippingMethodsState extends State<ShippingMethods> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Radio<String>(
                value: widget.shipping[0].shippingMethods[index].id,
                groupValue: widget.shipping[0].chosenMethod,
                onChanged: widget.handleShippingMethodChanged,
              ),
              Text(widget.shipping[0].shippingMethods[index].label)
            ],
          );
        },
        childCount: widget.shipping[0].shippingMethods.length,
      ),
    );
  }
}

class PaymentMethods extends StatefulWidget {
  void Function(String value) handlePaymentMethodChanged;
  String selectedPaymentMethod;
  List<WooPaymentMethod> methods;
  PaymentMethods({
    Key key,
    this.handlePaymentMethodChanged,
    this.selectedPaymentMethod,
    this.methods,
  }) : super(key: key);
  @override
  _PaymentMethodsState createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Row(
            children: <Widget>[
              Radio<String>(
                value: widget.methods[index].id,
                groupValue: widget.selectedPaymentMethod,
                onChanged: widget.handlePaymentMethodChanged,
              ),
              Text(widget.methods[index].title),
              Divider(
                height: 5,
              ),
            ],
          );
        },
        // Or, uncomment the following line:
        childCount: widget.methods.length,
      ),
    );
  }
}