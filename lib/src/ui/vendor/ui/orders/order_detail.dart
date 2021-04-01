import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../blocs/vendor/vendor_bloc.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/orders_model.dart';
import 'edit_order.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  final VendorBloc vendorBloc;
  final appStateModel = AppStateModel();
  OrderDetail({this.order, this.vendorBloc});

  @override
  _OrderDetailState createState() => _OrderDetailState(order: order);
}

class _OrderDetailState extends State<OrderDetail> {
  final Order order;

  _OrderDetailState({this.order});

  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: widget.order.decimals,
        locale: Localizations.localeOf(context).toString(),
        name: widget.order.currency);
    return Scaffold(
      appBar: AppBar(
        
        title: Text("Order"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => widget.vendorBloc.deleteOrder(order),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          buildOrderDetails(context, formatter),
          buildItemDetails(context, formatter),
          buildTotalDetails(context, formatter),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EditOrder(
                    vendorBloc: widget.vendorBloc,
                    order: order,
                  )),
        ),
        tooltip: 'Edit',
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget buildOrderDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Order" + ' - ' + order.id.toString(),
              style: Theme.of(context).textTheme.title,
            ),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Billing",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      '''${widget.order.billing.firstName} ${widget.order.billing.lastName} ${widget.order.billing.address1} ${widget.order.billing.address2} ${widget.order.billing.city} ${widget.order.billing.country} ${widget.order.billing.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Shipping",
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
                    "Payment",
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
                          "Items",
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

  buildTotalDetails(BuildContext context, NumberFormat formatter) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Divider(),
          SizedBox(height: 10.0),
          Text(
            "Total",
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text("Shipping"),
              ),
              Text(formatter.format((double.parse('${order.shippingTotal}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(
                  widget.appStateModel.blocks.localeText.tax,
                ),
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
        ]),
      )
    ]));
  }

  buildItemDetails(BuildContext context, NumberFormat formatter) {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(order.lineItems[index].name +
                              ' x ' +
                              order.lineItems[index].quantity.toString()),
                        ),
                        Text(formatter.format(
                            (double.parse('${order.lineItems[index].total}')))),
                      ],
                    ),
                    height: 50),
              ],
            );
          },
          childCount: order.lineItems.length,
        ),
      ),
    );
  }
}
