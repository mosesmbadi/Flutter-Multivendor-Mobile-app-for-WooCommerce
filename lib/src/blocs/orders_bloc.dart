import 'dart:convert';

import 'package:flutter/cupertino.dart';
import '../models/customer_model.dart';
import '../models/errors/error.dart';
import '../models/errors/register_error.dart';
import '../models/orders_model.dart';
import '../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc {

  final apiProvider = ApiProvider();
  List<Order> orders;
  bool hasMoreOrders = true;
  int ordersPage = 0;
  var addressFormData = new Map<String, String>();

  final _errorFetcher = BehaviorSubject<WpErrors>();
  final _registerErrorFetcher = BehaviorSubject<RegisterError>();
  final _isLoginLoadingFetcher = BehaviorSubject<String>();
  var _hasMoreOrdersFetcher = BehaviorSubject<bool>();

  ValueStream<WpErrors> get error => _errorFetcher.stream;
  ValueStream<String> get isLoginLoading => _isLoginLoadingFetcher.stream;
  ValueStream<RegisterError> get registerError => _registerErrorFetcher.stream;
  ValueStream<bool> get hasMoreOrderItems => _hasMoreOrdersFetcher.stream;

  final _ordersFetcher = BehaviorSubject<List<Order>>();
  ValueStream<List<Order>> get allOrders => _ordersFetcher.stream;

  final _customersFetcher = BehaviorSubject<Customer>();
  ValueStream<Customer> get customerDetail => _customersFetcher.stream;

  getOrders() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-orders', Map());
    orders = orderFromJson(response.body);
    _ordersFetcher.sink.add(orders);
    _hasMoreOrdersFetcher.sink.add(true);
  }

  void loadMoreOrders() async {
    ordersPage = ordersPage + 1;
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-orders',
        {'page': ordersPage.toString()});
    List<Order> moreOrders = orderFromJson(response.body);
    orders.addAll(moreOrders);
    _ordersFetcher.sink.add(orders);
    if (moreOrders.length == 0) {
      hasMoreOrders = false;
      _hasMoreOrdersFetcher.sink.add(false);
    }
  }

  dispose() {
    _errorFetcher.close();
    _registerErrorFetcher.close();
    _isLoginLoadingFetcher.close();
    _customersFetcher.close();
    _ordersFetcher.close();
    _hasMoreOrdersFetcher.close();
  }

  Future<bool> cancelOrder(Order order) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-cancel_order',
        {'id': order.id.toString()});
    print(response.statusCode);
    if(response.statusCode == 200) {
      Order newOrder = Order.fromJson(json.decode(response.body));
      int index = orders.indexOf(order);
      orders[index] = newOrder;
      _ordersFetcher.sink.add(orders);
    }
    return true;
  }
}
