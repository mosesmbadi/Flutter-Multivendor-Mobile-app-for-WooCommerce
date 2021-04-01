import 'dart:convert';

import 'package:rxdart/rxdart.dart';

import './../models/checkout/checkout_form_model.dart';
import '../models/customer_model.dart';
import '../resources/api_provider.dart';

class CustomerBloc {

  var addressFormData = new Map<String, String>();
  final apiProvider = ApiProvider();
  var formData = new Map<String, String>();

  final _customersFetcher = BehaviorSubject<Customer>();
  final _checkoutFormFetcher = BehaviorSubject<CheckoutFormModel>();
  ValueStream<Customer> get customerDetail => _customersFetcher.stream;
  ValueStream<CheckoutFormModel> get checkoutForm => _checkoutFormFetcher.stream;

  void getCheckoutForm() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-get_checkout_form',
        Map()); //formData.toJson();
    if (response.statusCode == 200) {
      CheckoutFormModel checkoutForm =
      CheckoutFormModel.fromJson(json.decode(response.body));
      _checkoutFormFetcher.sink.add(checkoutForm);
    } else {
      throw Exception('Failed to load checkout form');
    }
  }

  getCustomerDetails() async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-customer', new Map());
    Customer customers = Customer.fromJson(json.decode(response.body));
    _customersFetcher.sink.add(customers);
  }

  Future updateAddress() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-update-address',
        addressFormData);
    getCustomerDetails();
  }

  dispose() {
    _customersFetcher.close();
    _checkoutFormFetcher.close();
  }
}
