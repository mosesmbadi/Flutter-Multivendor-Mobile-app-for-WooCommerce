import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import './../models/product_model.dart';
import './../resources/api_provider.dart';

class SearchBloc with ChangeNotifier {
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool moreItems = true;
  final apiProvider = ApiProvider();
  List<Product> products;

  final _hasMoreSearchItemsFetcher = BehaviorSubject<bool>();
  final _searchLoadingFetcher = BehaviorSubject<bool>();
  final _searchFetcher = BehaviorSubject<List<Product>>();

  ValueStream<List<Product>> get searchResults => _searchFetcher.stream;
  ValueStream<bool> get hasMoreItems => _hasMoreSearchItemsFetcher.stream;
  ValueStream<bool> get searchLoading => _searchLoadingFetcher.stream;

  fetchSearchResults(String query) async {
    filter['q'] = query.toString();
    page = 1;
    _searchLoadingFetcher.sink.add(true);
    final response = await apiProvider.fetchProducts(filter);
    _searchLoadingFetcher.sink.add(false);
    if (response.statusCode == 200) {
      products = productModelFromJson(response.body);
      _searchFetcher.sink.add(products);
      if (products.length == 0) {
        moreItems = false;
        _hasMoreSearchItemsFetcher.sink.add(moreItems);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  loadMoreSearchResults(String query) async {
    filter['q'] = query.toString();
    page = page + 1;
    filter['page'] = page.toString();
    _hasMoreSearchItemsFetcher.sink.add(true);
    final response = await apiProvider.fetchProducts(filter);
    if (response.statusCode == 200) {
      List<Product> moreProducts = productModelFromJson(response.body);
      products.addAll(moreProducts);
      _searchFetcher.sink.add(products);
      if (moreProducts.length == 0) {
        _hasMoreSearchItemsFetcher.sink.add(false);
      }
    } else {
      throw Exception('Failed to load products');
    }
  }

  dispose() {
    _hasMoreSearchItemsFetcher.close();
    _searchFetcher.close();
    _searchLoadingFetcher.close();
  }
}
