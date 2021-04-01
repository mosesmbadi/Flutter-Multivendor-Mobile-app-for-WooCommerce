import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import './../../../../ui/accounts/login/login7/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login7/forgot_password.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import './../../../../ui/accounts/login/login7/phone_number.dart';
import './../../../../ui/accounts/login/login7/register.dart';
import '../../../color_override.dart';
import 'theme_override.dart';

class Login7 extends StatefulWidget {
  @override
  _Login7State createState() => _Login7State();
}

class _Login7State extends State<Login7> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  var formData = new Map<String, dynamic>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  /*@override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.initState();
  }*/

  final LinearGradient gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xff041F5F),
        Color(0xff02A4E6),
      ]);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeOverride(
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Builder(
              builder: (context) => Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    top: height * -.16,
                    //means -160 of total height; i.e above the screen
                    right: MediaQuery.of(context).size.width * -.45,
                    //means -40% of total width; i.e more than  right the screen
                    child: BezierContainer(),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.150,
                          ),
                          Image.asset(
                            'lib/assets/images/logo_mstoreapp.png',
                            width: 80,
                            height: 60,
                          ),
                          SizedBox(
                            height: height * 0.050,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: usernameController,
                                  onSaved: (value) => setState(
                                      () => formData['username'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterUsername;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText: appStateModel
                                        .blocks.localeText.username,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appStateModel.blocks.localeText.password,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  style: TextStyle(color: Colors.black),
                                  controller: passwordController,
                                  obscureText: true,
                                  onSaved: (value) => setState(
                                      () => formData['password'] = value),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText
                                          .pleaseEnterPassword;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                    hintText: appStateModel
                                        .blocks.localeText.password,
                                  ),
                                  keyboardType: TextInputType.text,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          RoundedLoadingButton(
                            borderRadius: 0,
                            elevation: 0,
                            color: Color(0xfff7892b),
                            valueColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: new BoxDecoration(
                                  gradient: new LinearGradient(
                                    colors: [
                                      Color(0xfffbb448),
                                      Color(0xfff7892b)
                                    ],
                                  ),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey.shade200
                                            : Colors.black12,
                                        offset: Offset(2, 4),
                                        blurRadius: 5,
                                        spreadRadius: 2),
                                  ]),
                              child: Text(
                                appStateModel.blocks.localeText.signIn,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            controller: _btnController,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _submit(context);
                              }
                            },
                            animateOnTap: false,
                            width: MediaQuery.of(context).size.width - 34,
                          ),
                          SizedBox(height: 10.0),
                          FlatButton(
                              padding: EdgeInsets.only(left: 16.0),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Material(child: ForgotPassword())));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                      appStateModel
                                          .blocks.localeText.forgotPassword,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          .copyWith(
                                              fontWeight: FontWeight.w500)),
                                ],
                              )),
                          SizedBox(height: 10.0),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              //crossAxisAlignment: CrossAxisAlignment.baseline,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                                Text('or'),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Divider(
                                        thickness: 1,
                                        color: Colors.grey.shade300),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 50.0, // height of the button
                                    width: 50.0,
                                    child: Card(
                                      shape: StadiumBorder(),
                                      margin: EdgeInsets.all(0),
                                      child: Center(
                                        child: IconButton(
                                          splashRadius: 25.0,
                                          splashColor: Colors.transparent,
                                          icon: Icon(
                                            FontAwesomeIcons.google,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            _googleAuthentication(context);
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: StadiumBorder(),
                                    margin: EdgeInsets.all(0),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        splashRadius: 25.0,
                                        icon: Icon(
                                          FontAwesomeIcons.facebookF,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          fbLogin(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Platform.isIOS
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          shape: StadiumBorder(),
                                          margin: EdgeInsets.all(0),
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: IconButton(
                                              splashRadius: 25.0,
                                              icon: Icon(
                                                FontAwesomeIcons.apple,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                appleLogIn(context);
                                                //_showDialog(context);
                                              },
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: StadiumBorder(),
                                    margin: EdgeInsets.all(0),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        splashRadius: 25.0,
                                        icon: Icon(
                                          FontAwesomeIcons.sms,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Material(
                                                          child:
                                                              PhoneNumber())));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Material(child: Register())));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                      appStateModel
                                          .blocks.localeText.dontHaveAnAccount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                            fontSize: 15,
                                          )),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                        appStateModel.blocks.localeText.signUp,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                                color: Color(0xfff7892b),
                                                fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 30,
                      child: IconButton(
                          icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                //color: Colors.grey.withOpacity(0.5),
                              ),
                              width: 35,
                              height: 35,
                              child: Icon(
                                Icons.chevron_left,
                                size: 30,
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })),
                  ScopedModelDescendant<AppStateModel>(
                      builder: (context, child, model) {
                    if (model.loginLoading) {
                      return Center(
                        child: Dialog(
                          child: Container(
                            padding: EdgeInsets.all(24),
                            child: Wrap(
                              children: [
                                new Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    new CircularProgressIndicator(),
                                    SizedBox(
                                      width: 24,
                                    ),
                                    new Text(appStateModel
                                        .blocks.localeText.pleaseWait),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit(BuildContext context) async {
    _btnController.start();
    bool status = await appStateModel.login(formData, context);
    _btnController.stop();
    if (status) {
      Navigator.of(context).pop();
    }
  }

  void _googleAuthentication(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    googleUser.authentication
        .then((value) => _loginGoogleUser(value.idToken, googleUser, context));
  }

  _loginGoogleUser(String idToken, GoogleSignInAccount googleUser,
      BuildContext context) async {
    var login = new Map<String, dynamic>();
    login["type"] = 'google';
    login["token"] = idToken;
    login["name"] = googleUser.displayName;
    login["email"] = googleUser.email;
    print(login);
    bool status = await appStateModel.googleLogin(login, context);
    if (status) {
      Navigator.of(context).pop();
    }
  }

  //Facebook Login
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

  void _showErrorOnUI(String errorMessage) {}

  Future _sendTokenToServer(token, BuildContext context) async {
    bool status = await appStateModel.facebookLogin(token);
    if (status) {
      Navigator.of(context).pop();
    }
  }

  //Apple Login
  appleLogIn(BuildContext context) async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'com.aboutyou.dart_packages.sign_in_with_apple.example',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );

    if (credential.authorizationCode != null) {
      var login = new Map<String, dynamic>();
      login["userIdentifier"] = credential.userIdentifier;
      if (credential.authorizationCode != null)
        login["authorizationCode"] = credential.authorizationCode;
      if (credential.email != null) {
        login["email"] = credential.email;
      } else {
        //await _showDialog(context);
        //TODO If email and name is empty Request Email and Name
      }
      if (credential.userIdentifier != null)
        login["email"] = credential.userIdentifier;
      if (credential.givenName != null)
        login["name"] = credential.givenName;
      else
        login["name"] = '';
      login["useBundleId"] =
          Platform.isIOS || Platform.isMacOS ? 'true' : 'false';
      bool status = await appStateModel.appleLogin(login);
      if (status) {
        Navigator.of(context).pop();
      }
    }
  }
}
