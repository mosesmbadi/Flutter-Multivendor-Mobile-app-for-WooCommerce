import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../src/models/app_state_model.dart';
import '../../blocs/order_summary_bloc.dart';
import '../../config.dart';
import '../../functions.dart';
import '../../models/orders_model.dart';
import '../../ui/checkout/webview.dart';

class OrderSummary extends StatefulWidget {
  final String id;
  final appStateModel = AppStateModel();
  final OrderSummaryBloc orderSummary = OrderSummaryBloc();

  OrderSummary({Key key, this.id}) : super(key: key);
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {

  @override
  void initState(){
    super.initState();
    widget.orderSummary.getOrder(widget.id);
    widget.orderSummary.clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false, title: Text(widget.appStateModel.blocks.localeText.order),),
      body: StreamBuilder<Order>(
        stream: widget.orderSummary.order,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data.id != null) {
            final NumberFormat formatter = NumberFormat.currency(
                decimalDigits: snapshot.data.decimals, name: snapshot.data.currency);
            return CustomScrollView(
            slivers: <Widget>[
              buildOrderDetails(snapshot.data, context, formatter),
              buildItemDetails(snapshot.data, context, formatter),
              buildTotalDetails(snapshot.data, context, formatter),
            ],
          );
          } else {
            return Center(child: CircularProgressIndicator(),);
          }
        }
      ));
  }

  Widget buildOrderDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0),
                Text(widget.appStateModel.blocks.localeText.order + (" - " + order.number.toString()),
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(getOrderStatusText(order.status, widget.appStateModel.blocks.localeText),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    order.status == 'pending' ? RaisedButton(
                      onPressed: () {
                        Config config = Config();
                        String url = config.url + '/checkout/order-pay/' + order.number.toString()  + '/?key=' + order.orderKey;
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>
                            WebViewPage(
                                url: url, selectedPaymentMethod: order.paymentMethod
                            )
                        ));
                      },
                      child: Text('Try Again'),
                    ) : Container()
                  ],
                ),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.billing,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(height: 10.0),
                      Text(
                          '''${order.billing.firstName} ${order.billing.lastName} ${order.billing.address1} ${order.billing.address2} ${order.billing.city} ${order.billing.country} ${order.billing.postcode}'''),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.shipping,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          '''${order.shipping.firstName} ${order.shipping.lastName} ${order.shipping.address1} ${order.shipping.address2} ${order.shipping.city} ${order.shipping.country} ${order.shipping.postcode}'''),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.payment,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(order.paymentMethodTitle),
                    ]),
                Divider(),
                SizedBox(height: 10.0),
                order.lineItems != null
                    ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.appStateModel.blocks.localeText.items,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ])
                    : Container(),
              ],
            ),
          )
        ]));
  }

  buildTotalDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Divider(),
              SizedBox(height: 10.0),
              Text(
                widget.appStateModel.blocks.localeText.total,
                style: Theme.of(context).textTheme.subtitle,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.shipping),
                  ),
                  Text(formatter.format((double.parse('${order.shippingTotal}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.tax),
                  ),
                  Text(formatter.format((double.parse('${order.totalTax}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(widget.appStateModel.blocks.localeText.discount),
                  ),
                  Text(formatter.format((double.parse('${order.discountTotal}')))),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.appStateModel.blocks.localeText.total,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Text(
                    formatter.format(
                      double.parse(order.total),
                    ),
                    style: Theme.of(context).textTheme.title,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
                      onPressed: () {
                        widget.appStateModel.getCart();
                        widget.orderSummary.thankYou(order);
                        Navigator.of(context).pop();
                        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                        //onSuccessMessage(order);
                      },
                    ),
                  ),
                ],
              ),
            ]),
          )
        ]));
  }

  buildItemDetails(Order order, BuildContext context, NumberFormat formatter) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {

                String metaData = '';
                order.lineItems[index].metaData.forEach((element) {
                  if(element.value is String)
                    metaData = element.key + '-' + element.value + '.';
                });

            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(order.lineItems[index].name +
                              ' x ' +
                              order.lineItems[index].quantity.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(
                            (double.parse('${order.lineItems[index].total}')))),
                      ],
                    )),
              ],
            );
          },
          childCount: order.lineItems.length,
        ),
      ),
    );
  }

  void onSuccessMessage(Order order) {
    showDialog(context: context,
        barrierDismissible: false,
        // ignore: deprecated_member_use
        child: AlertDialog(
          title: new Text(widget.appStateModel.blocks.localeText.youOrderHaveBeenReceived),
          content: new Text(widget.appStateModel.blocks.localeText.thankYouForShoppingWithUs+'!'+widget.appStateModel.blocks.localeText.thankYouOrderIdIs+':'+' #${order.id.toString()}. '+ widget.appStateModel.blocks.localeText.youWillReceiveAConfirmationMessage+'.'),
          actions: <Widget>[
            RaisedButton(
                elevation: 0,
                child: Text(widget.appStateModel.blocks.localeText.localeTextContinue),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
                }
            )
          ],
        )
    );
  }

}

