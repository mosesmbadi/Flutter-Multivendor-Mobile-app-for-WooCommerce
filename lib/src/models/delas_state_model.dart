import 'package:scoped_model/scoped_model.dart';

import '../../src/resources/api_provider.dart';
import 'product_model.dart';

class DealsStateModel extends Model {

  static final DealsStateModel _dealsStateModel = new DealsStateModel._internal();

  factory DealsStateModel() {
    return _dealsStateModel;
  }

  DealsStateModel._internal();

  final apiProvider = ApiProvider();
  List<Product> products;
  var filter = new Map<String, dynamic>();
  int page = 1;
  bool hasMoreItems = true;

  fetchDealProducts() async {
    if (products == null) {
      page = 1;
      filter = {'on_sale': '1', 'random': 'rand', 'page': '1'};
      products = await apiProvider.fetchProductList(filter);
      if (products.length < 10) {
        hasMoreItems = false;
      }
      notifyListeners();
    }
  }

  loadMoreDealsProduct() async {
    page = page + 1;
    filter['page'] = page.toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    products.addAll(moreProducts);
    if (products.length < 10) {
      hasMoreItems = false;
    }
    notifyListeners();
  }

  refresh() async {
    page = 1;
    filter = {'on_sale': '1', 'random': 'rand', 'page': '1'};
    products = await apiProvider.fetchProductList(filter);
    if (products.length < 10) {
      hasMoreItems = false;
    }
    notifyListeners();
    return true;
  }

}