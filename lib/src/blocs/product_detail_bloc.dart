import '../../src/models/product_model.dart';
import 'dart:convert';
import './../models/releated_products.dart';
import './../models/review_model.dart';
import './../resources/api_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc {

  final apiProvider = ApiProvider();
  final _relatedProductFetcher = BehaviorSubject<ReleatedProductsModel>();
  final _reviewsFetcher = BehaviorSubject<List<ReviewModel>>();

  ValueStream<ReleatedProductsModel> get relatedProducts => _relatedProductFetcher.stream;
  ValueStream<List<ReviewModel>> get allReviews => _reviewsFetcher.stream;

  void getProductsDetails(int id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-product_details', {'product_id': id.toString()});
    if (response.statusCode == 200) {
      ReleatedProductsModel productsList = releatedProductsFromJson(response.body);
      _relatedProductFetcher.sink.add(productsList);
    } else {
      throw Exception('Failed to load related products');
    }
  }

  void getReviews(int id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-product_reviews', {'product_id': id.toString()});
    if (response.statusCode == 200) {
      List<ReviewModel> reviews = reviewModelFromJson(response.body);
      _reviewsFetcher.sink.add(reviews);
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  dispose() {
    _relatedProductFetcher.close();
    _reviewsFetcher.close();
  }

  getProduct(int id) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-product', {'product_id': id.toString()});
    if (response.statusCode == 200) {
      Product product = Product.fromJson(json.decode(response.body));
      return product;
    } else {
      throw Exception('Failed to load products');
    }
  }

  getProductBySKU(String sku) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-product', {'sku': sku});
    
    if (response.statusCode == 200) {
      Product product = Product.fromJson(json.decode(response.body));
      return product;
    } else {
      throw Exception('Failed to load products');
    }
  }

}