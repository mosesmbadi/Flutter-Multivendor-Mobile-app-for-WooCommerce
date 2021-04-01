import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/register_model.dart';
import './../../../../ui/widgets/buttons/button.dart';
import '../../../color_override.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final appStateModel = AppStateModel();
  RegisterModel _register = RegisterModel();
  bool _obscureText = true;
  var isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (context) => ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 15.0),
              Container(
                margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                child:  Form(
                  key: _formKey,
                  child:  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                        child: Container(
                          constraints: BoxConstraints(minWidth: 120, maxWidth: 220),
                          child: Image.asset(
                            'lib/assets/images/logo.png',
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.firstName = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterFirstName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.firstName),
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.lastName = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterLastName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.lastName),
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          onSaved: (val) =>
                              setState(() => _register.email = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: appStateModel.blocks.localeText.email),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      SizedBox(height: 12,),
                      PrimaryColorOverride(
                        child: TextFormField(
                          obscureText: _obscureText,
                          onSaved: (val) =>
                              setState(() => _register.password = val),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterPassword;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  }
                              ),
                              labelText: appStateModel.blocks.localeText.password),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      SizedBox(height: 30.0),
                      RoundedLoadingButton(
                        elevation: 0,
                        child: Text(appStateModel.blocks.localeText.signIn, style: TextStyle(color: Theme.of(context).buttonTheme.colorScheme.onPrimary)),
                        controller: _btnController,
                        valueColor: Theme.of(context).buttonTheme.colorScheme.onPrimary,
                        onPressed: () => _submit(context),
                        animateOnTap: false,
                        width: 200,
                      ),
                      SizedBox(height: 30.0),
                      FlatButton(
                          padding: EdgeInsets.all(16.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  appStateModel.blocks.localeText
                                      .alreadyHaveAnAccount,
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 15,
                                      color: Colors.grey)),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    appStateModel.blocks.localeText.signIn,
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color:
                                        Theme.of(context).accentColor)),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ]),
      )
    );
  }

  Future _submit(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _btnController.start();
      bool status = await appStateModel.register(_register.toJson(), context);
      _btnController.stop();
      if (status) {
        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
      }
    }
  }

}
