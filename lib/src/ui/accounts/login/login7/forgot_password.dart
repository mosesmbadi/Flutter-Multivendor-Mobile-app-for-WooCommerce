import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../ui/accounts/login/login7/bezierContainer.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/errors/error.dart';
import './../../../../resources/api_provider.dart';
import '../../../../functions.dart';
import '../../../color_override.dart';
import 'theme_override.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final appStateModel = AppStateModel();
  TextEditingController emailController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

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
              children: [
                Positioned(
                  top: height * -.16,
                  //means -150 of total height; i.e above the screen
                  right: MediaQuery.of(context).size.width * -.45,
                  //means -40% of total width; i.e more than  right the screen
                  child: BezierContainer(),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
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
                                appStateModel.blocks.localeText.email,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                style: TextStyle(color: Colors.black),
                                obscureText: false,
                                controller: emailController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return appStateModel.blocks.localeText
                                        .pleaseEnterValidEmail;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText:
                                        appStateModel.blocks.localeText.email),
                                keyboardType: TextInputType.emailAddress,
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
                                appStateModel.blocks.localeText.sendOtp,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center,
                              )),
                          controller: _btnController,
                          onPressed: () => _sendOtp(context),
                          animateOnTap: false,
                          width: MediaQuery.of(context).size.width - 34,
                        ),
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
                        }))
              ],
            ),
          )),
        ),
      ),
    );
  }

  _sendOtp(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = emailController.text;
      _btnController.start();
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-email-otp', data);
      _btnController.stop();
      if (response.statusCode == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Material(
                    child: ResetPassword(
                  email: emailController.text,
                ))));
      } else if (response.statusCode == 400) {
        WpErrors error = WpErrors.fromJson(json.decode(response.body));
        showSnackBarError(context, parseHtmlString(error.data[0].message));
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key key,
    @required this.email,
  }) : super(key: key);

  final String email;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();
  bool _obscureText = true;

  TextEditingController otpController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

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
                children: [
                  Positioned(
                    top: height * -.16,
                    //means -150 of total height; i.e above the screen
                    right: MediaQuery.of(context).size.width * -.45,
                    //means -40% of total width; i.e more than  right the screen
                    child: BezierContainer(),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: new Form(
                      key: _formKey,
                      child: new ListView(
                        children: <Widget>[
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
                                    appStateModel.blocks.localeText.enterOtp,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    obscureText: false,
                                    controller: otpController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return appStateModel
                                            .blocks.localeText.pleaseEnterOtp;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText:
                                          appStateModel.blocks.localeText.otp,
                                    ),
                                  ),
                                ]),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          PrimaryColorOverride(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appStateModel.blocks.localeText.newPassword,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    obscureText: _obscureText,
                                    controller: newPasswordController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return appStateModel.blocks.localeText
                                            .pleaseEnterPassword;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            }),
                                        hintText: appStateModel
                                            .blocks.localeText.newPassword),
                                  ),
                                ]),
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
                                appStateModel.blocks.localeText.resetPassword,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            controller: _btnController,
                            onPressed: () => _resetPassword(context),
                            animateOnTap: false,
                            width: MediaQuery.of(context).size.width - 34,
                          ),
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
                          }))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _resetPassword(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if (_formKey.currentState.validate()) {
      data["email"] = widget.email;
      data["password"] = newPasswordController.text;
      data["otp"] = otpController.text;
      _btnController.start();
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-reset-user-password',
          data);
      _btnController.stop();
      if (response.statusCode == 200) {
        int count = 0;
        Navigator.popUntil(context, (route) {
          return count++ == 2;
        });
      } else {
        WpErrors error = WpErrors.fromJson(json.decode(response.body));
        showSnackBarError(context, parseHtmlString(error.data[0].message));
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}
