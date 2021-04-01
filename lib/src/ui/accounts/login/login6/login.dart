import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import './../../../../ui/accounts/login/login6/clipper.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login6/forgot_password.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import './../../../../ui/accounts/login/login6/phone_number.dart';
import './../../../../ui/accounts/login/login6/register.dart';
import '../../../color_override.dart';
import 'theme_override.dart';

class Login6 extends StatefulWidget {
  @override
  _Login6State createState() => _Login6State();
}

class _Login6State extends State<Login6> {

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


  final LinearGradient lightGradient = LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight,
      colors: [
        Color(0xff041F5F),
        Color(0xff02A4E6),
      ]
  );

  final LinearGradient darkGradient = LinearGradient(
      begin: Alignment.centerLeft, end: Alignment.centerRight,
      colors: [
        Color(0xff212121),
        Color(0xffbdbdbd)
      ]
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeOverride(
      child: Builder(
        builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Builder(
                builder: (context) => Stack(
                  overflow: Overflow.visible,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height *.1,
                      width: MediaQuery.of(context).size.width,
                      color:  Color(0xff041F5F) ),
                  Positioned(
                    top: 0,
                    child: ClipPath(
                      clipper: ClipperDesign(),
                      child: Container(
                        height: 730,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                           gradient: Theme.of(context).brightness == Brightness.light ?
                        LinearGradient(
                                begin: Alignment.centerLeft, end: Alignment.centerRight,
                                colors: [
                                  Color(0xff02A4E6),
                                  Color(0xff041F5F).withOpacity(.8),
                                ]
                            ) : LinearGradient(
                               begin: Alignment.centerLeft, end: Alignment.centerRight,
                               colors: [
                                 Color(0xffbdbdbd),
                                 Color(0xff212121),
                               ]
                           )
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: ClipPath(
                      clipper: ClipperDesign(),
                      child: Container(
                        height: 700,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            gradient: Theme.of(context).brightness == Brightness.light ? lightGradient : darkGradient                     ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.050,
                          ),
                          Text('Welcome Back!', style: Theme.of(context).textTheme.headline6.copyWith(
                              fontSize: 16,color: Colors.white70
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Sign In', style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: 32,color: Colors.white, fontWeight: FontWeight.w700
                          )),
                          SizedBox(
                            height: height * 0.15,
                          ),
                          PrimaryColorOverride(
                            child: TextFormField(
                              controller: usernameController,
                              onSaved: (value) => setState(() => formData['username'] = value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterUsername;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.username ,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              onSaved: (value) => setState(() => formData['password'] = value),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterPassword;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                                labelText: appStateModel.blocks.localeText.password ,
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          RoundedLoadingButton(
                              color: Theme.of(context).brightness == Brightness.light ? Color(0xff041F5F) : Color(0xffbdbdbd),
                            elevation: 3,
                            valueColor: Colors.white,
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                  gradient: Theme.of(context).brightness == Brightness.light ? lightGradient : darkGradient
                              ),
                              child: Text(
                                "Sign In",style:  TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            controller: _btnController,
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _submit(context);
                              }
                            },
                            animateOnTap: false,
                            width: MediaQuery.of(context).size.width - 34,
                          ),
                          SizedBox(height: 10.0),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Material(child: Register())));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      appStateModel.blocks.localeText
                                          .dontHaveAnAccount,
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontSize: 15,
                                      )),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                        appStateModel.blocks.localeText.signUp,
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(color: Color(0xff02A4E6),fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),
                          FlatButton(
                              padding: EdgeInsets.only(left:16.0),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) => Material(child: ForgotPassword())));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      appStateModel.blocks.localeText.forgotPassword,
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: Color(0xff02A4E6),
                                          fontWeight: FontWeight.w500
                                      )),
                                ],
                              )),
                          SizedBox(height: 30.0),
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
                                      color: Color(0xFFEA4335),
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: IconButton(
                                            splashRadius: 25.0,
                                            splashColor: Colors.transparent,
                                            icon: Icon(
                                              FontAwesomeIcons.google,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              _googleAuthentication(context);
                                            },
                                          ),
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
                                    color: Color(0xFF3b5998),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        splashRadius: 25.0,
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
                                  ),
                                ),
                                Platform.isIOS ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: StadiumBorder(),
                                    margin: EdgeInsets.all(0),
                                    color: Theme.of(context).brightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF000000),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        splashRadius: 25.0,
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
                                  ),
                                ) : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    shape: StadiumBorder(),
                                    margin: EdgeInsets.all(0),
                                    color: Color(0xFF34B7F1),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconButton(
                                        splashRadius: 25.0,
                                        icon: Icon(
                                          FontAwesomeIcons.sms,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => Material(child: PhoneNumber())));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                      top: 30,
                      left: 16,
                      child: IconButton(
                          icon: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                //color: Colors.grey.withOpacity(0.5),
                              ),
                              width: 35,
                              height: 35,
                              child: Icon(Icons.arrow_back, size: 18,color: Colors.white,)
                          ),
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
                                        new Text(appStateModel.blocks.localeText.pleaseWait),
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

  void _showErrorOnUI(String errorMessage) {

  }

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

}

