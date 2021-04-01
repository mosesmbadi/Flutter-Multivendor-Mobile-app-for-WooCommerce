import 'package:scoped_model/scoped_model.dart';

import '../../resources/api_provider.dart';
import 'store_model.dart';

class SearchStoreStateModel extends Model {

  static final SearchStoreStateModel _storeStateModel = new SearchStoreStateModel._internal();

  factory SearchStoreStateModel() {
    return _storeStateModel;
  }

  SearchStoreStateModel._internal();
  final apiProvider = ApiProvider();
  List<StoreModel> stores;
  int page = 1;
  bool loading = false;
  var filter = new Map<String, String>();
  bool hasMoreItems = false;

  getAllStores() async {
    filter['page'] = '1';
    stores = [];
    loading = true;
    notifyListeners();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors', filter);
    loading = false;
    if(filter['search'] != '')
    stores = storeModelFromJson(response.body);
    hasMoreItems = stores.length > 9;
    notifyListeners();
  }

  loadMoreStores() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors',filter);
    List<StoreModel> moreStore = storeModelFromJson(response.body);
    stores.addAll(moreStore);
    hasMoreItems = moreStore.length > 9;
    notifyListeners();
  }

  refresh() async {
    page = 1;
    filter['page'] = page.toString();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-vendors', filter);
    if(filter['search'] != '')
    stores = storeModelFromJson(response.body);
    hasMoreItems = stores.length > 9;
    notifyListeners();
  }

  void emptyStores() {
    stores.clear();
    notifyListeners();
  }

}