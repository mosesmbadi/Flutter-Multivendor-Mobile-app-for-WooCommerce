import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import './../../../../models/app_state_model.dart';

class AppleLogin extends StatelessWidget {

  final appStateModel = AppStateModel();
  TextEditingController emailController = new TextEditingController();

  AppleLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(0),
      color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF000000),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton(
          //splashRadius: 25.0,
          icon: Icon(
            FontAwesomeIcons.apple,
            size: 20,
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          ),
          onPressed: () {
            appleLogIn(context);
            //_showDialog(context);
          },
        ),
      ),
    );
  }

  appleLogIn(BuildContext context) async {

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId:
        'com.aboutyou.dart_packages.sign_in_with_apple.example',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );

    if(credential.authorizationCode != null) {

      var login = new Map<String, dynamic>();
      login["userIdentifier"] = credential.userIdentifier;
      if(credential.authorizationCode != null)
        login["authorizationCode"] = credential.authorizationCode;
      if(credential.email != null) {
        login["email"] = credential.email;
      } else {
        //await _showDialog(context);
        //TODO If email and name is empty Request Email and Name
      }
      if(credential.userIdentifier != null)
        login["email"] = credential.userIdentifier;
      if(credential.givenName != null)
        login["name"] = credential.givenName;
      else login["name"] = '';
      login["useBundleId"] = Platform.isIOS || Platform.isMacOS ? 'true' : 'false';
      bool status = await appStateModel.appleLogin(login);
      if (status) {
        Navigator.of(context).pop();
      }
    }
  }

  _showDialog(BuildContext context) async {
    await showDialog<String>(
      context: context,
      child: new _SystemPadding(child: new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: emailController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Enter you email', hintText: ''),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.pop(context, );
              })
        ],
      ),),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
