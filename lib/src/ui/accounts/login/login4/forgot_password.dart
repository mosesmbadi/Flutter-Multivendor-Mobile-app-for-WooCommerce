import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/errors/error.dart';
import './../../../../resources/api_provider.dart';
import './../../../../ui/accounts/login/login4/style.dart';
import './../../../../ui/widgets/buttons/button.dart';
import '../../../../functions.dart';
import '../../../color_override.dart';


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
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF00363a),
        body: Builder(
          builder: (context) => Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: Theme.of(context).brightness != Brightness.dark ?
                BoxDecoration(
                  gradient:
                  LinearGradient(
                      stops: [0.6, 1],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF00363a), Color(0xFF006064)]),):
                BoxDecoration(
                    color: Colors.black
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  //color: Colors.grey.withOpacity(0.5),
                                ),
                                width: 35,
                                height: 35,
                                child: Icon(Icons.arrow_back, color: Colors.white, size: 22,)
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,                      children: [
                            Padding(
                              padding: const EdgeInsets.only(top:30, left: 10),
                              child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only( top:30, left: 20.0),
                              child: Container(
                                height: 300,
                                width: 180,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 16,),
                                    Center(
                                      child: Text(
                                        'Reset your password. Get password reset otp on your registered email',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    SizedBox(height: 60.0),
                        Padding(
                          padding: const EdgeInsets.only(left:48.0, right:48.0),
                          child: PrimaryColorOverride(
                            child: TextFormField(
                              style: textStyle,
                              obscureText: false,
                              controller: emailController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return appStateModel
                                      .blocks.localeText.pleaseEnterValidEmail;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  errorStyle: errorStyle,
                                  labelStyle: labelStyle,
                                  border: InputBorder.none,
                                  labelText: appStateModel.blocks.localeText.email),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        RoundedLoadingButton(
                          color: Colors.white,
                          elevation: 0,
                          valueColor: Colors.black,
                          child: Text(appStateModel.blocks.localeText.sendOtp, style: TextStyle(color: Color(0xFF00363a),fontSize: 20)),
                          controller: _btnController,
                          onPressed: () => _sendOtp(context),
                          animateOnTap: false,
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ));
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
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Material(child: ResetPassword(email: emailController.text,))));
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
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00363a),
      body: Builder(
        builder: (context) => Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: Theme.of(context).brightness != Brightness.dark ?
              BoxDecoration(
                gradient:
                LinearGradient(
                    stops: [0.6, 1],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Color(0xFF00363a), Color(0xFF006064)]),):
              BoxDecoration(
                  color: Colors.black
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                shrinkWrap: true,
                children: [
                  new Form(
                    key: _formKey,
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                            icon: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  //color: Colors.grey.withOpacity(0.5),
                                ),
                                width: 35,
                                height: 35,
                                child: Icon(Icons.arrow_back, color: Colors.white, size: 22,)
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        Row(
                          crossAxisAlignment:CrossAxisAlignment.start ,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top:30, left: 10),
                              child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only( top:30, left: 20.0),
                              child: Container(
                                height: 250,
                                width: 180,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 16,),
                                    Center(
                                      child: Text(
                                        'Enter OTP you have recieved on your email and New Password',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,),
                        Padding(
                          padding: const EdgeInsets.only(left:24.0, right:24.0),
                          child: PrimaryColorOverride(
                            child: TextFormField(
                              style: textStyle,
                              obscureText: false,
                              controller: otpController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterOtp;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                errorStyle: errorStyle,
                                labelStyle: labelStyle,
                                  labelText: appStateModel.blocks.localeText.otp,),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:24.0, right:24.0),
                          child: PrimaryColorOverride(
                            child: TextFormField(
                              style: textStyle,
                              obscureText: _obscureText,
                              controller: newPasswordController,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return appStateModel.blocks.localeText.pleaseEnterPassword;
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  errorStyle: errorStyle,
                                  labelStyle: labelStyle,
                                  suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility : Icons.visibility_off,color: Colors.white54,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      }
                                  ),
                                  labelText: appStateModel.blocks.localeText.newPassword),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        RoundedLoadingButton(
                          color: Colors.white,
                          elevation: 0,
                          valueColor: Colors.black,
                          child: Text(appStateModel.blocks.localeText.resetPassword, style: TextStyle(color:Color(0xFF00363a),fontSize: 20)),
                          controller: _btnController,
                          onPressed: () => _resetPassword(context),
                          animateOnTap: false,
                          width: 200,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
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

