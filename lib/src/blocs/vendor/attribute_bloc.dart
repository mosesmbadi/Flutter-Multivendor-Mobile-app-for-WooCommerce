import 'package:rxdart/rxdart.dart';

import '../../models/vendor/product_attribute_model.dart';
import '../../resources/wc_api.dart';

class AttributeBloc {
  List<ProductAttribute> attributes;
  List<AttributeTerms> terms;

  static WooCommerceAPI wc_api = new WooCommerceAPI();

  final _attributeFetcher = BehaviorSubject<List<ProductAttribute>>();
  final _termsFetcher = BehaviorSubject<List<AttributeTerms>>();

  ValueStream<List<ProductAttribute>> get allAttribute => _attributeFetcher.stream;
  ValueStream<List<AttributeTerms>> get allTerms =>
      _termsFetcher.stream;

  fetchAllAttributes() async {
    final response = await wc_api.getAsync("products/attributes");
    
    attributes = productAttributeFromJson(response.body);

    _attributeFetcher.sink.add(attributes);
  }

  fetchAllTerms(String id) async {
    final response =
        await wc_api.getAsync("products/attributes/" + id + "/terms");
    
    terms = attributeTermsFromJson(response.body);

    _termsFetcher.sink.add(terms);
  }

  dispose() {
    _attributeFetcher.close();
    _termsFetcher.close();
  }
}

String getQueryString(Map params,
    {String prefix: '?', bool inRecursion: false}) {
  String query = '';

  params.forEach((key, value) {
    if (inRecursion) {
      key = '[$key]';
    }

    if (value is String || value is int || value is double || value is bool) {
      query += '$prefix$key=$value';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });

  return query;
}
