import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './../../../../models/app_state_model.dart';

class FacebookLoginWidget extends StatelessWidget {

  final appStateModel = AppStateModel();

  FacebookLoginWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(0),
      color: Color(0xFF3b5998),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton(
          //splashRadius: 25.0,
          icon: Icon(
            FontAwesomeIcons.facebook,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () {
            fbLogin(context);
          },
        ),
      ),
    );
  }

  fbLogin(BuildContext context) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _sendTokenToServer(result.accessToken.token, context);
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        _showErrorOnUI(result.errorMessage);
        break;
    }
  }

  void _showCancelledMessage() {}

  void _showErrorOnUI(String errorMessage) {

  }

  Future _sendTokenToServer(token, BuildContext context) async {
    bool status = await appStateModel.facebookLogin(token);
    if (status) {
      Navigator.of(context).pop();
    }
  }
}
