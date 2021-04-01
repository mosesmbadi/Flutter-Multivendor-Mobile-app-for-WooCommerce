import 'package:rxdart/rxdart.dart';

import './../resources/api_provider.dart';
import '../models/product_model.dart';

class DealsBloc {
  List<Product> dealsProducts;
  var dealsFilter = new Map<String, dynamic>();
  int dealsPage = 0;

  final apiProvider = ApiProvider();
  final _dealsProductsFetcher = BehaviorSubject<List<Product>>();
  final _hasMoreDealsFetcher = BehaviorSubject<bool>();
  final _isLoadingDealsFetcher = BehaviorSubject<bool>();

  ValueStream<List<Product>> get allDealsProducts =>
      _dealsProductsFetcher.stream;
  ValueStream<bool> get hasMoreDealsItems => _hasMoreDealsFetcher.stream;
  ValueStream<bool> get isLoadingDealsProducts => _isLoadingDealsFetcher.stream;

  fetchAllProducts([String query]) async {
    dealsPage = dealsPage + 1;
    dealsFilter['on_sale'] = '1';
    dealsFilter['random'] = 'rand';
    dealsFilter['page'] = dealsPage.toString();
    _hasMoreDealsFetcher.sink.add(true);
    _isLoadingDealsFetcher.sink.add(true);
    _dealsProductsFetcher.sink.add([]);
    dealsProducts = await apiProvider.fetchProductList(dealsFilter);
    _dealsProductsFetcher.sink.add(dealsProducts);
    _isLoadingDealsFetcher.sink.add(false);
    if (dealsProducts.length < 10) {
      _hasMoreDealsFetcher.sink.add(false);
    }
  }

  loadMore() async {
    dealsPage = dealsPage + 1;
    dealsFilter['page'] = dealsPage.toString();
    List<Product> moreProducts =
        await apiProvider.fetchProductList(dealsFilter);
    dealsProducts.addAll(moreProducts);
    _dealsProductsFetcher.sink.add(dealsProducts);
    if (moreProducts.length < 10) {
      _hasMoreDealsFetcher.sink.add(false);
    }
  }

  dispose() {
    _dealsProductsFetcher.close();
    _hasMoreDealsFetcher.close();
    _isLoadingDealsFetcher.close();
  }
}
