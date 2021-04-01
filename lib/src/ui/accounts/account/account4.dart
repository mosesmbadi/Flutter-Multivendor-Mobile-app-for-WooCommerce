import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui/accounts/login/login.dart';

import '../../../blocs/checkout_bloc.dart';
import '../../../models/app_state_model.dart';
import '../../../ui/accounts/settings/settings.dart';
import '../../../ui/accounts/wishlist.dart';

class UserAccount4 extends StatefulWidget {
  final CheckoutBloc homeBloc;
  final appStateModel = AppStateModel();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
  );

  UserAccount4({Key key, this.homeBloc}) : super(key: key);
  @override
  _UserAccount4State createState() => _UserAccount4State();
}

class _UserAccount4State extends State<UserAccount4> {
  @override
  int _cIndex = 0;
  bool switchControl = false;

  Widget build(BuildContext context) {
    var borderDecoration = BoxDecoration(
        color: Theme.of(context).appBarTheme.color,
        borderRadius: new BorderRadius.all(Radius.circular(4.0)));

    var iconDecoration = BoxDecoration(
      color: Theme.of(context).iconTheme.color  .withOpacity(0.03),
      shape: BoxShape.circle,
    );

    var iconColor = Theme.of(context).iconTheme.color.withOpacity(0.6);

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Account')
      ),
      backgroundColor: Theme.of(context).focusColor.withOpacity(0.02),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16.0,
              ),
              Container(
                //height: 130,
                child: Card(
                  elevation: 0.1,
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding:
                              EdgeInsets.only(top: 20.0, left: 20.0, bottom: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: 70.0,
                                width: 70.0,
                                child: CircleAvatar(
                                  backgroundColor: iconColor.withOpacity(0.03),
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: iconColor,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20.0),
                              ScopedModelDescendant<AppStateModel>(
                                  builder: (context, child, model) {
                                    if(model.user?.id != null &&
                                        model.user.id > 0) {
                                      if(model.user.billing.firstName != '' ||
                                          model.user.billing.lastName != '') {

                                      }
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          (model.user.billing.firstName != '' ||
                                              model.user.billing.lastName != '') ? Text(
                                          model.user.billing.firstName + ' ' + model.user.billing.lastName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600, fontSize: 18),
                                          ) : Text(
                                            model.blocks.localeText.welcome,
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            model.user.billing.phone,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300, fontSize: 15),
                                          ),
                                          SizedBox(height: 5.0),
                                          Text(
                                            model.user.email,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300, fontSize: 15),
                                          ),
                                        ],
                                      );
                                    } else
                                    return Container(
                                      height: 70,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Login())),
                                            child: Text(
                                              model.blocks.localeText.signIn,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600, fontSize: 24)
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              )
                            ],
                          )),
                      Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                elevation: 0.1,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WishList())),
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.favorite, color: iconColor,)),
                        title: Text("My Wishlist"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.shopping_basket, color: iconColor)),
                        title: Text("My Orders"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    Divider(
                      height: 1,
                      thickness: 0.3,
                    ),
                    Container(
                      color: Theme.of(context).appBarTheme.color,
                      child: ListTile(
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.account_balance_wallet, color: iconColor,)),
                        title: Text("My Wallets"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Card(
                elevation: 0.1,
                child: Container(
                  //decoration: borderDecoration,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SettingsPage()));
                        },
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child: Icon(Icons.settings, color: iconColor,)),
                        title: Text("Settings"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 0.3,
                      ),
                      ListTile(
                        onTap: () => logout(),
                        leading: Container(
                            decoration: iconDecoration,
                            padding: EdgeInsets.all(6),
                            child:  Icon(Icons.exit_to_app)),
                        title: Text("Logout"),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _onTapLink(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _shareApp() {}


  void logout() async {
    widget.appStateModel.logout();
  }

  void toggleSwitch(bool value) {
    if (switchControl == false) {
      setState(() {
        switchControl = true;
      });
      // Put your code here which you want to execute on Switch ON event.

    } else {
      setState(() {
        switchControl = false;
      });
      // Put your code here which you want to execute on Switch OFF event.
    }
  }
}
