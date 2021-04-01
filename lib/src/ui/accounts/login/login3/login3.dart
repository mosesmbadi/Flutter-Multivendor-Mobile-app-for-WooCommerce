import 'dart:async';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../../models/app_state_model.dart';
import '../../../../models/register_model.dart';
import '../../../../resources/api_provider.dart';
import 'phone_verification.dart';
import '../social/apple_login.dart';
import '../social/facebook_login.dart';
import '../social/google_login.dart';
import '../../../color_override.dart';
import '../../../widgets/buttons/base_text_field.dart';
import '../../../widgets/buttons/button_text.dart';


class Login3 extends StatefulWidget {

  final AppStateModel model;

  Login3({Key key, this.model}) : super(key: key);
  @override
  _Login3State createState() => _Login3State();
}

class _Login3State extends State<Login3> {

  AppStateModel appStateModel  = AppStateModel();
  ScreenState screenState;
  TextEditingController emailController = new TextEditingController();

  @override
  void initState() {
    screenState = ScreenState.Login;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          child: ScopedModelDescendant<AppStateModel>(
            builder: (context, child, model) {
              return Container(
                child: Column(
                  children: [
                    if (screenState == ScreenState.Login)
                      Column(
                        children: [
                          LoginPage( model: model,),
                          SizedBox(height: 15.0,),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  screenState = ScreenState.ForgotPassword;
                                });
                              },
                              child: Text(
                                  'Forgot Password',
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 15,
                                      color: Colors.grey
                                  ))),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                setState(() {
                                  screenState = ScreenState.Register;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Don\'t have an account?',
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey
                                      )),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                        'Sign Up',
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(color:
                                        Theme.of(context).accentColor)),
                                  ),
                                ],
                              )),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: GoogleLoginWidget(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: FacebookLoginWidget(),
                                    ),
                                  ),
                                ),
                                Platform.isIOS ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: AppleLogin(),
                                    ),
                                  ),
                                ) : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: Card(
                                        shape: StadiumBorder(),
                                        margin: EdgeInsets.all(0),
                                        color: Color(0xFF34B7F1),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: IconButton(
                                            //splashRadius: 25.0,
                                            icon: Icon(
                                              FontAwesomeIcons.sms,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                screenState = ScreenState.PhoneVerification;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (screenState == ScreenState.Register)
                      Column(
                        children: [
                          RegisterPage( model: model,),
                          SizedBox(height: 15.0,),
                          FlatButton(
                              padding: EdgeInsets.all(16.0),
                              onPressed: () {
                                setState(() {
                                  screenState = ScreenState.Login;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Already have an account?',
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey)),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                        'Sign In',
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                                            color:
                                            Theme.of(context).accentColor)),
                                  ),
                                ],
                              )), Center(
                            child: Text(
                              'Or',
                              style: TextStyle(fontSize: 15,
                                  color: Colors.grey),),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: GoogleLoginWidget(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: FacebookLoginWidget(),
                                    ),
                                  ),
                                ),
                                Platform.isIOS ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: AppleLogin(),
                                    ),
                                  ),
                                ) : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 2,
                                    shadowColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Container(
                                      height: 50.0, // height of the button
                                      width: 50.0,
                                      child: Card(
                                        shape: StadiumBorder(),
                                        margin: EdgeInsets.all(0),
                                        color: Color(0xFF34B7F1),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: IconButton(
                                            //splashRadius: 25.0,
                                            icon: Icon(
                                              FontAwesomeIcons.sms,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                screenState = ScreenState.PhoneVerification;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (screenState == ScreenState.ForgotPassword)
                      Column(
                        children: [
                          ForgotPassword(model: model,emailController: emailController),
                          SizedBox(height: 10,),
                          InkWell(
                            child:  Text("Sign In with Username",style:TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w500)),
                            onTap:()  {
                              setState(() {
                                screenState = ScreenState.Login;
                              });
                            },
                          )
                        ],
                      ),
                    if (screenState == ScreenState.ResetPassWord)
                      Column(
                        children: [
                          ResetPassword(model: model, emailController: emailController),
                          SizedBox(height: 10,),
                        ],
                      ),
                    if (screenState == ScreenState.PhoneVerification)
                      Column(
                        children: [
                          PhoneVerificationPage(),
                          SizedBox(height: 10,),
                          InkWell(
                            child:  Text("OTP Dummy Link  >>>>",style:TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w500)),
                            onTap:()  {
                              setState(() {
                                screenState = ScreenState.OTPPage;
                              });
                            },
                          )
                        ],
                      ),
                    if (screenState == ScreenState.OTPPage)
                      Column(
                        children: [
                          OTPPage('9843567489'),
                          SizedBox(height: 10,),
                          InkWell(
                            child:  Text("Login with Username ",style:TextStyle(
                                fontFamily: 'Montserrat',
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.w500)),
                            onTap:()  {
                              setState(() {
                                screenState = ScreenState.Login;
                              });
                            },
                          )
                        ],
                      ),
                  ],
                ),
              );},
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).accentColor,
      leading: IconButton(
        onPressed:()=> Navigator.of(context).pop(),
        icon: Icon(Icons.chevron_left,color: Colors.white,),
      ),
      title: Text(
        screenState == ScreenState.Login ? 'LOGIN'
            : screenState == ScreenState.Register ? 'REGISTER'
            : screenState == ScreenState.ForgotPassword ? 'FORGOT PASSWORD '
            : screenState == ScreenState.ResetPassWord ?'RESET PASSWORD'
            : screenState == ScreenState.PhoneVerification ?'PHONE VERIFICATION '
            :screenState == ScreenState.OTPPage ?'ENTER OTP'
            :'Page',
        style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.w600
        ),
      ) ,
    );
  }
}

enum ScreenState { Login, Register, ResetPassWord, ForgotPassword, PhoneVerification, OTPPage  }

class LoginPage extends StatefulWidget {

  LoginPage({Key key,@required this.model,}) : super(key: key);

  final AppStateModel model;
  final appStateModel = AppStateModel();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  bool _obscureText;

  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  var isLoading = false;
  ScreenState screenState;


  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
      child:  Form(
        key: _formKey,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 60,),
            Container(
              width: 220,
              //constraints: BoxConstraints(minWidth: 180, maxWidth: 180),
              child: Image.asset(
                'lib/assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(height: 60.0),
            PrimaryColorOverride(
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                    hasFloatingPlaceholder: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                    prefixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
                    labelText: widget.model.blocks.localeText.username,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(.4)),
                    prefixStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    counterStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    //fillColor: Colors.white
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterUsername;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(
              height: 12,),
            PrimaryColorOverride(
              child: TextFormField(
                obscureText: _obscureText,
                controller: passwordController,
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterPassword;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  //isDense: true,
                  hasFloatingPlaceholder: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      color: Colors.grey.withOpacity(.4),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                  labelText: widget.model.blocks.localeText.password,
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withOpacity(.4)),
                  prefixStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
                  counterStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  filled: true,
                  //fillColor: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: StadiumBorder(),
                child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.signIn),
                onPressed: () => isLoading ? null : _login(),
              ),
            ),
            SizedBox(height: 12.0),

          ],
        ),
      ),
    );
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }
  _login() async {
    var login = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      login["username"] = usernameController.text;
      login["password"] = passwordController.text;
      setState(() {
        isLoading = true;
      });
      bool status = await widget.model.login(login, context);
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.of(context).pop();
      }
    }
  }

}

class RegisterPage extends StatefulWidget {

  RegisterPage({Key key, @required this.model,}) : super(key: key);

  final AppStateModel model;
  final appStateModel = AppStateModel();
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Country _selected = Country.IN;
  Map loginData =  Map<String, dynamic>();
  var _register = RegisterModel();
  var isLoading = false;
  bool _obscureText;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child:  Form(
        key: _formKey,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 60,),
            Container(
              width: 220,
              //constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
              child: Image.asset(
                'lib/assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 60,),
            PrimaryColorOverride(
              child: TextFormField(
                decoration:InputDecoration(
                    hasFloatingPlaceholder: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    prefixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
                    labelText:  widget.model.blocks.localeText.firstName,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(.4)),
                    prefixStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    counterStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    //fillColor: Colors.white
                ),
                onSaved: (val) =>
                    setState(() => _register.firstName = val),
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterFirstName;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 12,),
            PrimaryColorOverride(
              child: TextFormField(
                decoration:InputDecoration(
                    hasFloatingPlaceholder: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    prefixIcon: Icon(Icons.person, color: Theme.of(context).accentColor),
                    labelText:  widget.model.blocks.localeText.lastName,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(.4)),
                    prefixStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    counterStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    //fillColor: Colors.white
                ),
                onSaved: (val) =>
                    setState(() => _register.lastName = val),
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterLastName;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 12,),
            PrimaryColorOverride(
              child: TextFormField(
                decoration: InputDecoration(
                    hasFloatingPlaceholder: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).accentColor),
                    labelText: widget.model.blocks.localeText.email,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(.4)),
                    prefixStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    counterStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                    //fillColor: Colors.white
                ),
                onSaved: (val) =>
                    setState(() => _register.email = val),
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterValidEmail;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 12,),
            PrimaryColorOverride(
              child: TextFormField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  //isDense: true,
                  hasFloatingPlaceholder: false,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.black, width: 1.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  errorBorder:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide:
                    BorderSide(color: Colors.red, width: 1.0),
                  ),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      color: Colors.grey.withOpacity(.4),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }),
                  prefixIcon: Icon(Icons.lock, color: Theme.of(context).accentColor),
                  labelText: widget.model.blocks.localeText.password,
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.withOpacity(.4)),
                  prefixStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
                  counterStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  filled: true,
                  //fillColor: Colors.white,
                ),
                onSaved: (val) =>
                    setState(() => _register.password = val),
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterPassword;
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
              ),
            ),
            SizedBox(height: 30.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: StadiumBorder(),
                child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.signUp),
                onPressed: () => isLoading ? null : _registerUser(context),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Future _registerUser(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      setState(() {
        isLoading = true;
      });
      bool status =
      await widget.model.register(_register.toJson(), context);
      setState(() {
        isLoading = false;
      });
      if (status) {
        Navigator.of(context).pop();
      }
    }
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }

  void onLogin() async {
    print(loginData);
  }

  countrySelector() {
    /*return CountryPicker(
      dense: false,
      showFlag: false,  //displays flag, true by default
      showDialingCode: false, //displays dialing code, false by default
      showName: true, //displays country name, true by default
      showCurrency: true, //eg. 'British pound'
      showCurrencyISO: true, //eg. 'GBP'
      onChanged: (Country country) {
        setState(() {
          _selected = country;
        });
      },
      selectedCountry: _selected,
    );*/
  }
}

class ForgotPassword extends StatefulWidget {

  ForgotPassword({Key key,
    @required this.model,
    this.emailController,
  }) : super(key: key);

  final AppStateModel model;
  final TextEditingController emailController;


  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();
  ScreenState screenState;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
      child:  Form(
        key: _formKey,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 60,),
            Container(
              width: 220,
              //constraints: BoxConstraints(minWidth: 80, maxWidth: 80),
              child: Image.asset(
                'lib/assets/images/logo.png',
                fit: BoxFit.fitWidth,
              ),
            ),
            SizedBox(
              height: 30,),
            PrimaryColorOverride(
              child: TextFormField(
                decoration: InputDecoration(
                    hasFloatingPlaceholder: false,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.3), width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.black, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    errorBorder:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide:
                      BorderSide(color: Colors.red, width: 1.0),
                    ),
                    prefixIcon: Icon(Icons.email, color: Theme.of(context).accentColor),
                    labelText: widget.model.blocks.localeText.email,
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(.4)),
                    prefixStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    counterStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    filled: true,
                   // fillColor: Colors.white
                ),
                obscureText: false,
                controller: widget.emailController,
                validator: (value) {
                  if (value.isEmpty) {
                    return widget.model.blocks.localeText.pleaseEnterValidEmail;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 24.0),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                shape: StadiumBorder(),
                child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.sendOtp),
                onPressed: () => isLoading ? null : _sendOtp(),
              ),
            ),
            SizedBox(height: 12.0),
          ],
        ),
      ),
    );
  }

  _sendOtp() async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = widget.emailController.text;
      setState(() {
        isLoading = true;
      });
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-email-otp', data);
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        setState(() {
          screenState = ScreenState.Login;
        });
      }
    }
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }

}

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key key,
    @required this.model,
    @required this.emailController,
  }) : super(key: key);

  final AppStateModel model;
  final TextEditingController emailController;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}
class _ResetPasswordState extends State<ResetPassword> {
  ScreenState screenState;
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();

  TextEditingController otpController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomTextFormField(
              controller: otpController,
              label: widget.model.blocks.localeText.otp,
              validationMsg:
              widget.model.blocks.localeText.pleaseEnterOtp,
              password: false,
              inputType: TextInputType.text,
              icon: Icons.code,
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
            CustomTextFormField(
              controller: newPasswordController,
              label: widget.model.blocks.localeText.newPassword,
              validationMsg:
              widget.model.blocks.localeText.pleaseEnterPassword,
              password: true,
              inputType: TextInputType.text,
              icon: Icons.vpn_key,
            ),
            SizedBox(height: 24.0),
            RaisedButton(
              shape: StadiumBorder(),
              child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.resetPassword),
              onPressed: () => isLoading ? null : _resetPassword(widget.model),
            ),
          ],
        ),
      ),
    );
  }

  _resetPassword(AppStateModel model) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = widget.emailController.text;
      data["password"] = newPasswordController.text;
      data["otp"] = otpController.text;
      setState(() {
        isLoading = true;
      });

      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-reset-user-password',
          data);
      if (response.statusCode == 200) {
        setState(() {
          screenState = ScreenState.Login;
        });
      }
      setState(() {
        isLoading = false;
      });
    }
    //TODO Call api to send otp
  }
}

class CustomTextFormField extends StatelessWidget {
  bool password;
  bool obscureText;
  IconButton suffix;
  String label;
  String validationMsg;
  TextEditingController controller;
  IconData icon;
  TextInputType inputType;
  FormFieldSetter onSaved;

  CustomTextFormField(
      {this.label,
        this.validationMsg,
        this.controller,
        this.icon,
        this.obscureText,
        this.inputType,
        this.password,
        this.suffix,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
          hasFloatingPlaceholder: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
                color: Colors.grey.withOpacity(.3), width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.red, width: 1.0),
          ),
          errorBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.red, width: 1.0),
          ),
          prefixIcon: Icon(Icons.lock, color: Theme.of(context).accentColor),
          suffixIcon: suffix,
          labelText: label,
          labelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.withOpacity(.4)),
          prefixStyle:
          TextStyle(color: Colors.white.withOpacity(0.8)),
          counterStyle:
          TextStyle(color: Colors.white.withOpacity(0.8)),
          errorStyle: TextStyle(color: Colors.redAccent),
          filled: true,
          //fillColor: Colors.white
      ),
      obscureText: obscureText,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return validationMsg;
        }
        return null;
      },
      keyboardType: inputType,
    );
  }
}

const kFullTabHeight = 60.0;

class PhoneVerificationPage extends StatefulWidget {

  final appStateModel = AppStateModel();

  PhoneVerificationPage({Key key}) : super(key: key);


  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  static const tabBorderRadius = BorderRadius.all(Radius.circular(4.0));

  double _tabHeight = kFullTabHeight;


  final FirebaseAuth _auth = FirebaseAuth.instance;

  var loadingSendOtp = false;
  var _formKey = new GlobalKey<FormState>();
  var _loadingOtp = false;
  String prefixCode = '+91';

  String verificationId;

  String smsOTP;

  String errorMessage = '';

  var _loadingNumber = false;

  String _phoneNumber;

  @override
  void initState() {
    super.initState();
    //_initMethods();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: new Column(
        children:[
          SizedBox(
            height: 60,),
          Container(
            width: 220,
            //constraints: BoxConstraints(minWidth: 180, maxWidth: 180),
            child: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: 60.0),
          Row(
            children: <Widget>[
              CountryCodePicker(
                onChanged: _onCountryChange,
                // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                initialSelection: 'IN',
                favorite: [prefixCode, 'IN'],
                // optional. Shows only country name and flag
                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
              new SizedBox(
                width: 0.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Form(
                      key: _formKey,
                      child: BaseTextField(
                        labelText: widget.appStateModel.blocks.localeText.phoneNumber,
                        validator: (String value) {
                          if (value == null || value.trim().isEmpty) return widget.appStateModel.blocks.localeText.pleaseEnterPhoneNumber;
                          return value.length == 0 ? null : widget.appStateModel.blocks.localeText.pleaseEnterPhoneNumber;
                        },
                        onSaved: (String value) {
                          _phoneNumber = value;
                        },
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                      )
                  ),
                ),
              ),
            ],
          ),
          new SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              shape: StadiumBorder(),
              child:
              ButtonText(isLoading: _loadingNumber, text: widget.appStateModel.blocks.localeText.verifyNumber),
              onPressed: () => _loadingNumber ? null : _validateInputs(),
            ),
          ),
        ],
      ),
    );
  }

  Container buildOtpEntryCard(BuildContext context) {
    return Container(
      child: new Form(
        autovalidate: false,
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new SizedBox(
              height: 15.0,
            ),
            new BaseTextField(
              labelText: widget.appStateModel.blocks.localeText.enterOtp,//'ENTER OTP(6 digits)',
              validator: (String value) {
                if (value == null || value.trim().isEmpty) return widget.appStateModel.blocks.localeText.inValidCode;
                return value.length == 6 ? null : widget.appStateModel.blocks.localeText.inValidCode;
              },
              onSaved: (String value) {
                smsOTP = value;
              },
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                new LengthLimitingTextInputFormatter(6),
              ],
            ),
            new SizedBox(
              height: 20.0,
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: ButtonText(isLoading: _loadingOtp, text: widget.appStateModel.blocks.localeText.verifyOtp),
                onPressed: () => _loadingOtp ? null : _verifyOTP(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      height: _tabHeight,
      alignment: Alignment.center,
      child: new Text(
        widget.appStateModel.blocks.localeText.signIn,
        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w800),
      ),
    );
  }


  int _getCurrentTab() {
    int checkedTab;
    checkedTab = 0;
    return checkedTab;
  }

  Future<void> _verifyOTP(BuildContext context) async {
    _formKey.currentState.save();

    setState(() {
      _loadingOtp = true;
    });
    //TODO VERIFY OTP

    var login = new Map<String, dynamic>();
    login["smsOTP"] = smsOTP;
    login["verificationId"] = verificationId;
    login["phoneNumber"] = _phoneNumber;
    bool status = await widget.appStateModel.phoneLogin(login, context);
    setState(() {
      _loadingOtp = false;
    });
    if (status) {
      Navigator.pop(context, status);
    }

    /*try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;

      user.getIdToken().then((value) => print(value));

      var login = new Map<String, dynamic>();
      login["name"] = '';
      login["phone"] = user.phoneNumber;
      login["smsOTP"] = smsOTP;
      login["verificationId"] = verificationId;
      bool status = await widget.appStateModel.phoneLogin(login);
      setState(() {
        _loadingOtp = false;
      });
      if (status) {
        Navigator.pop(context, status);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _loadingOtp = false;
      });
      handleOtpError(e);
    }*/
  }

  handleOtpError(error) {
    print(error.code);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        Fluttertoast.showToast(msg: widget.appStateModel.blocks.localeText.inValidCode);
        Navigator.of(context).pop();
        break;
      default:
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: error.message);
        break;
    }
  }


  Future<void> _validateInputs() async {
    _formKey.currentState.save();
    setState(() {
      _loadingNumber = true;
    });
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        _loadingNumber = false;
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: prefixCode + _phoneNumber, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
          smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            _auth.signInWithCredential(phoneAuthCredential);
            setState(() {
              _loadingNumber = false;
            });
          },
          verificationFailed: (exception) {});
    } catch (e) {
      setState(() {
        _loadingNumber = false;
      });
      handlePhoneNumberError(e);
    }
  }

  handlePhoneNumberError(PlatformException error) {
    switch (error.code) {
      case 'TOO_LONG':
        FocusScope.of(context).requestFocus(new FocusNode());
        Fluttertoast.showToast(msg: widget.appStateModel.blocks.localeText.inValidNumber);
        Navigator.of(context).pop();
        break;
      case 'TOO_SHORT':
        FocusScope.of(context).requestFocus(new FocusNode());
        Fluttertoast.showToast(msg: widget.appStateModel.blocks.localeText.inValidNumber);
        Navigator.of(context).pop();
        break;
      default:
      //Fluttertoast.showToast(msg: error.message);
        Navigator.of(context).pop();
        break;
    }
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      prefixCode = countryCode.toString();
    });
  }

  void _onCancelPress() {
    Navigator.pop(context);
  }
}

class OTPPage extends StatefulWidget {
  final String phoneNumber;

  OTPPage(this.phoneNumber);

  @override
  _OTPPageState createState() =>
      _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: Column(
        children: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8.0),
          //   child: Text(
          //     'Phone Number Verification',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          //     textAlign: TextAlign.center,
          //   ),
          // ),

          //Icon(Icons.phonelink_lock,size: 60,),
          SizedBox(
            height: 60,),
          Container(
            width: 220,
            //constraints: BoxConstraints(minWidth: 180, maxWidth: 180),
            child: Image.asset(
              'lib/assets/images/logo.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(height: 60.0),
          SizedBox(
            width: 220,
            child: Text(
              'An SMS with verification PIN has been sent to',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
            ),
          ) ,
          SizedBox(
            height: 10,),
          Text(
            widget.phoneNumber,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),
          ) ,

          SizedBox(
            height: 30,
          ),
          Form(
            key: formKey,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20),
                child: SizedBox(
                  height: 50,
                  child: PinCodeTextField(
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    validator: (v) {
                      if (v.length < 6) {
                        return "I'm from validator";
                      } else {
                        return null;
                      }
                    },
                    pinTheme: PinTheme(
                      inactiveColor: Colors.grey.withOpacity(.2),
                      inactiveFillColor: Colors.white,
                      disabledColor: Colors.grey,
                      selectedColor: Colors.blue,
                      activeColor: Colors.black,
                      selectedFillColor: Colors.white,
                      shape: PinCodeFieldShape.box,
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(3),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    // backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    // onTap: () {
                    //   print("Pressed");
                    // },
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              hasError ? "*Please fill up all the cells properly" : "",
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ButtonTheme(
            height: 50,
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              shape: StadiumBorder(),
              onPressed: () {
                formKey.currentState.validate();
                //conditions for validating
                if (currentText.length != 4 || currentText != "towtow") {
                  errorController.add(ErrorAnimationType
                      .shake); // Triggering error shake animation
                  setState(() {
                    hasError = true;
                  });
                } else {
                  setState(() {
                    hasError = false;
                    scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: Text("Aye!!"),
                      duration: Duration(seconds: 2),
                    ));
                  });
                }
              },
              child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600
                    ),
                  )),
            ),

          ),
          SizedBox(
            height: 20,),
          Text(
            'Didn\'t recieve an OTP? ',
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(
            height: 10,),
          InkWell(
            //onTap:  onTapRecognizer,
            child: Text(
              'Resend OTP ',
              style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
          SizedBox(
            height: 10,),
          SizedBox(
            height: 70,),
          Text(
            'I\'ll do this later',
            style: TextStyle(
                color: Colors.grey.withOpacity(.6),
                fontFamily: 'Montserrat',
                fontSize: 14,
                fontWeight: FontWeight.w500
            ),
          )
        ],
      ),
    );
  }
}

typedef void OnResponse<CheckoutResponse>(CheckoutResponse response);

