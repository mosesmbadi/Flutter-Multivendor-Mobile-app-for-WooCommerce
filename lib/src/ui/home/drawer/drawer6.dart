import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/app_state_model.dart';
import '../../../models/customer_model.dart';
import '../../../ui/products/products.dart';

class MyDrawer extends StatefulWidget {

  final appStateModel = AppStateModel();

  final ValueChanged<int> onChangePageIndex;
  MyDrawer({Key key, this.onChangePageIndex}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> with TickerProviderStateMixin {


  final TextStyle _biggerFont = const TextStyle(fontSize: 24, color: Colors.white);

  static final Animatable<Offset> _drawerDetailsTween = Tween<Offset>(
    begin: const Offset(0.0, -1.0),
    end: Offset.zero,
  ).chain(CurveTween(
    curve: Curves.fastOutSlowIn,
  ));

  AnimationController _controller;
  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;
  bool _showDrawerContents = true;

  @override
  Future initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _drawerContentsOpacity = CurvedAnimation(
      parent: ReverseAnimation(_controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition = _controller.drive(_drawerDetailsTween);
    //getActiveAccount();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryIconThemeColor = Theme.of(context).iconTheme.color.withOpacity(0.4);
    return Drawer(
      child: Column(
        children: <Widget>[
          /*UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Colors.green,
            ),
            //arrowColor: primaryIconThemeColor,
            accountName: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.cover,
            ),
          ),*/
          /*ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
            return ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                return model.loggedIn ? UserAccountsDrawerHeader(
                  //arrowColor: primaryIconThemeColor,
                  accountName: Text(model.user.firstName + ' ' + model.user.lastName),
                  accountEmail: Text(_getShippingAddress(model.user.shipping), maxLines: 2,),
                  //currentAccountPicture: CircleAvatar(child: Icon(FlutterIcons.user_fea),),
                  margin: EdgeInsets.zero,

                ) : Container(
                  decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide( //                   <--- left side
                        color: Theme.of(context).dividerColor,
                        width: 1.0,
                      ),
                      )
                  ),
                  //color: Colors.orange,
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 40, 10),
                    child: Center(
                      child: Image.asset(
                        'lib/assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )*//*UserAccountsDrawerHeader(
                  arrowColor: primaryIconThemeColor,
                  accountName: ListTile(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                    title:  Text(widget.appStateModel.blocks.localeText.signIn),
                    leading: Icon(FlutterIcons.user_fea),
                    trailing: Icon(CupertinoIcons.right_chevron),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Login()));
                    },
                  ),
                  //currentAccountPicture: CircleAvatar(child: Icon(FlutterIcons.user_fea),),
                  margin: EdgeInsets.zero,

                )*//*;
              }
            );
          }),*/
          Container(
            height: 205,
            decoration: BoxDecoration(
              boxShadow: kElevationToShadow[4],
              color: Theme.of(context).primaryColor,
            ),
            child: Stack(
              children: [
                Center(
                  child: Text('WC STORE', style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Lexend_Deca',
                    letterSpacing: 0.5,
                    color: Theme.of(context).primaryColorLight,
                    //color: Colors.amber,
                    fontSize: 20,
                  )),
                  /*child: Image.asset(
                    'lib/assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),*/
                ),
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
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            // DrawerHeader consumes top MediaQuery padding.
            removeTop: true,
            child: Expanded(
              child: ListView(
                dragStartBehavior: DragStartBehavior.down,
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      // The initial contents of the drawer.
                      FadeTransition(
                        opacity: _drawerContentsOpacity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              title:  Text(widget.appStateModel.blocks.localeText.home),
                              leading: Icon(FlutterIcons.home_fea),
                              trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                              onTap: () {
                                widget.onChangePageIndex(0);
                                Navigator.of(context).pop();
                              },
                            ),
                            ScopedModelDescendant<AppStateModel>(builder: (context, child, model) {
                                return model.loggedIn ? ListTile(
                                  title:  Text(widget.appStateModel.blocks.localeText.account),
                                  leading: Icon(FlutterIcons.user_fea),
                                  trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                                  onTap: () {
                                    widget.onChangePageIndex(3);
                                    Navigator.of(context).pop();
                                  },
                                ) : Container();
                              }
                            ),
                            ListTile(
                              title:  Text(widget.appStateModel.blocks.localeText.category),
                              leading: Icon(FlutterIcons.grid_fea),
                              trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                              onTap: () {
                                widget.onChangePageIndex(1);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              leading: Icon(FlutterIcons.bookmark_fea),
                              trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                              title: Text(widget.appStateModel.blocks.localeText.sales),
                              onTap: () {
                                var filter = new Map<String, dynamic>();
                                filter['featured'] = '1';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsWidget(
                                            filter: filter,
                                            name: widget.appStateModel.blocks.localeText.featured)));
                              },
                            ),
                            ListTile(
                              leading: Icon(FlutterIcons.sale_mco),
                              trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                              title: Text(widget.appStateModel.blocks.localeText.sales),
                              onTap: () {
                                var filter = new Map<String, dynamic>();
                                filter['on_sale'] = '1';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsWidget(
                                            filter: filter,
                                            name: widget.appStateModel.blocks.localeText.sales)));
                              },
                            ),
                            ListTile(
                              leading: Icon(FlutterIcons.new_box_mco),
                              trailing: Icon(CupertinoIcons.right_chevron,color: primaryIconThemeColor,),
                              title: Text(widget.appStateModel.blocks.localeText.localeTextNew),
                              onTap: () {
                                var filter = new Map<String, dynamic>();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductsWidget(
                                            filter: filter,
                                            name: widget.appStateModel.blocks.localeText.localeTextNew)));
                              },
                            )
                          ],
                        ),
                      ),
                      // The drawer's "details" view.
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getShippingAddress(Address shipping) {
    String address = '';
    if(shipping.address1 != null && shipping.address1.isNotEmpty) {
      address = address + '' + shipping.address1;
    } if(shipping.address2 != null && shipping.address2.isNotEmpty) {
      address = address + ' ' + shipping.address2;
    } if(shipping.city != null && shipping.city.isNotEmpty) {
      address = address + ' ' + shipping.city;
    } if(shipping.postcode != null && shipping.postcode.isNotEmpty) {
      address = address + ' ' + shipping.postcode;
    } if(shipping.state != null && shipping.state.isNotEmpty) {
      address = address + ' ' + shipping.state;
    } if(shipping.country != null && shipping.country.isNotEmpty) {
      address = address + ' ' + shipping.country; }
    return address;
  }


  TextStyle menuItemStyle() {
    return TextStyle(
        fontFamily: 'Varela',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
        color: Colors.black,
        fontSize: 16
    );
  }

}