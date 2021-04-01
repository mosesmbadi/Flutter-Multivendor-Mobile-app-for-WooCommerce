import 'dart:io' show Platform;

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui/pages/page_detail.dart';
import '../../../ui/pages/webview.dart';
import '../../../../assets/presentation/m_store_icons_icons.dart';
import '../../../chat/pages/chat_rooms.dart';
import '../../../chat/pages/chat_with_admin.dart';
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
import '../wallet.dart';
import '../wishlist.dart';

class UserAccount8 extends StatefulWidget {
  @override
  _UserAccount8State createState() => _UserAccount8State();
}

class _UserAccount8State extends State<UserAccount8> {
  final appStateModel = AppStateModel();

  @override
  Widget build(BuildContext context) {
    TextStyle menuTextStyle = Theme.of(context).textTheme.bodyText1;
    Color onPrimaryColor = Colors.white;
    Color headerBackgroundColor = Theme.of(context).primaryColor;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Color(0xFFf4f4f4).withOpacity(0.3)
            : Colors.black,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.deepOrangeAccent, Colors.red])
              ),
              height: 230,
              child:  Stack(
                children: [
                  Container(
                    height: 230,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 16,
                        ),
                        CircleAvatar(
                          radius: 32.0,
                          backgroundColor: onPrimaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.deepOrangeAccent,
                            size: 32,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ScopedModelDescendant<AppStateModel>(
                            builder: (context, child, model) {
                              return Container(
                                  child: (model.user?.id != null &&
                                      model.user.id > 0)
                                      ? (model.user.billing.firstName != '' ||
                                      model.user.billing.lastName != '')
                                      ? Text(
                                    model.user.billing.firstName +
                                        ' ' +
                                        model.user.billing.lastName,
                                    style: Theme.of(context).textTheme.headline6.copyWith(
                                        color: Colors.white, fontSize: 24
                                    ),
                                  )
                                      : Container(
                                    child: Text(
                                      model.blocks.localeText.welcome,
                                      style: Theme.of(context).textTheme.headline6.copyWith(
                                          color: Colors.white, fontSize: 24
                                      ),
                                    ),
                                  )
                                      : Container(
                                    child: GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Login())),
                                      child: Text(
                                        model.blocks.localeText.signIn,
                                        style: Theme.of(context).textTheme.headline6.copyWith(
                                            color: Colors.white, fontSize: 24
                                        ),
                                      ),
                                    ),
                                  ));
                            }
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 140),
              child: CustomScrollView(
                slivers: <Widget>[
                  //buildSliverAppBar(onPrimaryColor, context, headerBackgroundColor),
                  buildUserMenu(context, menuTextStyle),
                  buildVendorList(context, menuTextStyle),
                  buildPages(context, menuTextStyle)
                ],
              ),
            ),
            Positioned(
              child: ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                return FabCircularMenu(
                    fabOpenColor: Theme.of(context).colorScheme.secondary,
                    fabCloseColor: Theme.of(context).colorScheme.secondary,
                    fabOpenIcon: Icon(
                      Icons.chat_bubble,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    fabMargin: EdgeInsets.all(24),
                    fabCloseIcon: Icon(
                      Icons.close,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: Container(),
                    ringColor: Theme.of(context).colorScheme.secondary,
                    ringDiameter: 250.0,
                    ringWidth: 100.0,
                    options: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.chat_bubble,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed: () {
                            if (appStateModel.user?.id != null &&
                                appStateModel.user.id > 0) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminChatPage(
                                          userId:
                                              appStateModel.user.id.toString())));
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            }
                            /*openLink(
                                'sms:' + model.blocks.settings.whatsappNumber);*/
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                      model.blocks.settings.supportEmail != null
                          ? IconButton(
                              icon: Icon(
                                Icons.mail,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                              onPressed: () {
                                openLink('mailto:'+model.blocks.settings.supportEmail);
                              },
                              iconSize: 20.0,
                              color: Colors.black)
                          : null,
                      IconButton(
                          icon: Icon(
                            FontAwesomeIcons.whatsapp,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed: () {
                            final url = 'https://wa.me/' +
                                model.blocks.settings.whatsappNumber;
                            openLink(url);
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                      IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          onPressed: () {
                            openLink(
                                'tel:' + model.blocks.settings.whatsappNumber);
                          },
                          iconSize: 20.0,
                          color: Colors.black),
                    ]);
              }),
            )
          ],
        ),
      ),
    );
  }

  SliverPadding buildUserMenu(BuildContext context, TextStyle menuTextStyle) {
    return SliverPadding(
      padding: EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      onTap: () {
                        if (appStateModel.user?.id != null &&
                            appStateModel.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WishList()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      leading: Icon(MStoreIcons.heart),
                      title: Text(
                        appStateModel.blocks.localeText.wishlist.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ListTile(
                      onTap: () {
                        if (appStateModel.user?.id != null &&
                            appStateModel.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wallet()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      leading: ExcludeSemantics(
                          child: Icon(FlutterIcons.ios_wallet_ion)),
                      title: Text(
                        appStateModel.blocks.localeText.wallet.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ListTile(
                      onTap: () {
                        if (appStateModel.user?.id != null &&
                            appStateModel.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderList()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      leading: ExcludeSemantics(
                          child: Icon(MStoreIcons.shopping_basket_2_fill)),
                      title: Text(
                        appStateModel.blocks.localeText.orders.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ListTile(
                      onTap: () {
                        if (appStateModel.user?.id != null &&
                            appStateModel.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerAddress()));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      leading:
                          ExcludeSemantics(child: Icon(MStoreIcons.location)),
                      title: Text(
                        appStateModel.blocks.localeText.address.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ListTile(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage())),
                      leading:
                          ExcludeSemantics(child: Icon(MStoreIcons.settings)),
                      title: Text(
                        appStateModel.blocks.localeText.settings.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
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
                              leading: Icon(Icons.language),
                              title: Text(
                                model.blocks.localeText.language.toUpperCase(),
                                style: menuTextStyle,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
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
                                      builder: (context) => CurrencyPage())),
                              leading: ExcludeSemantics(
                                  child: Icon(Icons.attach_money)),
                              title: Text(
                                model.blocks.localeText.currency.toUpperCase(),
                                style: menuTextStyle,
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
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
                      leading: ExcludeSemantics(child: Icon(MStoreIcons.share)),
                      title: Text(
                        appStateModel.blocks.localeText.shareApp.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ListTile(
                      onTap: () {
                        if (appStateModel.user?.id != null &&
                            appStateModel.user.id > 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoomList(
                                      id: appStateModel.user.id.toString())));
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      leading: ExcludeSemantics(child: Icon(Icons.chat_bubble)),
                      title: Text(
                        appStateModel.blocks.localeText.chat.toUpperCase(),
                        style: menuTextStyle,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                      ),
                    ),
                    Divider(height: 0.0),
                    ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                      if (model.loggedIn) {
                        return ListTile(
                          onTap: () => appStateModel.logout(),
                          leading: Icon(MStoreIcons.logout_circle_r_fill),
                          title: Text(
                            model.blocks.localeText.logout.toUpperCase(),
                            style: menuTextStyle,
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }

  buildVendorList(BuildContext context, TextStyle menuTextStyle) {
    return SliverToBoxAdapter(
      child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
        if (model.loggedIn && model.isVendor.contains(model.user.role)) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            margin: EdgeInsets.all(24),
            child: Column(
              children: [
                ListTile(
                    leading: Icon(MStoreIcons.grid_fill),
                    title: Text(
                      model.blocks.localeText.products.toUpperCase(),
                      style: menuTextStyle,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorProductList(
                                vendorId: model.user.id.toString())))),
                Divider(height: 1, thickness: 0.3),
                ListTile(
                    leading: Icon(Icons.shopping_basket),
                    title: Text(
                      model.blocks.localeText.orders.toUpperCase(),
                      style: menuTextStyle,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorOrderList(
                                vendorId: model.user.id.toString())))),
                Divider(height: 1, thickness: 0.3),
                ListTile(
                    leading: Icon(MStoreIcons.store_2_fill),
                    title: Text(
                      model.blocks.localeText.info.toUpperCase(),
                      style: menuTextStyle,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VendorDetails(
                                vendorId: model.user.id.toString())))),
              ],
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  SliverAppBar buildSliverAppBar(
      Color onPrimaryColor, BuildContext context, Color headerBackgroundColor) {
    return SliverAppBar(
      brightness: Brightness.dark,
      floating: false,
      pinned: true,
      snap: false,
      expandedHeight: 150.0,
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 0, bottom: 16),
          title: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              CircleAvatar(
                radius: 18.0,
                backgroundColor: onPrimaryColor,
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 18,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ScopedModelDescendant<AppStateModel>(
                  builder: (context, child, model) {
                  return Container(
                      child: (model.user?.id != null &&
                          model.user.id > 0)
                          ? (model.user.billing.firstName != '' ||
                          model.user.billing.lastName != '')
                              ? Text(
                        model.user.billing.firstName +
                                      ' ' +
                            model.user.billing.lastName,
                                  style: TextStyle(color: onPrimaryColor),
                                )
                              : Container(
                                  child: Text(
                                    model.blocks.localeText.welcome,
                                    style: TextStyle(color: onPrimaryColor),
                                  ),
                                )
                          : Container(
                              child: GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login())),
                                child: Text(
                                  model.blocks.localeText.signIn,
                                  style: TextStyle(color: onPrimaryColor),
                                ),
                              ),
                            ));
                }
              )
            ],
          ),
          background: buildAccountBackground2()),
      backgroundColor: headerBackgroundColor,
    );
  }

  Widget buildAccountBackground() {
    return Stack(
      children: [
        Positioned(
          top: 30,
          left: -30,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(38 / 360),
            child: Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
              height: 35,
              width: 90,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(127 / 360),
            child: Container(
              color: Theme.of(context).primaryColorDark.withOpacity(0.8),
              height: 35,
              width: 90,
            ),
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(125 / 360),
            child: Container(
              color: Theme.of(context).primaryColorDark.withOpacity(0.8),
              height: 35,
              width: 100,
            ),
          ),
        ),
        Positioned(
          bottom: 80,
          right: -60,
          child: RotationTransition(
            turns: new AlwaysStoppedAnimation(125 / 360),
            child: Container(
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
              height: 35,
              width: 160,
            ),
          ),
        )
      ],
    );
  }

  Widget buildAccountBackground2() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColorLight.withOpacity(0.1)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
        Positioned(
          top: 10,
          left: 80,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 60,
            width: 60,
          ),
        ),
        Positioned(
          top: 0,
          left: -5,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 35,
            width: 90,
          ),
        ),
        Positioned(
          bottom: 62,
          right: -40,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 100,
            width: 100,
          ),
        ),
        Positioned(
          bottom: -40,
          right: 60,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).primaryColorLight.withOpacity(0.3),
            ),
            height: 80,
            width: 80,
          ),
        )
      ],
    );
  }

  buildPages(BuildContext context, TextStyle menuTextStyle) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
      if (model.blocks != null &&
          model.blocks.pages.length != 0 &&
          model.blocks.pages[0].url.isNotEmpty) {
        return buildPageList(model.blocks.pages, menuTextStyle);
      } else {
        return SliverToBoxAdapter();
      }
    });
  }

  buildPageList(List<Child> pages, TextStyle menuTextStyle) {
    return SliverPadding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            if (pages[index].url.isNotEmpty) {
              return Container(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                child: Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () => _onPressItem(pages[index], context),
                      leading: ExcludeSemantics(
                        child: Icon(FlutterIcons.info_circle_faw5s),
                      ),
                      title: Text(
                        pages[index].title,
                        style: menuTextStyle,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 15),
                    ),
                    Divider(height: 0.0),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
          childCount: pages.length,
        ),
      ),
    );
  }

  Future openLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  _onPressItem(Child page, BuildContext context) {
    if(page.description == 'page') {
      var post = Post();
      post.id = int.parse(page.url);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageDetail(post: post)));
    } else if(page.description == 'post') {
      var post = Post();
      post.id = int.parse(page.url);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PostDetail(post: post)));
    } else if(page.description == 'link') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WebViewPage(url: page.url, title: page.title)));
    }
  }
}
