import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './../../../../models/app_state_model.dart';
import './../../login/social/apple_login.dart';
import './../../login/social/facebook_login.dart';
import './../../login/social/google_login.dart';
import './../../login/social/sms_login.dart';
import '../../../widgets/buttons/button_text.dart';

class LoginTab extends StatefulWidget {

  LoginTab({Key key, @required this.context,
    @required this.model,
    @required this.tabController,}) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TabController tabController;
  final appStateModel = AppStateModel();
  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {


  bool _obscureText;
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obscureText = true;
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          SizedBox(height: 15.0),
          Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child:  Form(
              key: _formKey,
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    height: 220,
                    constraints: BoxConstraints(minWidth: 220, maxWidth: 220),
                    child: Image.asset(
                      'lib/assets/images/logo.png',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildIcon(Icon(Icons.email,color: Colors.grey.withOpacity(.6),)),
                      SizedBox(width: 20,),
                      Flexible(
                          child: CustomTextFormField(
                            controller: usernameController,
                            obscureText: false,
                            inputType: TextInputType.emailAddress,
                            label: widget.model.blocks.localeText.username,
                            validationMsg: widget
                                .model.blocks.localeText.pleaseEnterUsername,
                            password: false,
                          )
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildIcon(Icon(Icons.lock,color: Colors.grey.withOpacity(.6),)),
                      SizedBox(width: 20,),
                      Flexible(
                        child: CustomTextFormField(
                          controller: passwordController,
                          inputType: TextInputType.text,
                          obscureText: _obscureText,
                          label: widget.model.blocks.localeText.password,
                          validationMsg: widget
                              .model.blocks.localeText.pleaseEnterPassword,
                          password: true,
                          suffix: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              color: Colors.grey.withOpacity(.4),
                              onPressed: (){
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              }
                          ),

                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30.0),
                  RaisedButton(
                    child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.signIn),
                    onPressed: () => isLoading ? null : _login(context),
                  ),
                  SizedBox(height: 12.0),
                  FlatButton(
                      onPressed: () {
                        widget.tabController.animateTo(2);
                      },
                      child: Text(
                          widget.model.blocks.localeText.forgotPassword,
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 15,
                              color: Colors.grey
                          ))),
                  FlatButton(
                      padding: EdgeInsets.all(16.0),
                      onPressed: () {
                        widget.tabController.animateTo(1);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              widget.model.blocks.localeText
                                  .dontHaveAnAccount,
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                  fontSize: 15,
                                  color: Colors.grey
                              )),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                widget.model.blocks.localeText.signUp,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                    color:
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
                        ): Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 2,
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Container(
                              height: 50.0, // height of the button
                              width: 50.0,
                              child: SmsLogin(),
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
        ]);
  }

  Container buildIcon(child) {
    return Container(
      width: 30,
      height: 30,
      child: child,
    );
  }
  _login(BuildContext context) async {
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
        Navigator.of(widget.context).pop();
      }
    }
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
      obscureText: obscureText,
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return validationMsg;
        }
        return null;
      },
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(.4)),
        ),
        suffixIcon: suffix,
        labelText: label,
        labelStyle: TextStyle(
            fontFamily: 'Monteserrat',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey.withOpacity(.4)
        ),),
      keyboardType: inputType,
    );
  }
}