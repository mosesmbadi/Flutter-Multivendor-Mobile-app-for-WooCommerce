import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class UserAccount9 extends StatefulWidget {


  UserAccount9({Key key})
      : super(key: key);

  @override
  _UserAccount9State createState() => _UserAccount9State();
}

class _UserAccount9State extends State<UserAccount9> {

  final appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? Color(0xFFf2f3f7) : Theme.of(context).scaffoldBackgroundColor,
      body: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
            return Padding(
              padding: EdgeInsets.only(left: 0.0, right: 0.0),
              child: Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: (model.loggedIn &&
                        appStateModel.isVendor.contains(model.user.role)) ? 100: 600,
                    width: MediaQuery.of(context).size.width,),
                  buildUserInfo(context, model),
                  Positioned(
                    top: MediaQuery.of(context).size.height/3-50.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      height: (model.loggedIn &&
                          appStateModel.isVendor.contains(model.user.role)) ? 400: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        children: [
                          buildCommonList(context),
                          SizedBox(
                            height: 20,
                          ),
                          buildLoggedInList(context, model),
                          SizedBox(
                            height: 20,
                          ),
                          ScopedModelDescendant<AppStateModel>(
                              builder: (context, child, model) {
                                if (model.blocks != null &&
                                    model.blocks.pages.length != 0 &&
                                    model.blocks.pages[0].url.isNotEmpty) {
                                  return buildPageList(model.blocks.pages);
                                } else {
                                  return SliverToBoxAdapter(child: Container());
                                }
                              }),
                          (model.user?.id != null && model.user.id > 0)
                              ? buildLogoutList(context)
                              : SliverToBoxAdapter(child: Container()),
                          //buildOtherList(context),
                          SizedBox(
                            height: 20,
                          ),
                          buildVendorDashboard(context),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  buildUserInfo(BuildContext context, AppStateModel model) {
    return Container(
        decoration: BoxDecoration(
            image:DecorationImage(
                image:AssetImage('lib/assets/images/splash.jpg'),
                fit: BoxFit.fill
            )
        ),
        //color:Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height/3,
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 70.0,
              child: CircleAvatar(
                backgroundColor: Colors.white30,
                child: Icon(
                  FlutterIcons.user_fea,
                  size: 40,
                  color: Theme.of(context).textTheme.caption.color.withOpacity(0.4),
                ),
              ),
            ),
            SizedBox(height: 10,),
            (model.user?.id != null && model.user.id > 0)
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    (model.user.billing.firstName != '' || model.user.billing.lastName != '') ? Text(
                      model.user.billing.firstName[0].toUpperCase() + model.user.billing.firstName.substring(1) + ' ' + model.user.billing.lastName[0].toUpperCase() + model.user.billing.lastName.substring(1),
                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white,fontWeight: FontWeight.w700),
                    ) : Container(child: Text('Welcome', style: Theme.of(context).textTheme.headline6,),),
                    model.user.billing.phone != '' ? Column(
                      children: [
                        SizedBox(height: 5.0),
                        Text(
                          model.user.billing.phone,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15),
                        ),
                      ],
                    ) : Container(),
                    model.user.billing.email != '' ? Column(
                      children: [
                        SizedBox(height: 5.0),
                        Text(
                          model.user.billing.email,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15),
                        ),
                      ],
                    ) : Container(),
                  ],
                ),
              ],
            ) : Container(child: FlatButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login())),
              child: Text(
                appStateModel.blocks.localeText.signIn,
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                ),
              ),

            ),),
            SizedBox(
              height: 20,
            ),
          ],
        ));
  }

  Padding buildLoggedInList(BuildContext context, AppStateModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0,3),
                  color: Colors.grey.withOpacity(.2)
              )
            ],
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black:Colors.white
        ),
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
          ],
        ),
      ),
    );
  }

  Divider buildDivider() => Divider(height: 0.0,indent: 15,endIndent: 15,
    color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(.3) : Colors.grey.withOpacity(.4) ,);

  Padding buildCommonList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                spreadRadius: 3,
                blurRadius: 6,
                offset: Offset(0,3),
                color: Colors.grey.withOpacity(.2),
              )
            ],
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black:Colors.white
        ),
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
          ],
        ),
      ),
    );
  }

  Widget buildVendorDashboard(BuildContext context) {
    TextStyle itemTextStyle = Theme.of(context).textTheme.subtitle1;
    TextStyle itemTextStyle2 = Theme.of(context).textTheme.bodyText1;
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                spreadRadius: 3,
                blurRadius: 6,
                offset: Offset(0,3),
                color: Colors.grey.withOpacity(.2),
              )
            ],
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black:Colors.white
        ),
        child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {

              if (model.loggedIn &&
                  appStateModel.isVendor.contains(model.user.role)) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
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
                );} else
                return SliverToBoxAdapter(child: Container());
            }),
      ),
    );
  }

  Padding buildLogoutList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 3,
                  blurRadius: 6,
                  offset: Offset(0,3),
                  color: Colors.grey.withOpacity(.2))
            ],
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black:Colors.white
        ),
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
              Divider(height: 0.0),
            ]),
      ),
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
      Share.share(
          'check out thia app https://play.google.com/store/apps/details?id=com.mstoreapp.woocommerce');
    } else {
      //Add android app link here
      Share.share(
          'check out thia app https://play.google.com/store/apps/details?id=com.mstoreapp.woocommerce');
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
