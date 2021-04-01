import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import './../../../../models/app_state_model.dart';
import './../../../accounts/login/social/apple_login.dart';
import './../../../accounts/login/social/facebook_login.dart';
import './../../../accounts/login/social/google_login.dart';
import './../../../accounts/login/social/sms_login.dart';
import './../tabs/login_text_form_field.dart';
import '../../../color_override.dart';
import '../../../widgets/buttons/button_text.dart';

class LoginTab extends StatefulWidget {
  LoginTab({
    Key key,
    @required this.context,
    @required this.model,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TabController tabController;

  @override
  _LoginTabState createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Form(
            key: _formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                PrimaryColorOverride(
                  child: CustomTextFormField(
                    controller: usernameController,
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    label: widget.model.blocks.localeText.username,
                    password: false,
                    validationMsg: widget
                        .model.blocks.localeText.pleaseEnterUsername,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                PrimaryColorOverride(
                  child: CustomTextFormField(
                    controller: passwordController,
                    icon: Icons.vpn_key,
                    inputType: TextInputType.text,
                    label: widget.model.blocks.localeText.password,
                    password: true,
                    validationMsg: widget
                        .model.blocks.localeText.pleaseEnterPassword,
                  ),
                ),
                SizedBox(height: 24.0),
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
                        style: Theme.of(context).textTheme.bodyText2)),
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
                            style: Theme.of(context).textTheme.bodyText2),
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
                    children: [
                      Card(
                        shape: StadiumBorder(),
                        margin: const EdgeInsets.all(8.0),
                        child: GoogleLoginWidget(),
                      ),
                      Card(
                        shape: StadiumBorder(),
                        margin: const EdgeInsets.all(8.0),
                        child: FacebookLoginWidget(),
                      ),
                      Platform.isIOS ? Card(
                        shape: StadiumBorder(),
                        margin: const EdgeInsets.all(8.0),
                        child: AppleLogin(),
                      ) : Container(),
                      Card(
                        shape: StadiumBorder(),
                        margin: const EdgeInsets.all(8.0),
                        child: SmsLogin(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _login(BuildContext) async {
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



