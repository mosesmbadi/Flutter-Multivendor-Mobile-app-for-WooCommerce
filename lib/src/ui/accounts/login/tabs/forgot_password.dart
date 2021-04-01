//import './../../../../../l10n/gallery_localizations.dart';
import 'package:flutter/material.dart';

import './../../../../models/app_state_model.dart';
import './../../../../resources/api_provider.dart';
import './../tabs/register_text_form_field.dart';
import '../../../color_override.dart';
import '../../../widgets/buttons/button_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({
    Key key,
    @required this.context,
    @required this.model,
    @required this.emailController,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TextEditingController emailController;
  final TabController tabController;

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();

  //TextEditingController emailController = new TextEditingController();

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
                  height: 150,
                ),
                PrimaryColorOverride(
                  child: CustomTextFormField(
                    controller: widget.emailController,
                    label: widget.model.blocks.localeText.email,
                    validationMsg: widget
                        .model.blocks.localeText.pleaseEnterValidEmail,
                    password: false,
                    inputType: TextInputType.emailAddress,
                    icon: Icons.email,
                  ),
                ),
                SizedBox(height: 24.0),
                RaisedButton(
                  child: ButtonText(isLoading: isLoading, text: 'Send OTP'),
                  onPressed: () => isLoading ? null : _sendOtp(),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                    padding: EdgeInsets.all(16.0),
                    onPressed: () {
                      widget.tabController.animateTo(0);
                    },
                    child: Text(
                        widget.model.blocks.localeText.signIn,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(
                            color:
                            Theme.of(context).accentColor))),
              ],
            ),
          ),
        ),
      ],
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
        widget.tabController.animateTo(3);
      }
    }
  }
}

class ResetPassword extends StatefulWidget {
  ResetPassword({
    Key key,
    @required this.context,
    @required this.model,
    @required this.emailController,
    @required this.tabController,
  }) : super(key: key);

  final BuildContext context;
  final AppStateModel model;
  final TextEditingController emailController;
  final TabController tabController;

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final apiProvider = ApiProvider();

  TextEditingController otpController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: new Form(
              key: _formKey,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  PrimaryColorOverride(
                    child: CustomTextFormField(
                      controller: otpController,
                      label: widget.model.blocks.localeText.otp,
                      validationMsg:
                          widget.model.blocks.localeText.pleaseEnterOtp,
                      password: false,
                      inputType: TextInputType.text,
                      icon: Icons.message,
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  PrimaryColorOverride(
                    child: CustomTextFormField(
                      controller: newPasswordController,
                      label: widget.model.blocks.localeText.newPassword,
                      validationMsg:
                          widget.model.blocks.localeText.pleaseEnterPassword,
                      password: true,
                      inputType: TextInputType.text,
                      icon: Icons.vpn_key,
                    ),
                  ),
                  SizedBox(height: 24.0),
                  RaisedButton(
                    child: ButtonText(isLoading: isLoading, text: widget.model.blocks.localeText.resetPassword,),
                    onPressed: () => isLoading ? null : _resetPassword(widget.model),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
      print(data);
      final response = await apiProvider.postWithCookies(
          '/wp-admin/admin-ajax.php?action=mstore_flutter-reset-user-password',
          data);
      if (response.statusCode == 200) {
        widget.tabController.animateTo(0);
      }
      setState(() {
        isLoading = false;
      });
    }
    //TODO Call api to send otp
  }
}
