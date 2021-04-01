import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import './../models/orders_model.dart';
import './../resources/api_provider.dart';


class OrderSummaryBloc {
  final _orderFetcher = BehaviorSubject<Order>();
  final apiProvider = ApiProvider();

  ValueStream<Order> get order => _orderFetcher.stream;

  getOrder(String id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-order', {'id': id});
    Order newOrder = Order.fromJson(json.decode(response.body));
    _orderFetcher.sink.add(newOrder);
  }

  dispose() {
    _orderFetcher.close();
  }

  Future<void> clearCart() async {
    final response = await apiProvider.get(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-emptyCart');

    //this.api.ajaxCall('/checkout/order-received/'+ this.order.id +'/?key=' + this.order.order_key).then(res => {}, err => {});
  }

  Future<void> thankYou(Order order) async {
    final response = await apiProvider.get('/checkout/order-received/'+ order.id.toString() +'/?key=' + order.orderKey);
  }
}