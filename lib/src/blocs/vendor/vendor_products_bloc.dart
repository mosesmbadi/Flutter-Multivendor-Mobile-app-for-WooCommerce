import 'package:rxdart/rxdart.dart';

import '../../models/attributes_model.dart';
import '../../models/product_model.dart';
import '../../resources/api_provider.dart';

class VendorProductsBloc {

  List<Product> products = [];
  int page = 1;

  var filter = new Map<String, dynamic>();
  var selectedRange;

  final apiProvider = ApiProvider();
  final _productsFetcher = BehaviorSubject<List<Product>>();
  final _attributesFetcher = BehaviorSubject<List<AttributesModel>>();

  String search = "";

  var hasMoreItems = false;

  ValueStream<List<Product>> get allProducts => _productsFetcher.stream;
  ValueStream<List<AttributesModel>> get allAttributes => _attributesFetcher.stream;

  List<AttributesModel> attributes;

  fetchAllProducts([String query]) async {
    filter['page'] = page.toString();
    products = await apiProvider.fetchProductList(filter);
    hasMoreItems = products.length > 9;
    _productsFetcher.sink.add(products);
  }

  loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    products.addAll(moreProducts);
    hasMoreItems = moreProducts.length > 9;
    _productsFetcher.sink.add(products);
  }

  dispose() {
    _productsFetcher.close();
    _attributesFetcher.close();
  }

  void clearFilter() {
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    _attributesFetcher.sink.add(attributes);
    fetchAllProducts();
  }

  void applyFilter(double minPrice, double maxPrice) {
    filter = new Map<String, dynamic>();
    filter['min_price'] = minPrice.toString();
    filter['max_price'] = maxPrice.toString();
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        if(attributes[i].terms[j].selected) {
          filter['attribute_term' + j.toString()] = attributes[i].terms[j].termId.toString();
          filter['attributes' + j.toString()] = attributes[i].terms[j].taxonomy;
        }
      }
    }
    fetchAllProducts();
  }
}