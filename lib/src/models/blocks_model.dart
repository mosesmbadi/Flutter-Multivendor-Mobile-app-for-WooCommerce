// To parse this JSON data, do
//
//     final blocksModel = blocksModelFromJson(jsonString);

import 'dart:convert';

import './vendor/store_model.dart';
import '../models/product_model.dart';
import 'category_model.dart';
import 'customer_model.dart';

BlocksModel blocksModelFromJson(String str) => BlocksModel.fromJson(json.decode(str));

class BlocksModel {
  List<Block> blocks;
  List<Child> pages;
  Settings settings;
  Dimensions dimensions;
  List<Product> featured;
  List<Product> onSale;
  List<Product> bestSelling;
  List<Category> categories;
  int maxPrice;
  String loginNonce;
  String currency;
  String language;
  String vendorType;
  List<Language> languages;
  List<Currency> currencies;
  bool status;
  List<Product> recentProducts;
  Customer user;
  LocaleText localeText;
  List<Child> splash;
  Nonce nonce;
  List<StoreModel> stores;
  PageLayout pageLayout;
  Widgets widgets;

  BlocksModel({
    this.blocks,
    this.pages,
    this.settings,
    this.dimensions,
    this.featured,
    this.onSale,
    this.bestSelling,
    this.categories,
    this.maxPrice,
    this.loginNonce,
    this.currency,
    this.languages,
    this.vendorType,
    this.currencies,
    this.status,
    this.recentProducts,
    this.user,
    this.language,
    this.localeText,
    this.splash,
    this.nonce,
    this.stores,
    this.pageLayout,
    this.widgets
  });

  factory BlocksModel.fromJson(Map<String, dynamic> json) => BlocksModel(
    blocks: json["blocks"] == null ? null : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    recentProducts: json["recentProducts"] == null ? [] : List<Product>.from(json["recentProducts"].map((x) => Product.fromJson(x))),
    pages: json["pages"] == null ? [] : List<Child>.from(json["pages"].map((x) => Child.fromJson(x))),
    settings: json["settings"] == null ? null : Settings.fromJson(json["settings"]),
    dimensions: json["dimensions"] == null ? null : Dimensions.fromJson(json["dimensions"]),
    featured: json["featured"] == null ? [] : List<Product>.from(json["featured"].map((x) => Product.fromJson(x))),
    onSale: json["on_sale"] == null ? [] : List<Product>.from(json["on_sale"].map((x) => Product.fromJson(x))),
    bestSelling: json["best_selling"] == null ? [] : List<Product>.from(json["best_selling"].map((x) => Product.fromJson(x))),
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    maxPrice: json["max_price"] == null ? null : json["max_price"],
    loginNonce: json["login_nonce"] == null ? null : json["login_nonce"],
    currency: json["currency"] == null ? null : json["currency"],
    vendorType: json["vendorType"] == null ? null : json["vendorType"],
    languages: json["languages"] == null ? [] : List<Language>.from(json["languages"].map((x) => Language.fromJson(x))),
    currencies: json["currencies"] == null ? [] : List<Currency>.from(json["currencies"].map((x) => Currency.fromJson(x))),
    user: json["user"] == null ? null : Customer.fromJson(json["user"]),
    localeText: json["locale"] == null ? null : LocaleText.fromJson(json["locale"]),
    language: 'en',
    splash: json["splash"] == null || json["splash"] == '' ? null : List<Child>.from(json["splash"].map((x) => Child.fromJson(x))),
    nonce: json["nonce"] == null ? null : Nonce.fromJson(json["nonce"]),
    stores: json["stores"] == null ? null : List<StoreModel>.from(json["stores"].map((x) => StoreModel.fromJson(x))),
    pageLayout: json["pageLayout"] == null ? PageLayout.fromJson({}) : PageLayout.fromJson(json["pageLayout"]),
    widgets: json["widgets"] == null ? Widgets.fromJson({}) : Widgets.fromJson(json["widgets"]),
  );

}

class Nonce {
  Nonce({
    this.wooWalletTopup,
  });

  String wooWalletTopup;

  factory Nonce.fromJson(Map<String, dynamic> json) => Nonce(
    wooWalletTopup: json["woo_wallet_topup"] == null ? null : json["woo_wallet_topup"],
  );
}

class LocaleText {
  String home;
  String companyName;
  String category;
  String categories;
  String cart;
  String addToCart;
  String buyNow;
  String outOfStock;
  String inStock;
  String account;
  String product;
  String products;
  String signIn;
  String signUp;
  String orders;
  String order;
  String wishlist;
  String address;
  String settings;
  String localeTextContinue;
  String save;
  String filter;
  String apply;
  String featured;
  String newArrivals;
  String sales;
  String shareApp;
  String username;
  String password;
  String firstName;
  String lastName;
  String phoneNumber;
  String address2;
  String email;
  String city;
  String pincode;
  String location;
  String select;
  String selectLocation;
  String states;
  String state;
  String country;
  String countires;
  String relatedProducts;
  String justForYou;
  String youMayAlsoLike;
  String billing;
  String shipping;
  String discount;
  String subtotal;
  String total;
  String tax;
  String fee;
  String orderSummary;
  String thankYou;
  String payment;
  String paymentMethod;
  String shippingMethod;
  String billingAddress;
  String shippingAddress;
  String noOrders;
  String noMoreOrders;
  String noWishlist;
  String noMoreWishlist;
  String localeTextNew;
  String otp;
  String reset;
  String resetPassword;
  String newPassword;
  String requiredField;
  String pleaseEnter;
  String pleaseEnterUsername;
  String pleaseEnterCompanyName;
  String pleaseEnterPassword;
  String pleaseEnterFirstName;
  String pleaseEnterLastName;
  String pleaseEnterCity;
  String pleaseEnterPincode;
  String pleaseEnterState;
  String pleaseEnterValidEmail;
  String pleaseEnterPhoneNumber;
  String pleaseEnterOtp;
  String pleaseEnterAddress;
  String logout;
  String pleaseWait;
  String language;
  String currency;
  String forgotPassword;
  String alreadyHaveAnAccount;
  String dontHaveAnAccount;
  String theme;
  String light;
  String dart;
  String system;
  String noProducts;
  String noMoreProducts;
  String chat;
  String call;
  String info;
  String edit;
  String welcome;
  String checkout;
  String items;
  String couponCode;
  String pleaseEnterCouponCode;
  String emptyCart;
  String youOrderHaveBeenReceived;
  String thankYouForShoppingWithUs;
  String thankYouOrderIdIs;
  String youWillReceiveAConfirmationMessage;
  String add;
  String quantity;
  String qty;
  String search;
  String reviews;
  String variations;
  String sku;
  String description;
  String regularPrice;
  String salesPrice;
  String stockStatus;
  String backOrder;
  String options;
  String message;
  String contacts;
  String name;
  String type;
  String status;
  String long;
  String simple;
  String grouped;
  String external;
  String private;
  String draft;
  String pending;
  String publish;
  String visible;
  String variable;
  String catalog;
  String hidden;
  String notify;
  String yes;
  String no;
  String weight;
  String purchaseNote;
  String submit;
  String catalogVisibility;
  String all;
  String stores;
  String wallet;
  String cancel;
  String searchProducts;
  String searchStores;
  String noResults;
  String thankYouForYourReview;
  String pleaseEnterMessage;
  String yourReview;
  String pleaseSelectYourRating;
  String whatIsYourRate;
  String ok;
  String or;
  String sendOtp;
  String balance;
  String debit;
  String credit;
  String addBalance;
  String enterRechargeAmount;
  String pleaseEnterRechargeAmount;
  String attributes;
  String noConversationsYet;
  String sale;
  String inValidCode;
  String verifyNumber;
  String inValidNumber;
  String enterOtp;
  String verifyOtp;

  String orderNote;
  String bestSelling;
  String viewAll;
  String resendOTP;
  String isRequired;

  String price;
  String writeYourReview;
  String thankYouForYourMessage;

  String date;
  String priceHighToLow;
  String priceLowToHigh;
  String popular;
  String rating;
  String processing;
  String onHold;
  String completed;
  String pendingPayment;
  String failed;
  String refunded;
  String cancelled;


  LocaleText({
    this.home,
    this.companyName,
    this.category,
    this.categories,
    this.cart,
    this.addToCart,
    this.buyNow,
    this.outOfStock,
    this.inStock,
    this.account,
    this.product,
    this.products,
    this.signIn,
    this.signUp,
    this.orders,
    this.order,
    this.wishlist,
    this.address,
    this.settings,
    this.localeTextContinue,
    this.save,
    this.filter,
    this.apply,
    this.featured,
    this.newArrivals,
    this.sales,
    this.shareApp,
    this.username,
    this.password,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address2,
    this.email,
    this.city,
    this.pincode,
    this.location,
    this.select,
    this.selectLocation,
    this.states,
    this.state,
    this.country,
    this.countires,
    this.relatedProducts,
    this.justForYou,
    this.youMayAlsoLike,
    this.billing,
    this.shipping,
    this.discount,
    this.subtotal,
    this.total,
    this.tax,
    this.fee,
    this.orderSummary,
    this.thankYou,
    this.payment,
    this.paymentMethod,
    this.shippingMethod,
    this.billingAddress,
    this.shippingAddress,
    this.noOrders,
    this.noMoreOrders,
    this.noWishlist,
    this.noMoreWishlist,
    this.localeTextNew,
    this.otp,
    this.reset,
    this.resetPassword,
    this.newPassword,
    this.requiredField,
    this.pleaseEnter,
    this.pleaseEnterUsername,
    this.pleaseEnterCompanyName,
    this.pleaseEnterPassword,
    this.pleaseEnterFirstName,
    this.pleaseEnterLastName,
    this.pleaseEnterCity,
    this.pleaseEnterPincode,
    this.pleaseEnterState,
    this.pleaseEnterValidEmail,
    this.pleaseEnterPhoneNumber,
    this.pleaseEnterOtp,
    this.pleaseEnterAddress,
    this.logout,
    this.pleaseWait,
    this.language,
    this.currency,
    this.forgotPassword,
    this.alreadyHaveAnAccount,
    this.dontHaveAnAccount,
    this.theme,
    this.light,
    this.dart,
    this.system,
    this.noProducts,
    this.noMoreProducts,
    this.chat,
    this.call,
    this.info,
    this.edit,
    this.welcome,
    this.checkout,
    this.items,
    this.couponCode,
    this.pleaseEnterCouponCode,
    this.emptyCart,
    this.youOrderHaveBeenReceived,
    this.thankYouForShoppingWithUs,
    this.thankYouOrderIdIs,
    this.youWillReceiveAConfirmationMessage,
    this.add,
    this.quantity,
    this.qty,
    this.search,
    this.reviews,
    this.variations,
    this.sku,
    this.description,
    this.regularPrice,
    this.salesPrice,
    this.stockStatus,
    this.backOrder,
    this.options,
    this.message,
    this.contacts,
    this.name,
    this.type,
    this.status,
    this.long,
    this.simple,
    this.grouped,
    this.external,
    this.private,
    this.draft,
    this.pending,
    this.publish,
    this.visible,
    this.variable,
    this.catalog,
    this.hidden,
    this.notify,
    this.yes,
    this.no,
    this.weight,
    this.purchaseNote,
    this.submit,
    this.catalogVisibility,
    this.all,
    this.stores,
    this.wallet,
    this.cancel,
    this.searchProducts,
    this.searchStores,
    this.noResults,
    this.thankYouForYourReview,
    this.pleaseEnterMessage,
    this.yourReview,
    this.pleaseSelectYourRating,
    this.whatIsYourRate,
    this.ok,
    this.or,
    this.sendOtp,
    this.attributes,
    this.noConversationsYet,
    this.balance,
    this.addBalance,
    this.enterRechargeAmount,
    this.pleaseEnterRechargeAmount,
    this.credit,
    this.debit,
    this.sale,
    this.inValidCode,
    this.verifyNumber,
    this.inValidNumber,
    this.enterOtp,
    this.verifyOtp,
    this.orderNote,
    this.bestSelling,
    this.viewAll,
    this.resendOTP,
    this.isRequired,
    this.price,
    this.writeYourReview,
    this.thankYouForYourMessage,
    this.date,
    this.priceHighToLow,
    this.priceLowToHigh,
    this.rating,
    this.popular,
    this.pendingPayment,
    this.completed,
    this.processing,
    this.onHold,
    this.cancelled,
    this.failed,
    this.refunded
  });

  factory LocaleText.fromJson(Map<String, dynamic> json) => LocaleText(
    home: json["Home"] == null ?"Home": json["Home"],
    companyName: json["Company Name"] == null ?"Company Name": json["Company Name"],
    category: json["Category"] == null ?"Category": json["Category"],
    categories: json["Categories"] == null ?"Categories": json["Categories"],
    cart: json["Cart"] == null ?"Cart": json["Cart"],
    addToCart: json["Add to cart"] == null ?"Add to cart": json["Add to cart"],
    buyNow: json["Buy now"] == null ?"Buy now": json["Buy now"],
    outOfStock: json["Out of stock"] == null ?"Out of stock": json["Out of stock"],
    inStock: json["In stock"] == null ?"In stock": json["In stock"],
    account: json["Account"] == null ?"Account": json["Account"],
    product: json["Product"] == null ?"Product": json["Product"],
    products: json["Products"] == null ?"Products": json["Products"],
    signIn: json["Sign In"] == null ?"Sign In": json["Sign In"],
    signUp: json["Sign Up"] == null ?"Sign Up": json["Sign Up"],
    orders: json["Orders"] == null ?"Orders": json["Orders"],
    order: json["Order"] == null ?"Order": json["Order"],
    wishlist: json["Wishlist"] == null ?"Wishlist": json["Wishlist"],
    address: json["Address"] == null ?"Address": json["Address"],
    settings: json["Settings"] == null ?"Settings": json["Settings"],
    localeTextContinue: json["Continue"] == null ?"Continue": json["Continue"],
    save: json["Save"] == null ?"Save": json["Save"],
    filter: json["Filter"] == null ?"Filter": json["Filter"],
    apply: json["Apply"] == null ?"Apply": json["Apply"],
    featured: json["Featured"] == null ?"Featured": json["Featured"],
    newArrivals: json["New Arrivals"] == null ?"New Arrivals": json["New Arrivals"],
    sales: json["Sales"] == null ?"Sales": json["Sales"],
    shareApp: json["Share app"] == null ?"Share app": json["Share app"],
    username: json["Username"] == null ?"Username": json["Username"],
    password: json["Password"] == null ?"Password": json["Password"],
    firstName: json["First Name"] == null ?"First Name": json["First Name"],
    lastName: json["Last Name"] == null ?"Last Name": json["Last Name"],
    phoneNumber: json["Phone Number"] == null ?"Phone Number": json["Phone Number"],
    address2: json["Address 2"] == null ?"Address 2": json["Address 2"],
    email: json["Email"] == null ?"Email": json["Email"],
    city: json["City"] == null ?"City": json["City"],
    pincode: json["Pincode"] == null ?"Pincode": json["Pincode"],
    location: json["Location"] == null ?"Location": json["Location"],
    select: json["Select"] == null ?"Select": json["Select"],
    selectLocation: json["Select location"] == null ?"Select location": json["Select location"],
    states: json["States"] == null ?"States": json["States"],
    state: json["State"] == null ?"State": json["State"],
    country: json["Country"] == null ?"Country": json["Country"],
    countires: json["Countires"] == null ?"Countires": json["Countires"],
    relatedProducts: json["Related Products"] == null ?"Related Products": json["Related Products"],
    justForYou: json["Just for you"] == null ?"Just for you": json["Just for you"],
    youMayAlsoLike: json["You may also like"] == null ?"You may also like": json["You may also like"],
    billing: json["Billing"] == null ?"Billing": json["Billing"],
    shipping: json["Shipping"] == null ?"Shipping": json["Shipping"],
    discount: json["Discount"] == null ?"Discount": json["Discount"],
    subtotal: json["Subtotal"] == null ?"Subtotal": json["Subtotal"],
    total: json["Total"] == null ?"Total": json["Total"],
    tax: json["Tax"] == null ?"Tax": json["Tax"],
    fee: json["Fee"] == null ?"Fee": json["Fee"],
    orderSummary: json["Order summary"] == null ?"Order summary": json["Order summary"],
    thankYou: json["Thank You"] == null ?"Thank You": json["Thank You"],
    payment: json["Payment"] == null ?"Payment": json["Payment"],
    paymentMethod: json["Payment method"] == null ?"Payment method": json["Payment method"],
    shippingMethod: json["Shipping method"] == null ?"Shipping method": json["Shipping method"],
    billingAddress: json["Billing address"] == null ?"Billing address": json["Billing address"],
    shippingAddress: json["Shipping address"] == null ?"Shipping address": json["Shipping address"],
    noOrders: json["No orders"] == null ?"No orders": json["No orders"],
    noMoreOrders: json["No more orders"] == null ?"No more orders": json["No more orders"],
    noWishlist: json["No wishlist"] == null ?"No wishlist": json["No wishlist"],
    noMoreWishlist: json["No more wishlist"] == null ?"No more wishlist": json["No more wishlist"],
    localeTextNew: json["New"] == null ?"New": json["New"],
    otp: json["OTP"] == null ?"OTP": json["OTP"],
    reset: json["Reset"] == null ?"Reset": json["Reset"],
    resetPassword: json["Reset password"] == null ?"Reset password": json["Reset password"],
    newPassword: json["New password"] == null ?"New password": json["New password"],
    requiredField: json["Required Field"] == null ?"Required Field": json["Required Field"],
    pleaseEnter: json["Please enter"] == null ?"Please enter": json["Please enter"],
    pleaseEnterUsername: json["Please enter username"] == null ?"Please enter username": json["Please enter username"],
    pleaseEnterCompanyName: json["Please enter company name"] == null ?"Please enter company name": json["Please enter company name"],
    pleaseEnterPassword: json["Please enter password"] == null ?"Please enter password": json["Please enter password"],
    pleaseEnterFirstName: json["Please enter first name"] == null ?"Please enter first name": json["Please enter first name"],
    pleaseEnterLastName: json["Please enter last name"] == null ?"Please enter last name": json["Please enter last name"],
    pleaseEnterCity: json["Please enter city"] == null ?"Please enter city": json["Please enter city"],
    pleaseEnterPincode: json["Please enter pincode"] == null ?"Please enter pincode": json["Please enter pincode"],
    pleaseEnterState: json["Please enter state"] == null ?"Please enter state": json["Please enter state"],
    pleaseEnterValidEmail: json["Please enter valid email"] == null ?"Please enter valid email": json["Please enter valid email"],
    pleaseEnterPhoneNumber: json["Please enter phone number"] == null ?"Please enter phone number": json["Please enter phone number"],
    pleaseEnterOtp: json["Please enter otp"] == null ?"Please enter otp": json["Please enter otp"],
    pleaseEnterAddress: json["Please enter address"] == null ?"Please enter address": json["Please enter address"],
    logout: json["Logout"] == null ?"Logout": json["Logout"],
    pleaseWait: json["Please wait"] == null ?"Please wait": json["Please wait"],
    language: json["Language"] == null ?"Language": json["Language"],
    currency: json["Currency"] == null ?"Currency": json["Currency"],
    forgotPassword: json["Forgot password"] == null ?"Forgot password?": json["Forgot password"],
    alreadyHaveAnAccount: json["Already have an account"] == null ?"Already have an account?": json["Already have an account"],
    dontHaveAnAccount: json["Dont have an account"] == null ?"Don't have an account?": json["Dont have an account"],
    theme: json["Theme"] == null ?"Theme": json["Theme"],
    light: json["Light"] == null ?"Light": json["Light"],
    dart: json["Dark"] == null ?"Dark": json["Dark"],
    system: json["System"] == null ?"System": json["System"],
    noProducts: json["No products"] == null ?"No products": json["No products"],
    noMoreProducts: json["No more products"] == null ?"No more products": json["No more products"],
    chat: json["Chat"] == null ?"Chat": json["Chat"],
    call: json["Call"] == null ?"Call": json["Call"],
    info: json["Info"] == null ?"Info": json["Info"],
    edit: json["Edit"] == null ?"Edit": json["Edit"],
    welcome: json["Welcome"] == null ?"Welcome": json["Welcome"],
    checkout: json["Checkout"] == null ?"Checkout": json["Checkout"],
    items: json["Items"] == null ?"Items": json["Items"],
    couponCode: json["Coupon code"] == null ?"Coupon code": json["Coupon code"],
    pleaseEnterCouponCode: json["Please enter coupon code"] == null ?"Please enter coupon code": json["Please enter coupon code"],
    emptyCart: json["Empty Cart"] == null ?"Empty Cart": json["Empty Cart"],
    youOrderHaveBeenReceived: json["You order have been received"] == null ?"You order have been received": json["You order have been received"],
    thankYouForShoppingWithUs: json["Thank you for shopping with us"] == null ?"Thank you for shopping with us": json["Thank you for shopping with us"],
    thankYouOrderIdIs: json["Thank you order id is"] == null ?"Thank you order id is": json["Thank you order id is"],
    youWillReceiveAConfirmationMessage: json["You will receive a confirmation message"] == null ?"You will receive a confirmation message": json["You will receive a confirmation message"],
    add: json["Add"] == null ?"Add": json["Add"],
    quantity: json["Quantity"] == null ?"Quantity": json["Quantity"],
    qty: json["QTY"] == null ?"QTY": json["QTY"],
    search: json["Search"] == null ?"Search": json["Search"],
    reviews: json["Reviews"] == null ?"Reviews": json["Reviews"],
    variations: json["Variations"] == null ?"Variations": json["Variations"],
    sku: json["SKU"] == null ?"SKU": json["SKU"],
    description: json["Description"] == null ?"Description": json["Description"],
    regularPrice: json["Regular price"] == null ?"Regular price": json["Regular price"],
    salesPrice: json["Sales price"] == null ?"Sales price": json["Sales price"],
    stockStatus: json["Stock status"] == null ?"Stock status": json["Stock status"],
    backOrder: json["Back order"] == null ?"Back order": json["Back order"],
    options: json["Options"] == null ?"Options": json["Options"],
    message: json["Message"] == null ?"Message": json["Message"],
    contacts: json["Contacts"] == null ?"Contacts": json["Contacts"],
    name: json["Name"] == null ?"Name": json["Name"],
    type: json["Type"] == null ?"Type": json["Type"],
    status: json["Status"] == null ?"Status": json["Status"],
    long: json["Long"] == null ?"Long": json["Long"],
    grouped: json["Grouped"] == null ?"Grouped": json["Grouped"],
    simple: json["Simple"] == null ?"Simple": json["Simple"],
    external: json["External"] == null ?"External": json["External"],
    private: json["Private"] == null ?"Private": json["Private"],
    draft: json["Draft"] == null ?"Draft": json["Draft"],
    pending: json["Pending"] == null ?"Pending": json["Pending"],
    publish: json["Publish"] == null ?"Publish": json["Publish"],
    visible: json["Visible"] == null ?"Visible": json["Visible"],
    variable: json["Variable"] == null ?"Variable": json["Variable"],
    catalog: json["Catalog"] == null ?"Catalog": json["Catalog"],
    hidden: json["Hidden"] == null ?"Hidden": json["Hidden"],
    notify: json["Notify"] == null ?"Notify": json["Notify"],
    yes: json["Yes"] == null ?"Yes": json["Yes"],
    no: json["No"] == null ?"No": json["No"],
    ok: json["Ok"] == null ?"Ok": json["Ok"],
    weight: json["Weight"] == null ?"Weight": json["Weight"],
    purchaseNote: json["Purchase Note"] == null ?"Purchase Note": json["Purchase Note"],
    submit: json["Submit"] == null ?"Submit": json["Submit"],
    catalogVisibility: json["Catalog Visibility"] == null ?"Catalog Visibility": json["Catalog Visibility"],
    all: json["All"] == null ?"All": json["All"],
    stores: json["Stores"] == null ?"Stores": json["Stores"],
    wallet: json["Wallet"] == null ?"Wallet": json["Wallet"],
    cancel: json["Cancel"] == null ?"Cancel": json["Cancel"],
    searchProducts: json["Search Products"] == null ?"Search Products": json["Search Products"],
    searchStores: json["Search Stores"] == null ?"Search Stores": json["Search Stores"],
    noResults: json["No Results"] == null ?"No Results": json["No Results"],
    thankYouForYourReview: json["Thank you for your review"] == null ?"Thank you for your review": json["Thank you for your review"],
    pleaseEnterMessage: json["Please enter message"] == null ?"Please enter message": json["Please enter message"],
    yourReview: json["Your review"] == null ?"Your review": json["Your review"],
    pleaseSelectYourRating: json["Please enter your review"] == null ?"Please enter your review": json["Please enter your review"],
    whatIsYourRate: json["What is your rate"] == null ?"What is your rate": json["What is your rate"],
    or: json["Or"] == null ?"Or": json["Or"],
    sendOtp: json["Send OTP"] == null ?"Send OTP": json["Send OTP"],
    attributes: json["Attributes"] == null ?"Attributes": json["Attributes"],
    noConversationsYet: json["No conversations yet"] == null ?"No conversations yet": json["No conversations yet"],
    balance: json["Balance"] == null ?"Balance": json["Balance"],
    debit: json["Debit"] == null ?"Debit": json["Debit"],
    credit: json["Credit"] == null ?"Credit": json["Credit"],
    addBalance: json["Add balance"] == null ?"Add balance": json["Add balance"],
    enterRechargeAmount: json["Enter recharge amount"] == null ?"Enter recharge amount": json["Enter recharge amount"],
    pleaseEnterRechargeAmount: json["Please enter recharge amount"] == null ?"Please enter recharge amount": json["Please enter recharge amount"],
    sale: json["Sale"] == null ?"Sale": json["Sale"],
    inValidCode: json["Invalid Code"] == null ?"The verification code used is invalid": json["Invalid Code"],
    verifyNumber: json["Verify Number"] == null ?"Verify Number": json["Verify Number"],
    inValidNumber: json["Invalid Number"] == null ?"Invalid Number": json["Invalid Number"],
    enterOtp: json["Enter OTP"] == null ?"Enter OTP": json["Enter OTP"],
    verifyOtp: json["Verify OTP"] == null ?"Verify OTP": json["Verify OTP"],
    orderNote: json["Order Note"] == null ?"Order Note": json["Order Note"],
    bestSelling: json["Best Selling"] == null ?"Best Selling": json["Best Selling"],
    viewAll: json["View All"] == null ?"View All": json["View All"],
    resendOTP: json["resend OTP"] == null ?"Resend OTP": json["resend OTP"],
    isRequired: json["is required"] == null ?"is required": json["is required"],
    price: json["price"] == null ?"Price": json["Price"],
    writeYourReview: json["Write Your Review"] == null ?"Write Your Review": json["Write Your Review"],
    thankYouForYourMessage: json["Thank you for your Message"] == null ?"Thank you for your Message": json["Thank you for your Message"],
    date: json["Date"] == null ?"Date": json["Date"],
    priceHighToLow: json["Price High to Low"] == null ?"Price High to Low": json["Price High to Low"],
    priceLowToHigh: json["Price Low to High"] == null ?"Price Low to High": json["Price Low to High"],
    popular: json["Popular"] == null ?"Popular": json["Popular"],
    rating: json["Rating"] == null ?"Rating": json["Rating"],
    processing: json["Processing"] == null ?"Processing": json["Processing"],
    completed: json["Completed"] == null ?"Completed": json["Completed"],
    pendingPayment: json["Pending Payment"] == null ?"Pending Payment": json["Pending Payment"],
    onHold: json["On Hold"] == null ?"On Hold": json["On Hold"],
    refunded: json["Refunded"] == null ?"Refunded": json["Refunded"],
    cancelled: json["Cancelled"] == null ?"Cancelled": json["Cancelled"],
    failed: json["Failed"] == null ?"Failed": json["Failed"],
  );
}


class Block {
  int id;
  List<Child> children;
  List<Product> products;
  List<Category> categories;
  List<StoreModel> stores;
  String title;
  String headerAlign;
  String titleColor;
  String style;
  String bannerShadow;
  String padding;
  String margin;
  int paddingTop;
  int paddingRight;
  int paddingBottom;
  int paddingLeft;
  int marginTop;
  int marginRight;
  int marginBottom;
  int marginLeft;
  String bgColor;
  String blockType;
  int linkId;
  double borderRadius;
  double childWidth;
  String blockBgColor;
  //String sort;
  String blockBlockType;
  String filterBy;
  double paddingBetween;
  //String blockChildWidth;
  double childHeight;
  double elevation;
  int itemPerRow;
  String saleEnds;
  int layoutGridCol;

  Block({
    this.id,
    this.children,
    this.products,
    this.categories,
    this.stores,
    this.title,
    this.headerAlign,
    this.titleColor,
    this.style,
    this.bannerShadow,
    this.padding,
    this.margin,
    this.paddingTop,
    this.paddingRight,
    this.paddingBottom,
    this.paddingLeft,
    this.marginTop,
    this.marginRight,
    this.marginBottom,
    this.marginLeft,
    this.bgColor,
    this.blockType,
    this.linkId,
    this.borderRadius,
    this.childWidth,
    this.blockBgColor,
    //this.sort,
    this.blockBlockType,
    this.filterBy,
    this.paddingBetween,
    //this.blockChildWidth,
    this.childHeight,
    this.elevation,
    this.itemPerRow,
    this.saleEnds,
    this.layoutGridCol,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
    id: json["id"] == null ? null : json["id"],
    children: json["children"] == null || json["children"] == '' ? null : List<Child>.from(json["children"].map((x) => Child.fromJson(x))),
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    categories: json["categories"] == null ? null : List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    title: json["title"] == null ? null : json["title"],
    headerAlign: json["header_align"] == null ? null : json["header_align"],
    titleColor: json["title_color"] == null ? null : json["title_color"],
    style: json["style"] == null ? null : json["style"],
    bannerShadow: json["banner_shadow"] == null ? null : json["banner_shadow"],
    padding: json["padding"] == null ? null : json["padding"],
    margin: json["margin"] == null ? null : json["margin"],
    paddingTop: json["paddingTop"] == null ? null : json["paddingTop"],
    paddingRight: json["paddingRight"] == null ? null : json["paddingRight"],
    paddingBottom: json["paddingBottom"] == null ? null : json["paddingBottom"],
    paddingLeft: json["paddingLeft"] == null ? null : json["paddingLeft"],
    marginTop: json["marginTop"] == null ? null : json["marginTop"],
    marginRight: json["marginRight"] == null ? null : json["marginRight"],
    marginBottom: json["marginBottom"] == null ? null : json["marginBottom"],
    marginLeft: json["marginLeft"] == null ? null : json["marginLeft"],
    bgColor: json["bgColor"] == null ? null : json["bgColor"],
    blockType: json["blockType"] == null ? null : json["blockType"],
    linkId: json["linkId"] == null ? null : json["linkId"],
    borderRadius: json["borderRadius"] == null ? null : json["borderRadius"].toDouble(),
    childWidth: json["childWidth"] == null ? null : json["childWidth"].toDouble(),
    blockBgColor: json["bg_color"] == null ? null : json["bg_color"],
    //sort: json["sort"] == null ? null : json["sort"],
    blockBlockType: json["block_type"] == null ? null : json["block_type"],
    filterBy: json["filter_by"] == null ? 'popularity' : json["filter_by"],
    paddingBetween: json["paddingBetween"] == null ? null : json["paddingBetween"].toDouble(),
    //blockChildWidth: json["child_width"] == null ? null : json["child_width"],
    childHeight: json["childHeigth"] == null ? null : json["childHeigth"].toDouble(),
    elevation: json["elevation"] == null ? null : json["elevation"].toDouble(),
    itemPerRow: json["itemPerRow"] == null ? null : json["itemPerRow"],
    saleEnds: json["sale_ends"] == null ? null : json["sale_ends"],
    layoutGridCol: json["itemPerRow"] == null ? null : json["itemPerRow"],
    stores: json["stores"] == null ? [] : List<StoreModel>.from(json["stores"].map((x) => StoreModel.fromJson(x))),
  );

}

class Child {
  String title;
  String description;
  String url;
  String sort;
  String attachmentId;
  String thumb;
  String image;
  String height;
  String width;

  Child({
    this.title,
    this.description,
    this.url,
    this.sort,
    this.attachmentId,
    this.thumb,
    this.image,
    this.height,
    this.width,
  });

  factory Child.fromJson(Map<String, dynamic> json) => Child(
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    url: json["url"] == null ? null : json["url"],
    sort: json["sort"] == null ? null : json["sort"],
    //attachmentId: json["attachment_id"] == null ? null : json["attachment_id"],
    thumb: json["thumb"] == null ? null : json["thumb"],
    image: json["image"] == null ? null : json["image"],
    height: json["height"] == null ? null : json["height"],
    width: json["width"] == null ? null : json["width"],
  );
}

class Settings {
  int maxPrice;
  String currency;
  int showFeatured;
  int showOnsale;
  int showLatest;
  int showBestSelling;
  int showStoreList;
  int pullToRefresh;
  String onesignalAppId;
  String googleProjectId;
  String googleWebClientId;
  String rateAppIosId;
  String rateAppAndroidId;
  String rateAppWindowsId;
  String shareAppAndroidLink;
  String shareAppIosLink;
  String supportEmail;
  int enableProductChat;
  int enableHomeChat;
  String whatsappNumber;
  String countryDialCode;
  String appDir;
  int switchLocations;
  String language;
  String productShadow;
  int enableSoldBy;
  int enableSoldByProduct;
  int enableVendorChat;
  int enableVendorMap;
  int enableWallet;
  int enableRefund;
  int switchWpml;
  int switchAddons;
  int switchRewardPoints;
  int disableGuestCheckout;
  int switchWebViewCheckout;
  String defaultCountry;
  String baseState;
  int priceDecimal;
  String vendorType;
  String balance;
  String siteName;
  String siteDescription;
  bool isRtl;
  String distance;


  Settings({
    this.maxPrice,
    this.currency,
    this.showFeatured,
    this.showOnsale,
    this.showLatest,
    this.showBestSelling,
    this.showStoreList,
    this.pullToRefresh,
    this.onesignalAppId,
    this.googleProjectId,
    this.googleWebClientId,
    this.rateAppIosId,
    this.rateAppAndroidId,
    this.rateAppWindowsId,
    this.shareAppAndroidLink,
    this.shareAppIosLink,
    this.supportEmail,
    this.enableProductChat,
    this.enableHomeChat,
    this.whatsappNumber,
    this.countryDialCode,
    this.appDir,
    this.switchLocations,
    this.language,
    this.productShadow,
    this.enableSoldBy,
    this.enableSoldByProduct,
    this.enableVendorChat,
    this.enableVendorMap,
    this.enableWallet,
    this.enableRefund,
    this.switchWpml,
    this.switchAddons,
    this.switchRewardPoints,
    this.disableGuestCheckout,
    this.switchWebViewCheckout,
    this.defaultCountry,
    this.baseState,
    this.priceDecimal,
    this.vendorType,
    this.balance,
    this.siteName,
    this.siteDescription,
    this.isRtl,
    this.distance
  });

  factory Settings.fromJson(Map<String, dynamic> json) => Settings(
    maxPrice: json["max_price"] == null ? null : json["max_price"],
    currency: json["currency"] == null ? null : json["currency"],
    showFeatured: json["show_featured"] == 0 ? null : json["show_featured"],
    showOnsale: json["show_onsale"] == null ? 0 : json["show_onsale"],
    showLatest: json["show_latest"] == null ? 0 : json["show_latest"],
    showBestSelling: json["show_best_selling"] == null ? 0 : json["show_best_selling"],
    showStoreList: json["show_store_list"] == null ? 0 : json["show_store_list"],
    pullToRefresh: json["pull_to_refresh"] == null ? null : json["pull_to_refresh"],
    onesignalAppId: json["onesignal_app_id"] == null ? null : json["onesignal_app_id"],
    googleProjectId: json["google_project_id"] == null ? null : json["google_project_id"],
    googleWebClientId: json["google_web_client_id"] == null ? null : json["google_web_client_id"],
    rateAppIosId: json["rate_app_ios_id"] == null ? null : json["rate_app_ios_id"],
    rateAppAndroidId: json["rate_app_android_id"] == null ? null : json["rate_app_android_id"],
    rateAppWindowsId: json["rate_app_windows_id"] == null ? null : json["rate_app_windows_id"],
    shareAppAndroidLink: json["share_app_android_link"] == null ? null : json["share_app_android_link"],
    shareAppIosLink: json["share_app_ios_link"] == null ? null : json["share_app_ios_link"],
    supportEmail: json["support_email"] == null ? null : json["support_email"],
    enableProductChat: json["enable_product_chat"] == null ? null : json["enable_product_chat"],
    enableHomeChat: json["enable_home_chat"] == null ? null : json["enable_home_chat"],
    whatsappNumber: json["whatsapp_number"] == null ? '' : json["whatsapp_number"],
    countryDialCode: json["country_dial_code"] == null ? '+91' : json["country_dial_code"],
    appDir: json["app_dir"] == null ? null : json["app_dir"],
    switchLocations: json["switchLocations"] == null ? null : json["switchLocations"],
    language: json["language"] == null ? null : json["language"],
    productShadow: json["product_shadow"] == null ? null : json["product_shadow"],
    enableSoldBy: json["enable_sold_by"] == null ? null : json["enable_sold_by"],
    enableSoldByProduct: json["enable_sold_by_product"] == null ? null : json["enable_sold_by_product"],
    enableVendorChat: json["enable_vendor_chat"] == null ? null : json["enable_vendor_chat"],
    enableVendorMap: json["enable_vendor_map"] == null ? null : json["enable_vendor_map"],
    enableWallet: json["enable_wallet"] == null ? null : json["enable_wallet"],
    enableRefund: json["enable_refund"] == null ? null : json["enable_refund"],
    switchWpml: json["switchWpml"] == null ? null : json["switchWpml"],
    switchAddons: json["switchAddons"] == null ? null : json["switchAddons"],
    switchRewardPoints: json["switchRewardPoints"] == null ? null : json["switchRewardPoints"],
    switchWebViewCheckout: json["switchWebViewCheckout"] == null ? null : json["switchWebViewCheckout"],
    disableGuestCheckout: json["disableGuestCheckout"] == null ? null : json["disableGuestCheckout"],
    defaultCountry: json["defaultCountry"] == null ? null : json["defaultCountry"],
    baseState: json["baseState"] == null ? null : json["baseState"],
    priceDecimal: json["priceDecimal"] == null ? 2 : json["priceDecimal"],
    vendorType: json["defaultCountry"] == null ? null : json["vendorType"],
    balance: json["balance"] == null ? null : json["balance"],
    siteName: json["siteName"] == null ? '' : json["siteName"],
    siteDescription: json["siteDescription"] == null ? '' : json["siteDescription"],
    isRtl: json["isRtl"] == null ? false : json["isRtl"],
    distance: json["distance"] == null ? '10' : json["distance"],
  );
}

class Dimensions {
  int imageHeight;
  int productSliderWidth;
  int latestPerRow;
  int productsPerRow;
  int searchPerRow;
  int productBorderRadius;
  int suCatBorderRadius;
  int productPadding;

  Dimensions({
    this.imageHeight,
    this.productSliderWidth,
    this.latestPerRow,
    this.productsPerRow,
    this.searchPerRow,
    this.productBorderRadius,
    this.suCatBorderRadius,
    this.productPadding,
  });

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
    imageHeight: json["imageHeight"] == null ? null : json["imageHeight"],
    productSliderWidth: json["productSliderWidth"] == null ? null : json["productSliderWidth"],
    latestPerRow: json["latestPerRow"] == null ? null : json["latestPerRow"],
    productsPerRow: json["productsPerRow"] == null ? null : json["productsPerRow"],
    searchPerRow: json["searchPerRow"] == null ? null : json["searchPerRow"],
    productBorderRadius: json["productBorderRadius"] == null ? null : json["productBorderRadius"],
    suCatBorderRadius: json["suCatBorderRadius"] == null ? null : json["suCatBorderRadius"],
    productPadding: json["productPadding"] == null ? null : json["productPadding"],
  );
}

class User {
  Data data;
  int id;
  Caps caps;
  String capKey;
  List<String> roles;
  dynamic filter;

  User({
    this.data,
    this.id,
    this.caps,
    this.capKey,
    this.roles,
    this.filter,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    id: json["ID"] == null ? null : json["ID"],
    //caps: json["caps"] == null ? null : Caps.fromJson(json["caps"]),
    //capKey: json["cap_key"] == null ? null : json["cap_key"],
    //roles: json["roles"] == null ? null : List<String>.from(json["roles"].map((x) => x)),
    //filter: json["filter"],
  );
}

class Caps {
  bool administrator;

  Caps({
    this.administrator,
  });

  factory Caps.fromJson(Map<String, dynamic> json) => Caps(
    administrator: json["administrator"] == null ? null : json["administrator"],
  );
}

class Data {
  String id;
  String userLogin;
  String userPass;
  String userNicename;
  String userEmail;
  String userUrl;
  DateTime userRegistered;
  String userActivationKey;
  String userStatus;
  String displayName;
  bool status;
  String url;
  String avatar;
  String avatarUrl;
  int points;
  String pointsVlaue;

  Data({
    this.id,
    this.userLogin,
    this.userPass,
    this.userNicename,
    this.userEmail,
    this.userUrl,
    this.userRegistered,
    this.userActivationKey,
    this.userStatus,
    this.displayName,
    this.status,
    this.url,
    this.avatar,
    this.avatarUrl,
    this.points,
    this.pointsVlaue,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"] == null ? null : json["ID"],
    userLogin: json["user_login"] == null ? null : json["user_login"],
    userPass: json["user_pass"] == null ? null : json["user_pass"],
    userNicename: json["user_nicename"] == null ? null : json["user_nicename"],
    userEmail: json["user_email"] == null ? null : json["user_email"],
    userUrl: json["user_url"] == null ? null : json["user_url"],
    userRegistered: json["user_registered"] == null ? null : DateTime.parse(json["user_registered"]),
    userActivationKey: json["user_activation_key"] == null ? null : json["user_activation_key"],
    userStatus: json["user_status"] == null ? null : json["user_status"],
    displayName: json["display_name"] == null ? null : json["display_name"],
    status: json["status"] == null ? null : json["status"],
    url: json["url"] == null ? null : json["url"],
    avatar: json["avatar"] == null ? null : json["avatar"],
    avatarUrl: json["avatar_url"] == null ? null : json["avatar_url"],
    points: json["points"] == null ? null : json["points"],
    pointsVlaue: json["points_vlaue"] == null ? null : json["points_vlaue"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id == null ? null : id,
    "user_login": userLogin == null ? null : userLogin,
    "user_pass": userPass == null ? null : userPass,
    "user_nicename": userNicename == null ? null : userNicename,
    "user_email": userEmail == null ? null : userEmail,
    "user_url": userUrl == null ? null : userUrl,
    "user_registered": userRegistered == null ? null : userRegistered.toIso8601String(),
    "user_activation_key": userActivationKey == null ? null : userActivationKey,
    "user_status": userStatus == null ? null : userStatus,
    "display_name": displayName == null ? null : displayName,
    "status": status == null ? null : status,
    "url": url == null ? null : url,
    "avatar": avatar == null ? null : avatar,
    "avatar_url": avatarUrl == null ? null : avatarUrl,
    "points": points == null ? null : points,
    "points_vlaue": pointsVlaue == null ? null : pointsVlaue,
  };
}

class Language {
  String code;
  String id;
  String nativeName;
  String major;
  dynamic active;
  String defaultLocale;
  String encodeUrl;
  String tag;
  String translatedName;
  String url;
  String countryFlagUrl;
  String languageCode;

  Language({
    this.code,
    this.id,
    this.nativeName,
    this.major,
    this.active,
    this.defaultLocale,
    this.encodeUrl,
    this.tag,
    this.translatedName,
    this.url,
    this.countryFlagUrl,
    this.languageCode,
  });

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json["language_code"] == null ? null : json["language_code"],
    id: json["id"] == null ? null : json["id"].toString(),
    nativeName: json["native_name"] == null ? null : json["native_name"],
    major: json["major"] == null ? null : json["major"],
    active: json["active"],
    defaultLocale: json["default_locale"] == null ? null : json["default_locale"],
    encodeUrl: json["encode_url"] == null ? null : json["encode_url"],
    tag: json["tag"] == null ? null : json["tag"],
    translatedName: json["translated_name"] == null ? null : json["translated_name"],
    url: json["url"] == null ? null : json["url"],
    countryFlagUrl: json["country_flag_url"] == null ? null : json["country_flag_url"],
    languageCode: json["language_code"] == null ? null : json["language_code"],
  );
}

class Currency {
  //Languages languages;
  dynamic rate;
  String position;
  String thousandSep;
  String decimalSep;
  String numDecimals;
  String rounding;
  int roundingIncrement;
  int autoSubtract;
  String code;
  DateTime updated;
  int previousRate;

  Currency({
    //this.languages,
    this.rate,
    this.position,
    this.thousandSep,
    this.decimalSep,
    this.numDecimals,
    this.rounding,
    this.roundingIncrement,
    this.autoSubtract,
    this.code,
    this.updated,
    this.previousRate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
    //languages: json["languages"] == null ? null : Languages.fromJson(json["languages"]),
    //rate: json["rate"],
    //position: json["position"] == null ? null : json["position"],
    //thousandSep: json["thousand_sep"] == null ? null : json["thousand_sep"],
    //decimalSep: json["decimal_sep"] == null ? null : json["decimal_sep"],
    //numDecimals: json["num_decimals"] == null ? null : json["num_decimals"],
    //rounding: json["rounding"] == null ? null : json["rounding"],
    //roundingIncrement: json["rounding_increment"] == null ? null : json["rounding_increment"],
    //autoSubtract: json["auto_subtract"] == null ? null : json["auto_subtract"],
    code: json["code"] == null ? null : json["code"],
    //updated: json["updated"] == null ? null : DateTime.parse(json["updated"]),
    //previousRate: json["previous_rate"] == null ? null : json["previous_rate"],
  );
}

class PageLayout {
  String category;
  String login;
  String stores;
  String account;
  String product;

  PageLayout({
    this.category,
    this.login,
    this.stores,
    this.account,
    this.product
  });

  factory PageLayout.fromJson(Map<String, dynamic> json) => PageLayout(
    category: json["category"] == null ? 'layout1' : json["category"],
    login: json["login"] == null ? 'layout1' : json["login"],
    stores: json["stores"] == null ? 'layout1' : json["stores"],
    account: json["account"] == null ? 'layout1' : json["account"],
    product: json["product"] == null ? 'layout1' : json["product"],
  );
}

class Widgets {
  String button;

  Widgets({
    this.button,
  });

  factory Widgets.fromJson(Map<String, dynamic> json) => Widgets(
    button: json["button"] == null ? 'button1' : json["button"],
  );
}
