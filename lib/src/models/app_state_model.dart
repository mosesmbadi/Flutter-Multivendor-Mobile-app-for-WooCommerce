import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/wc_api.dart';
import './category_model.dart';
import '../functions.dart';
import '../models/cart/cart_model.dart';
import '../resources/api_provider.dart';
import 'attributes_model.dart';
import 'blocks_model.dart';
import 'checkout/delivery_date.dart';
import 'customer_model.dart';
import 'errors/error.dart';
import 'errors/register_error.dart';
import 'product_addons_model.dart';
import 'product_model.dart';

class AppStateModel extends Model {

  static final AppStateModel _appStateModel = new AppStateModel._internal();

  factory AppStateModel() {
    return _appStateModel;
  }

  AppStateModel._internal();

  SelectedPage selectedPage = new SelectedPage(type: 'home', name: 'Home', id: 0);

  BlocksModel blocks;
  Locale appLocale = Locale('en');
  static WooCommerceAPI wc_api = new WooCommerceAPI();
  List<ProductAddonsModel> productAddons = [];
  final apiProvider = ApiProvider();
  CartModel shoppingCart = CartModel(cartContents: new List<CartContent>(), cartTotals: CartTotals());
  int count = 0;
  bool isCartLoading = false;
  bool loggedIn = false;
  List<int> wishListIds = [];
  double maxPrice = 1000000;
  var selectedRange = RangeValues(0, 1000000);
  String selectedCurrency = 'USD';
  int page = 1;
  var filter = new Map<String, dynamic>();
  bool hasMoreRecentItem = true;
  List<String> isVendor = ['seller', 'wcfm_vendor', 'dc_vendor', 'administrator'];
  bool loginLoading = false;
  List<Category> subCategories = [];
  List<Category> mainCategories = [];
  Map<String, dynamic> customerLocation = {};
  bool hasSeenIntro;
  String oneSignalPlayerId;
  String fcmToken;
  bool loading = false;

  //For delivery Date time
  DeliveryDate deliveryDate = DeliveryDate();
  Map<String, DeliveryTime> deliverySlot = Map<String, DeliveryTime>();
  String selectedDate;
  String selectedDateFormatted;
  String selectedTime;

  getLocalData() async {

    var prefs = await SharedPreferences.getInstance();
    hasSeenIntro = prefs.getBool('hasSeenIntro');
    if (prefs.getString('language_code') != null) {
      appLocale = Locale(prefs.getString('language_code'));
    }
    apiProvider.filter['lan'] = appLocale.languageCode;

    Map<String, dynamic> location = prefs.getString('customerLocation') != null ? json.decode(prefs.getString('customerLocation')) : {};
    if(location != null && location['latitude'] != null && location['longitude'] != null) {
      customerLocation['address'] = location['address'];
      customerLocation['latitude'] = location['latitude'].toString();
      customerLocation['longitude'] = location['longitude'].toString();
      customerLocation['address'] = customerLocation['address'] != null ? customerLocation['address'] : '';
      apiProvider.filter.addAll({'address': customerLocation['address'], 'latitude': customerLocation['latitude'], 'longitude': customerLocation['longitude']});
      var searchData = new Map<String, String>();
      searchData['wcfmmp_radius_lat'] = customerLocation['latitude'];
      searchData['wcfmmp_radius_lng'] = customerLocation['longitude'];
      var distance = prefs.getString('distance') != null ? json.decode(prefs.getString('distance')) : '10';
      searchData['wcfmmp_radius_range'] = distance.toString();
      apiProvider.filter['search_data'] = Uri(queryParameters: searchData).query;
    }
    notifyListeners();
    return Null;
  }

  fetchAllBlocks() async {
    page = 1;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String blocksString = prefs.getString('blocks');
    String storedCurrency = prefs.getString('currency');
    if (storedCurrency != null &&
        storedCurrency.isNotEmpty &&
        storedCurrency != '0') {
      selectedCurrency = storedCurrency;
      await switchCurrency(storedCurrency);
    }
    if (blocksString != null &&
        blocksString.isNotEmpty &&
        blocksString != '0') {
      try {
        blocks = BlocksModel.fromJson(json.decode(blocksString));
        if(mainCategories.length == 0 || (blocks.categories.where((cat) => cat.parent == 0).toList().length == (mainCategories.length - 1))) {
          mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
          mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: ''));
        }
        notifyListeners();
      } catch (e, s) {}
    }
    final response = await apiProvider.fetchBlocks();

    if (response.statusCode == 200) {
      blocks = BlocksModel.fromJson(json.decode(response.body));
      if(mainCategories.length == 0 || (blocks.categories.where((cat) => cat.parent == 0).toList().length == (mainCategories.length - 1))) {
        mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
        mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: ''));
      }
      user = blocks.user;
      if (user?.id != null && user.id > 0) {
        loggedIn = true;
      }
      //selectedCurrency = blocks.currency; // Uncomment once backend currency switcher is working with WPML
      notifyListeners();
      getCart();

      if(blocks.settings.switchAddons == 1) {
        getProDuctAddons();
      }

      if(blocks.splash != null) {
        //apiProvider.downloadSplashSave(blocks.splash);
      }

      prefs.setString('blocks', response.body);
    } else {
      Fluttertoast.showToast(gravity: ToastGravity.TOP, msg: 'Something is not right!');
    }

  }

  resetAllBlocks() async {
    blocks.stores = [];
    loading = true;
    notifyListeners();
    hasMoreRecentItem = true;
    page = 1;
    final response = await apiProvider.fetchBlocks();
    loading = false;
    if (response.statusCode == 200) {
      blocks = BlocksModel.fromJson(json.decode(response.body));
      if(mainCategories.length == 0 || (blocks.categories.where((cat) => cat.parent == 0).toList().length == mainCategories.length)) {
        mainCategories = blocks.categories.where((cat) => cat.parent == 0).toList();
        mainCategories.insert(0, Category(name: blocks.localeText.all, id: 0,  parent: 0, image: ''));
      }
      user = blocks.user;
      if (user?.id != null && user.id > 0) {
        loggedIn = true;
      }
      //selectedCurrency = blocks.currency; // Uncomment once backend currency switcher is working with WPML
      notifyListeners();
      getCart();
      if(blocks.splash != null) {
        //apiProvider.downloadSplashSave(blocks.splash);
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('blocks', response.body);
    } else {
      Fluttertoast.showToast(gravity: ToastGravity.TOP, msg: 'Something is not right!');
    }
  }

  Future<void> setPickedLocation(Map<String, dynamic> result) async {

    customerLocation = result;
    customerLocation['address'] = customerLocation['address'] != null ? customerLocation['address'] : '';
    apiProvider.filter.addAll({'address': customerLocation['address'], 'latitude': customerLocation['latitude'], 'longitude': customerLocation['longitude']});

    var searchData = new Map<String, String>();
    searchData['wcfmmp_radius_lat'] = customerLocation['latitude'];
    searchData['wcfmmp_radius_lng'] = customerLocation['longitude'];
    searchData['wcfmmp_radius_range'] = blocks.settings.distance;
    apiProvider.filter['search_data'] = Uri(queryParameters: searchData).query;

    loading = true;
    blocks.stores = [];
    notifyListeners();
    resetAllBlocks();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('customerLocation', json.encode(customerLocation));
  }

  loadMoreRecentProducts() async {
    page = page + 1;
    filter['page'] = page.toString();
    final response = await apiProvider.fetchProducts(filter);
    if (response.statusCode == 200) {
      List<Product> products = productModelFromJson(response.body);
      blocks.recentProducts.addAll(products);
      if (products.length == 0) {
        hasMoreRecentItem = false;
      }
      notifyListeners();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // WishList
  Future<void> updateWishList(int id) async {
    if(wishListIds.contains(id)) {
      wishListIds.remove(id);
      notifyListeners();
      apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-remove_wishlist' , {'product_id': id.toString()});
    } else {
      wishListIds.add(id);
      notifyListeners();
      apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-add_wishlist' , {'product_id': id.toString()});
    }
  }

  //Account
  Customer user = new Customer( email: '');

  Future<bool> login(Map<String, dynamic> data, BuildContext context) async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-login', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> googleLogin(data, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-google_login', data);
    loginLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> appleLogin(data) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter_apple_login', data);
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> phoneLogin(data, BuildContext context) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter_otp_verification', data);
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> facebookLogin(token) async {
    loginLoading = true;
    notifyListeners();
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-facebook_login', {'access_token': token});
    loginLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      WpErrors error = WpErrors.fromJson(json.decode(response.body));
      Fluttertoast.showToast(msg: parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future<bool> register(data, BuildContext context) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-create-user', data);
    if (response.statusCode == 200) {
      user = Customer.fromJson(json.decode(response.body));
      if(user.id != null && user.id > 0) {
        _updatePushData();
        loggedIn = true;
      }
      notifyListeners();
      return true;
    } else if (response.statusCode == 400) {
      RegisterError error = RegisterError.fromJson(json.decode(response.body));
      showSnackBarError(context, parseHtmlString(error.data[0].message));
      return false;
    } else {
      return false;
    }
  }

  Future logout() async {
    user = new Customer(id: 0);
    wishListIds = [];
    loggedIn = false;
    notifyListeners();
    final response = await apiProvider.get(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-logout');

  }

  //Shopping Cart
  /*Future<bool> addToCart(data) async {

    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-add_to_cart', data);
    
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
      return true;
    } else {
      AddToCartErrorModel addToCartError = addToCartErrorModelFromJson(response.body);
      Fluttertoast.showToast(msg: addToCartError.data.notice);
    }
  }*/

  //Shopping Cart
  Future<bool> addToCart(data) async {

    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_add_product_to_cart', data);
    
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
      return true;
    } else {
      Notice notice = noticeFromJson(response.body);
      Fluttertoast.showToast(msg: parseHtmlString(notice.data[0].notice));
    }
  }

  void getCart() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-cart', Map());
    isCartLoading = false;
    notifyListeners();
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
  }

  void updateCartCount() {
    count = 0;
    if(shoppingCart.cartContents != null) {
      for (var i = 0; i < shoppingCart.cartContents.length; i++) {
        count = count + shoppingCart.cartContents[i].quantity;
      }
    }
    isCartLoading = false;
    notifyListeners();
  }

  Future<void> applyCoupon(String couponCode) async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-apply_coupon', {"coupon_code": couponCode});
    if (response.statusCode == 200) {
      getCart();
      Fluttertoast.showToast(gravity: ToastGravity.TOP, msg: parseHtmlString(jsonDecode(response.body)));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  Future increaseQty(String key, int quantity) async {
    quantity = quantity + 1;
    var formData = new Map<String, String>();
    formData['cart[' + key + '][qty]'] = quantity.toString();
    formData['key'] = key;
    formData['quantity'] = quantity.toString();
    formData['_wpnonce'] = shoppingCart.cartNonce;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-update-cart-item-qty', formData);
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      return false;
      //throw Exception('Failed to load cart');
    }
    return true;
  }

  Future decreaseQty(String key, int quantity) async {
    quantity = quantity - 1;
    var formData = new Map<String, String>();
    formData['cart[' + key + '][qty]'] = quantity.toString();
    formData['key'] = key;
    formData['quantity'] = quantity.toString();
    formData['_wpnonce'] = shoppingCart.cartNonce;
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-update-cart-item-qty', formData);
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
    return true;
  }

  // Removes an item from the cart.
  void removeCartItem(CartContent cartContent) {
    if (shoppingCart.cartContents.contains(cartContent)) {
      shoppingCart.cartContents.remove(cartContent);
      if(cartContent.key != null)
        removeItemFromCart(cartContent.key);
    }
    updateCartCount();
  }

  Future removeItemFromCart(String key) async {
    shoppingCart.cartContents.removeWhere((item) => item.key == key);
    notifyListeners();
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-remove_cart_item&item_key=' + key, Map());
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
    } else {
      throw Exception('Failed to load cart');
    }
    updateCartCount();
  }

  Future<bool> switchCurrency(String s) async {
    await apiProvider.post('/wp-admin/admin-ajax.php',
        {'action': 'wcml_switch_currency', 'currency': s, 'force_switch': '0'});
    return true;
  }

  getCustomerDetails() async {
    final response = await apiProvider.postWithCookies(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-customer', new Map());
    //Customer customers = Customer.fromJson(json.decode(response.body));
    //TODO Set is Loggedin if logged in
  }

  getProducts() {

  }

  getProductById(int productId) {
    return shoppingCart.cartContents.firstWhere((p) => p.productId == productId);
  }

  void setPage(String type, int id, String name) {
    selectedPage.type = type;
    selectedPage.id = id;
    selectedPage.name = name;
  }

  updateRangeValue(RangeValues newRange) {
    selectedRange = newRange;
    notifyListeners();
  }

  Future<void> clearCart() async {
    shoppingCart = CartModel(cartContents: new List<CartContent>(), cartTotals: CartTotals());
    notifyListeners();
    final response = await apiProvider
        .get('/wp-admin/admin-ajax.php?action=mstore_flutter-clearCart');
  }

  Future<dynamic> removeCoupon(String code) async {
    var data = new Map<String, String>();
    data['coupon'] = code;
    await apiProvider
        .post('/wp-admin/admin-ajax.php?action=mstore_flutter-remove_coupon', data);
    getCart();
  }

  Future<bool> getCartAfterAddingBalanceToCart() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-cart', Map());
    notifyListeners();
    if (response.statusCode == 200) {
      shoppingCart = CartModel.fromJson(json.decode(response.body));
      updateCartCount();
      return true;
    } else {
      throw Exception('Failed to load cart');
    }
  }

  setSubCategories(int id) {
    subCategories = blocks.categories.where((cat) => cat.parent == id).toList();
    if (subCategories.length != 0) {
      subCategories.insert(0, Category(name: 'All', id: id));
    }
  }


  /// Products ///
  Map<String, List<Product>> products = new Map<String, List<Product>>();
  var productsPage = new Map<String, int>();
  List<AttributesModel> attributes = [];
  var productsFilter = new Map<String, dynamic>();
  var hasMoreItems = new Map<String, dynamic>();
  TabController tabController;

  fetchAllProducts() async {
    if(!products.containsKey(productsFilter['id'])) {
      productsPage[productsFilter['id']] = 1;
      productsFilter['page'] = productsPage[productsFilter['id']].toString();
      products[productsFilter['id']] = await apiProvider.fetchProductList(productsFilter);
    }
    notifyListeners();
  }

  loadMore() async {
    hasMoreItems[productsFilter['id']] = true;
    notifyListeners();
    productsPage[productsFilter['id']] = productsPage[productsFilter['id']] + 1;
    productsFilter['page'] = productsPage[productsFilter['id']].toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(productsFilter);
    products[productsFilter['id']].addAll(moreProducts);
    if(moreProducts.length < 10){
      hasMoreItems[productsFilter['id']] = false;
    }
    notifyListeners();
  }

  Future fetchProductsAttributes() async {
    final response = await apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter-product-attributes', {'category': productsFilter['id'].toString()});
    if (response.statusCode == 200) {
      attributes = filterModelFromJson(response.body);
    } else {
      throw Exception('Failed to load attributes');
    }
    notifyListeners();
  }

  void clearFilter() {
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        attributes[i].terms[j].selected = false;
      }
    }
    fetchAllProducts();
  }

  void applyFilter(int id, double minPrice, double maxPrice) {
    if(products[productsFilter['id']] != null) {
      products[productsFilter['id']].clear();
    }
    productsFilter['min_price'] = minPrice.toString();
    productsFilter['max_price'] = maxPrice.toString();
    if(attributes != null)
    for(var i = 0; i < attributes.length; i++) {
      for(var j = 0; j < attributes[i].terms.length; j++) {
        if(attributes[i].terms[j].selected) {
          productsFilter['attribute_term' + j.toString()] = attributes[i].terms[j].termId.toString();
          productsFilter['attributes' + j.toString()] = attributes[i].terms[j].taxonomy;
        }
      }
    }
    fetchAllProducts();
  }

  void changeCategory(int id) {
    productsFilter['id'] = id.toString();
    fetchAllProducts();
  }

  void setFilter(Map<String, dynamic> filter) {
    productsFilter = filter;
    selectedRange = RangeValues(0, blocks.maxPrice.toDouble());
    notifyListeners();
  }

  setIntroScreenSeen() async {
    hasSeenIntro = true;
    notifyListeners();
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('hasSeenIntro', true);
  }

  Future<void> updateLanguage(String code) async {
    apiProvider.filter['lan'] = code;
    appLocale = Locale(code);
    notifyListeners();
    fetchAllBlocks();
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', code);
  }

  void _updatePushData() {
    var tokens = new Map<String, dynamic>();
    if(oneSignalPlayerId != null && oneSignalPlayerId.isNotEmpty) {
      tokens['onesignal_user_id'] = oneSignalPlayerId;
    } if(fcmToken != null && fcmToken.isNotEmpty) {
      tokens['fcm_token'] = fcmToken;
    }
    apiProvider.post('/wp-admin/admin-ajax.php?action=mstore_flutter_update_user_notification', tokens);
    getCart();
  }

  getProDuctAddons() async {
    final response = await wc_api.getproductAddons("product-add-ons");
    if(response.statusCode == 200) {
      productAddons = productAddonsFromJson(response.body);
      notifyListeners();
    }
  }

}

class SelectedPage {
  int id;
  String type;
  String name;

  SelectedPage({
    this.id,
    this.type,
    this.name,
  });
}