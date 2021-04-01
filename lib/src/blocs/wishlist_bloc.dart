import 'package:rxdart/rxdart.dart';

import '../models/app_state_model.dart';
import '../models/product_model.dart';
import '../resources/api_provider.dart';

class WishListBloc {

  var filter = new Map<String, dynamic>();
  bool hasMoreWishList = false;
  int wishListPage = 0;
  List<Product> wishListProducts = [];

  final apiProvider = ApiProvider();
  final appStateModel = AppStateModel();

  final _hasMoreWishListFetcher = BehaviorSubject<bool>();
  final _wishListFetcher = BehaviorSubject<List<Product>>();

  ValueStream<bool> get hasMoreWishlistItems => _hasMoreWishListFetcher.stream;
  ValueStream<List<Product>> get wishList => _wishListFetcher.stream;

  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  dispose() {
    _hasMoreWishListFetcher.close();
    _wishListFetcher.close();
  }

  getWishList() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-get_wishlist', Map());
    wishListProducts = productModelFromJson(response.body);
    _wishListFetcher.sink.add(wishListProducts);
    appStateModel.wishListIds =
        wishListProducts.map((item) => item.id).toList();
    if (wishListProducts.length < 10) {
      hasMoreWishList = false;
      _hasMoreWishListFetcher.sink.add(hasMoreWishList);
    }
  }

  Future loadMoreWishList() async {
    wishListPage = wishListPage + 1;
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-get_wishlist',
        {'page': wishListPage.toString()});
    List<Product> products = productModelFromJson(response.body);
    wishListProducts.addAll(products);
    _wishListFetcher.sink.add(wishListProducts);
    appStateModel.wishListIds =
        wishListProducts.map((item) => item.id).toList();
    if (products.length == 0 || products.length < 10) {
      hasMoreWishList = false;
      _hasMoreWishListFetcher.sink.add(hasMoreWishList);
    }
  }

  void removeItemFromWishList(int id) {
    wishListProducts.removeWhere((item) => item.id == id);
    _wishListFetcher.sink.add(wishListProducts);
    apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-remove_wishlist',
        {'product_id': id.toString()});
  }

  void addToWishList(int id) {
    apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-add_wishlist',
        {'product_id': id.toString()});
  }
}
