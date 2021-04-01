import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../config.dart';
import '../../resources/api_provider.dart';


class WebViewPage extends StatefulWidget {
  final String url;
  final String title;
  const WebViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState(url: url);
}

class _WebViewPageState extends State<WebViewPage> {
  final String url;
  bool _isLoadingPage = true;
  final config = Config();
  final cookieManager = WebviewCookieManager();
  bool injectCookies = false;

  @override
  void initState() {
    _seCookies();
    super.initState();
  }

  _WebViewPageState({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title != null ? AppBar(title: Text(widget.title)) : AppBar(),
      body: Container(
        child: Stack(
          children: <Widget>[
            injectCookies ? WebView(
              onPageStarted: (String url) {
                //
              },
              initialUrl: url,
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

  _seCookies() async {
    Uri uri = Uri.parse(config.url);
    String domain = uri.host;
    print('Domain: ' + domain);
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
