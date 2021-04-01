import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../models/register_model.dart';
import './../../../../ui/accounts/login/login4/style.dart';
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
        backgroundColor: Color(0xFF00363a),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Builder(
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
              ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child:  Form(
                        key: _formKey,
                        child:  Column(
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
                                        'Sign Up',
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
                                    height: 140,
                                    width: 180,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 16,),
                                        Center(
                                          child: Text(
                                            'Create new account',
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
                                  onSaved: (val) =>
                                      setState(() => _register.firstName = val),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText.pleaseEnterFirstName;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: errorStyle,
                                      labelStyle: labelStyle,
                                      border: InputBorder.none,
                                      labelText: appStateModel.blocks.localeText.firstName),
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Padding(
                              padding: const EdgeInsets.only(left:24.0, right:24.0),
                              child: PrimaryColorOverride(
                                child: TextFormField(
                                  style: textStyle,
                                  onSaved: (val) =>
                                      setState(() => _register.lastName = val),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText.pleaseEnterLastName;
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      errorStyle: errorStyle,
                                      labelStyle: labelStyle,
                                      border: InputBorder.none,
                                      labelText: appStateModel.blocks.localeText.lastName),
                                ),
                              ),
                            ),
                            SizedBox(height: 12,),
                            Padding(
                              padding: const EdgeInsets.only(left:24.0, right:24.0),
                              child: PrimaryColorOverride(
                                child: TextFormField(
                                  style: textStyle,
                                  onSaved: (val) =>
                                      setState(() => _register.email = val),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return appStateModel.blocks.localeText.pleaseEnterValidEmail;
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
                            SizedBox(height: 12,),
                            Padding(
                              padding: const EdgeInsets.only(left:24.0, right:24.0),
                              child: PrimaryColorOverride(
                                child: TextFormField(
                                  style: textStyle,
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
                                      border: InputBorder.none,
                                      errorStyle: errorStyle,
                                      labelStyle: labelStyle,
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.white54,
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
                            ),
                            SizedBox(height: 30.0),
                            RoundedLoadingButton(
                              color: Colors.white,
                              elevation: 0,
                              child: Text(appStateModel.blocks.localeText.signUp, style: TextStyle(color: Color(0xFF00363a),fontSize: 20)),
                              controller: _btnController,
                              valueColor: Colors.black,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        appStateModel.blocks.localeText
                                            .alreadyHaveAnAccount,
                                        style: Theme.of(context).textTheme.bodyText2.copyWith(
                                            fontSize: 15,
                                            color: Colors.white.withOpacity(0.6))),
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                          appStateModel.blocks.localeText.signIn,
                                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                              color: Colors.white)),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
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
