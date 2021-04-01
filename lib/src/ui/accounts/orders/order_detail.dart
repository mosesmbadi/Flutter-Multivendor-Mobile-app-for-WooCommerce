import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../functions.dart';
import './../../../blocs/orders_bloc.dart';
import './../../../models/app_state_model.dart';
import './../../../models/orders_model.dart';

class OrderDetail extends StatefulWidget {

  AppStateModel appStateModel = AppStateModel();
  final OrdersBloc ordersBloc;
  final Order order;

  OrderDetail({this.order, this.ordersBloc});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {


  final TextStyle _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.currency(
        decimalDigits: widget.order.decimals, locale: Localizations.localeOf(context).toString(), name: widget.order.currency);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appStateModel.blocks.localeText.order)
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            buildOrderDetails(context, formatter),
            buildItemDetails(context, formatter),
            buildTotalDetails(context, formatter),
          ],
        ));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    widget.order.number.toString() + ' - ' + getOrderStatusText(widget.order.status, widget.appStateModel.blocks.localeText),
                  style: Theme.of(context).textTheme.title,
                ),
                widget.order.status == 'pending' ? Container(
                  height: 25,
                  child: OutlineButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () async {
                        widget.ordersBloc.cancelOrder(widget.order);
                        setState(() {
                          widget.order.status = 'cancelled';
                        });
                      }, child: Text('Cancel')
                  ),
                ) : Container()
              ],
            ),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appStateModel.blocks.localeText.billing.toUpperCase(),
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
                    widget.appStateModel.blocks.localeText.shipping.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                      '''${widget.order.shipping.firstName} ${widget.order.shipping.lastName} ${widget.order.shipping.address1} ${widget.order.shipping.address2} ${widget.order.shipping.city} ${widget.order.shipping.country} ${widget.order.shipping.postcode}'''),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.appStateModel.blocks.localeText.payment.toUpperCase(),
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(widget.order.paymentMethodTitle),
                ]),
            Divider(),
            SizedBox(height: 10.0),
            widget.order.lineItems != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        Text(
                          widget.appStateModel.blocks.localeText.products.toUpperCase(),
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
            widget.appStateModel.blocks.localeText.total.toUpperCase(),
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.shipping,),
              ),
              Text(formatter.format((double.parse('${widget.order.shippingTotal}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.tax,),
              ),
              Text(formatter.format((double.parse('${widget.order.totalTax}')))),
            ],
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Text(widget.appStateModel.blocks.localeText.discount),
              ),
              Text(formatter.format((double.parse('${widget.order.discountTotal}')))),
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
                  double.parse(widget.order.total),
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

            String metaData = '';
            widget.order.lineItems[index].metaData.forEach((element) {
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
                          child: Text(widget.order.lineItems[index].name +
                              ' x ' +
                              widget.order.lineItems[index].quantity.toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(formatter.format(
                            (double.parse('${widget.order.lineItems[index].total}')))),
                      ],
                    )),
              ],
            );
          },
          childCount: widget.order.lineItems.length,
        ),
      ),
    );
  }
}
