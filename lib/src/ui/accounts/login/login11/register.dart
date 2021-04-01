import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import 'clipper.dart';
import './../../../../ui/color_override.dart';
import 'theme_override.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final _formKey = GlobalKey<FormState>();
  final appStateModel = AppStateModel();
  var formData = new Map<String, dynamic>();
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ThemeOverride(
      child: Builder(
        builder: (context) => Scaffold(
          body: Builder(
            builder: (context) => Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: height * 0.10,
                        ),
                        Text('Hearty Welcome !', style: Theme.of(context).textTheme.headline6.copyWith(
                          //color: Colors.white,
                            fontSize: 32
                        )),
                        Text('Sign up to create an account', style: Theme.of(context).textTheme.caption.copyWith(
                          //color: Colors.white,
                            fontSize: 14
                        )),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        TextFormField(
                          onSaved: (value) => setState(() => formData['first_name'] = value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterFirstName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                            labelText: appStateModel.blocks.localeText.firstName ,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,),
                        TextFormField(
                          onSaved: (value) => setState(() => formData['last_name'] = value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterLastName;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                            labelText: appStateModel.blocks.localeText.lastName ,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,),
                        TextFormField(
                          onSaved: (value) => setState(() => formData['email'] = value),
                          validator: (value) {
                            if (value.isEmpty) {
                              return appStateModel.blocks.localeText.pleaseEnterValidEmail;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            //suffixIcon: obscureText == true ? Icon(Icons.remove_red_eye) : Container(),
                            labelText: appStateModel.blocks.localeText.email ,
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,),
                        TextFormField(
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
                          obscureText: true,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,),
                        RoundedLoadingButton(
                          color: Theme.of(context).buttonColor,
                          elevation: 0,
                          valueColor: Theme.of(context).buttonTheme.colorScheme.onPrimary,
                          child: Text(appStateModel.blocks.localeText.signUp),
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
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                    'Already registered?',
                                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        fontSize: 15,
                                      color: Colors.white,
                                    )),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                      'Sign In',
                                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            )),],
                    ),
                  ),
                ),
                Positioned(
                    top: 48,
                    left: 16,
                    child: IconButton(
                        icon: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              //color: Colors.grey.withOpacity(0.5),
                            ),
                            width: 35,
                            height: 35,
                            child: Icon(Icons.arrow_back, size: 18,)
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _submit(BuildContext context) async {
    _btnController.start();
    bool status = await appStateModel.register(formData, context);
    if (status) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }
    _btnController.stop();
  }

  onSaved(String value, String field) {
    formData[field] = value;
  }

  onValidate(String value, String label) {
    if (value.isEmpty) {
      return label + ' ' + appStateModel.blocks.localeText.isRequired;
    }
    return null;
  }
}



