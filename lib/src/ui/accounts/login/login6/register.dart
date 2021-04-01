import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../ui/accounts/login/login6/clipper.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
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
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height *.1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xff041F5F)),
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
                  /*Positioned(
                    top: 10,
                    child: Container(
                        height: MediaQuery.of(context).size.height *.3,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset('lib/assets/images/blue.png',fit: BoxFit.fitWidth,
                        )
                    ),
                  ),*/
                  Container(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: height * 0.050,
                          ),
                          Text('Hearty Welcome !', style: Theme.of(context).textTheme.headline6.copyWith(
                            //color: Colors.white,
                              fontSize: 16,color: Colors.white70
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Sign Up', style: Theme.of(context).textTheme.caption.copyWith(
                            //color: Colors.white,
                              fontSize: 32,color: Colors.white, fontWeight: FontWeight.w700
                          )),
                          SizedBox(
                            height: height * 0.15,
                          ),
                          PrimaryColorOverride(
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
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
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,),
                          PrimaryColorOverride(
                            child: TextFormField(
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
                                "Sign Up",style:  TextStyle(
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
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                      'Already registered?',
                                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                                          fontSize: 15,
                                      )),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                        'Sign In',
                                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                                            color: Color(0xff02A4E6),
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )),],
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
                ],
              ),
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



