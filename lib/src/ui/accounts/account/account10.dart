import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

import '../../../models/app_state_model.dart';
import '../../../models/blocks_model.dart';
import '../../../models/post_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../vendor/ui/orders/order_list.dart';
import '../../vendor/ui/products/vendor_detail/vendor_detail.dart';
import '../../vendor/ui/products/vendor_products/product_list.dart';
import '../address/customer_address.dart';
import '../currency.dart';
import '../language/language.dart';
import '../login/login.dart';
import '../orders/order_list.dart';
import '../../pages/post_detail.dart';
import '../try_demo.dart';
import '../wallet.dart';
import '../wishlist.dart';

class UserAccount10 extends StatefulWidget {


  UserAccount10({Key key})
      : super(key: key);

  @override
  _UserAccount10State createState() => _UserAccount10State();
}

class _UserAccount10State extends State<UserAccount10> {

  final appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:Text(
          appStateModel.blocks.localeText.account,
        ),
      ),
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Theme.of(context).scaffoldBackgroundColor,
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: ListView(
                children: [
                  buildLoggedInList(context, model),
                  buildCommonList(context),
                  ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                        if (model.blocks != null &&
                            model.blocks.pages.length != 0 &&
                            model.blocks.pages[0].url.isNotEmpty) {
                          return buildPageList(model.blocks.pages);
                        } else {
                          return Container();
                        }
                      }),

                  (model.user?.id != null && model.user.id > 0)
                      ? buildLogoutList(context)
                      : Container(),

                  //buildOtherList(context),
                  buildVendorDashboard(context),
                ],
              ),
            );
          }),
    );
  }

  Container buildLoggedInList(BuildContext context, AppStateModel model) {
    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () {
              if (model.user?.id != null && model.user.id > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WishList()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()));
              }
            },
            leading: ExcludeSemantics(child: Icon(FlutterIcons.user_fea)),
            title:  (model.user?.billing?.firstName != null || model.user?.billing?.lastName != null) ? Text(
              model.user.billing.firstName[0].toUpperCase() + model.user.billing.firstName.substring(1) + ' ' + model.user.billing.lastName[0].toUpperCase() + model.user.billing.lastName.substring(1),
            ) :
            Text(
              appStateModel.blocks.localeText.signIn,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              if (model.user?.id != null && model.user.id > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WishList()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()));
              }
            },
            leading: ExcludeSemantics(child: Icon(FlutterIcons.heart_fea)),
            title: Text(
              model.blocks.localeText.wishlist,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              if (model.user?.id != null && model.user.id > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Wallet()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()));
              }
            },
            leading: ExcludeSemantics(child: Icon(FlutterIcons.wallet_ant)),
            title: Text(
              'Wallet',
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              if (model.user?.id != null && model.user.id > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderList()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()));
              }
            },
            leading: ExcludeSemantics(child: Icon(FlutterIcons.shopping_cart_fea)),
            title: Text(
              model.blocks.localeText.orders,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
          ListTile(
            onTap: () {
              if (model.user?.id != null && model.user.id > 0) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerAddress()));
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Login()));
              }
            },
            leading: ExcludeSemantics(child: Icon(FlutterIcons.map_pin_fea)),
            title: Text(
              model.blocks.localeText.address,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Divider buildDivider() => Divider(height: 0.0, indent: 20,);
  Container buildCommonList(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage())),
            leading: ExcludeSemantics(child: Icon(FlutterIcons.settings_fea)),
            title: Text(
              appStateModel.blocks.localeText.settings,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
                if (model.blocks?.languages != null &&
                    model.blocks.languages.length > 0) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LanguagePage())),
                        leading: ExcludeSemantics(
                            child: const Icon((IconData(0xf38c,
                                fontFamily: CupertinoIcons.iconFont,
                                fontPackage: CupertinoIcons.iconFontPackage)))),
                        title: Text(
                          appStateModel.blocks.localeText.language,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                      Divider(height: 0.0),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
          ScopedModelDescendant<AppStateModel>(
              builder: (context, child, model) {
                if (model.blocks?.currencies != null &&
                    model.blocks.currencies.length > 0) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CurrencyPage())),
                        leading:
                        ExcludeSemantics(child: Icon(Icons.attach_money)),
                        title: Text(
                          appStateModel.blocks.localeText.currency,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: Theme.of(context).focusColor,
                        ),
                      ),
                      Divider(height: 0.0),
                    ],
                  );
                } else {
                  return Container();
                }
              }),
          ListTile(
            onTap: () => _shareApp(),
            leading: ExcludeSemantics(child: Icon(FlutterIcons.share_fea)),
            title: Text(
              appStateModel.blocks.localeText.shareApp,
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Theme.of(context).focusColor,
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Widget buildVendorDashboard(BuildContext context) {
    TextStyle itemTextStyle = Theme.of(context).textTheme.subtitle1;
    TextStyle itemTextStyle2 = Theme.of(context).textTheme.bodyText1;
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.loggedIn &&
              appStateModel.isVendor.contains(model.user.role)) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text('VENDOR', style: itemTextStyle2),
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                        leading:Icon(FlutterIcons.grid_fea),
                        title: Text('Products', style: itemTextStyle),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).focusColor,),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorProductList(
                                    vendorId: model.user.id.toString())))),
                    Divider(height: 1, thickness: 0.3),
                    ListTile(
                        leading: Icon(Icons.shopping_basket),
                        title: Text(
                            appStateModel.blocks.localeText.orders,
                            style: itemTextStyle),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).focusColor,),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorOrderList(
                                    vendorId: model.user.id.toString())))),
                    Divider(height: 1, thickness: 0.3),
                    ListTile(
                        leading: Icon(FlutterIcons.info_fea),
                        title: Text(
                            appStateModel.blocks.localeText.info,
                            style: itemTextStyle),
                        trailing: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).focusColor,),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VendorDetails(
                                    vendorId: model.user.id.toString())))),
                  ],
                ),
              ],
            );
          } else
            return Container();
        });
  }

  Container buildLogoutList(BuildContext context) {
    return Container(
      child: Column(
          children:[
            ListTile(
              onTap: () => logout(),
              leading: Icon(FlutterIcons.log_out_fea, color: Colors.red,),
              title: Text(
                appStateModel.blocks.localeText.logout,
                style: TextStyle(
                    color: Colors.red
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Theme.of(context).focusColor,
              ),
            ),
            buildDivider()
          ]),
    );
  }

  ListView buildOtherList(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TryDemo())),
          leading: ExcludeSemantics(
              child: const Icon(IconData(0xf3a2,
                  fontFamily: CupertinoIcons.iconFont,
                  fontPackage: CupertinoIcons.iconFontPackage))),
          title: Text(
            'Try demo for your site',
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Theme.of(context).focusColor,
          ),
        ),
      ],
    );
  }

  void logout() async {
    appStateModel.logout();
  }

  buildPageList(List<Child> pages) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
            return pages[index].url.isNotEmpty
                ? Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    var post = Post();
                    post.id = int.parse(pages[index].url);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PostDetail(post: post)));
                  },
                  leading: ExcludeSemantics(
                    child: Icon(CupertinoIcons.info),
                  ),
                  title: Text(pages[index].title,
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Theme.of(context).focusColor,
                  ),
                ),
                Divider(height: 0.0),
              ],
            )
                : Container();
          },
          childCount: pages.length,
        ),
      ),
    );
  }

  _shareApp() {
    if (Platform.isIOS) {
      //Add ios App link here
      Share.share('Check out this app: ' +
          appStateModel.blocks.settings.shareAppIosLink);
    } else {
      //Add android app link here
      Share.share('Check out this app: ' +
          appStateModel.blocks.settings.shareAppAndroidLink);
    }
  }

/*  rateApp() {
    _rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      message:
          'You like this app ? Then take a little bit of your time to leave a rating :',
      onRatingChanged: (stars) {
        return [
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');
              // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
              _rateMyApp.doNotOpenAgain = true;
              _rateMyApp.save().then((v) => Navigator.pop(context));
            },
          ),
        ];
      },
      ignoreIOS: false,
      dialogStyle: DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: StarRatingOptions(),
    );
  }*/
}
