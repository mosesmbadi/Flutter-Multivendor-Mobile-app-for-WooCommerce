//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../config.dart';
import '../../../functions.dart';
import '../../../resources/api_provider.dart';
import '../order_summary.dart';

class WebViewCheckout extends StatefulWidget {
  @override
  _WebViewCheckoutState createState() => _WebViewCheckoutState();
}

class _WebViewCheckoutState extends State<WebViewCheckout> {
  String orderId;
  final apiProvider = ApiProvider();
  final config = Config();
  bool _isLoadingPage = true;
  WebViewController controller;
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;

  @override
  void initState() {
    _seCookies();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: Container(
        child: Stack(
          children: <Widget>[
            injectCookies ? WebView(
              onPageStarted: (String url) {
                onUrlChange(url);
              },
              initialUrl: config.url + '/checkout/',
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController wvc) {
                //
              },
              onPageFinished: (value) async {
                setState(() {
                  _isLoadingPage = false;
                });
              },
            ) : Container(),
            _isLoadingPage
                ? Container(
              color: Colors.white,
              alignment: FractionalOffset.center,
              child: CircularProgressIndicator(),
            )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    controller.currentUrl().then(onUrlChange);
  }

  Future onUrlChange(String url) async {
    print(url);
    if (url.contains('/order-received/')) {
      orderSummary(url);
    }

    if (url.contains('?errors=true')) {
      // Navigator.of(context).pop();
    }

    // Start of PayUIndia Payment
    if (url.contains('payumoney.com/transact')) {
      // Show WebView
    }

    // End of PayUIndia Payment

    // Start of PAYTM Payment
    if (url.contains('securegw-stage.paytm.in/theia')) {
      //Show WebView
    }

    if (url.contains('type=success') && orderId != null) {
      //orderSummaryById();
    }

  }

  void orderSummary(String url) {
    orderId = getOrderIdFromUrl(url);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderSummary(
              id: orderId,
            )));
  }

  _seCookies() async {
    Uri uri = Uri.parse(config.url);
    String domain = uri.host;
    ApiProvider apiProvider = ApiProvider();
    List<Cookie> cookies = apiProvider.generateCookies();
    apiProvider.cookieList.forEach((element) async {
      await cookieManager.setCookies([
        Cookie(element.name, element.value)
          ..domain = domain
        //..expires = DateTime.now().add(Duration(days: 10))
        //..httpOnly = true
      ]);
    });
    setState(() {
      injectCookies = true;
    });
  }
}
