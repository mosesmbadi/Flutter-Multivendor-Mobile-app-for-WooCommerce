import 'package:scoped_model/scoped_model.dart';

import '../../models/product_model.dart';
import '../../models/vendor/vendor_details_model.dart';
import '../../models/vendor/vendor_reviews_model.dart';
import '../../resources/api_provider.dart';

class VendorDetailStateModel extends Model {
  List<Product> products;
  List<VendorReviews> reviews;
  VendorDetailsModel vendorDetails;
  int page = 1;
  int reviewPage = 1;
  var reviewsFilter = new Map<String, dynamic>();
  var filter = new Map<String, String>();
  bool hasMoreItems = false;

  final apiProvider = ApiProvider();

  void getDetails() async {
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-vendor_details',
        filter);
    if (response.statusCode == 200) {
      vendorDetails = vendorDetailsModelFromJson(response.body);
      hasMoreItems = vendorDetails.recentProducts.length > 9;
      notifyListeners();
    } else {
      throw Exception('Failed to load details');
    }
  }

  Future<bool> loadMore() async {
    page = page + 1;
    filter['page'] = page.toString();
    List<Product> moreProducts = await apiProvider.fetchProductList(filter);
    if (moreProducts.length != 0) {
      vendorDetails.recentProducts.addAll(moreProducts);
      hasMoreItems = moreProducts.length > 9;
      notifyListeners();
    }
  }

  void getReviews() async {
    reviewPage = 1;
    reviewsFilter['vendor'] = filter['vendor'];
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-vendor_reviews',
        reviewsFilter);
    
    if (response.statusCode == 200) {
      reviews = vendorReviewsFromJson(response.body);
      notifyListeners();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  void getMoreReviews() async {
    reviewPage = reviewPage + 1;
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-vendor_reviews',
        reviewsFilter);
    if (response.statusCode == 200) {
      List<VendorReviews> newReviews = vendorReviewsFromJson(response.body);
      reviews.addAll(newReviews);
      notifyListeners();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  submitContactForm(data) async {
    print(data);
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter-contact_vendor', data);
    
  }

  Future<void> submitReview(Map reviewData) async {
    reviewData['vendor'] = filter['vendor'];
    final response = await apiProvider.post(
        '/wp-admin/admin-ajax.php?action=mstore_flutter_add_vendor_review',
        reviewData);
  }

}
