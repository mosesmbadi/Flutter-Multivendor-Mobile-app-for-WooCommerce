import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import 'otp_verification.dart';
import 'theme_override.dart';

class PhoneNumber extends StatefulWidget {
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  String prefixCode = '+91';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  final appStateModel = AppStateModel();
  TextEditingController phoneNumberController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    prefixCode = appStateModel.blocks.settings.countryDialCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ThemeOverride(
      child: Builder(
        builder: (context) => Scaffold(
          body: Builder(
            builder: (context) => Stack(children: [
              Container(
                padding: EdgeInsets.all(32),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.15,
                      ),
                      Text('Phone Verification !',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              //color: Colors.white,
                              fontSize: 32)),
                      Text('Enter valid Mobile Number to get an OTP',
                          style: Theme.of(context).textTheme.caption.copyWith(
                              //color: Colors.white,
                              fontSize: 14)),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      SizedBox(
                        height: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CountryCodePicker(
                              onChanged: _onCountryChange,
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: appStateModel.blocks.settings.defaultCountry,
                              favorite: [prefixCode, appStateModel.blocks.settings.defaultCountry],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width - 170,
                              child: TextFormField(
                                obscureText: false,
                                controller: phoneNumberController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return appStateModel
                                        .blocks.localeText.pleaseEnterPhoneNumber;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    labelText: appStateModel
                                        .blocks.localeText.phoneNumber),
                                keyboardType: TextInputType.number,
                              ),
                            )
                          ],
                        ),
                      ),
                      RoundedLoadingButton(
                        color: Theme.of(context).buttonColor,
                        elevation: 0,
                        valueColor: Theme.of(context).buttonTheme.colorScheme.onPrimary,
                        child: Text(appStateModel.blocks.localeText.sendOtp),
                        controller: _btnController,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            sendOTP(context);
                          }
                        },
                        animateOnTap: false,
                        width: MediaQuery.of(context).size.width - 34,
                      ),
                    ],
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
                          child: Icon(
                            Icons.arrow_back,
                            size: 18,
                          )),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }))
            ]),
          ),
        ),
      ),
    );
  }

  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      prefixCode = countryCode.toString();
    });
  }

  onOTPSent(String verificationId) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Material(
            child: OTPVerification(
                verificationId: verificationId,
                phoneNumber:
                    prefixCode + phoneNumberController.text.toString()))));
    //TODO Navigate to OTP Verification Page
  }

  onVerificationCompleted(AuthCredential phoneAuthCredential) {
    //TODO Wordpress Login User
  }

  Future<void> sendOTP(BuildContext context) async {
    _btnController.start();
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: prefixCode + phoneNumberController.text.toString(),
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
            //onOTPSent(verId, phoneController.text);
          },
          codeSent: (String verId, [int forceCodeResend]) {
            _btnController.stop();
            onOTPSent(verId);
          },
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            onVerificationCompleted(phoneAuthCredential);
            await _auth.signInWithCredential(phoneAuthCredential);
            _btnController.stop();
          },
          verificationFailed: (exception) {
            handlePhoneNumberError(exception, context);
            _btnController.stop();
          });
    } catch (e) {
      handleOtpError(e);
      _btnController.stop();
    }
  }

  handleOtpError(error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
        break;
      default:
        showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
        break;
    }
  }

  verifyOTP(String smsCode, BuildContext context) async {
    _btnController.start();
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    try {
      await _auth.signInWithCredential(phoneAuthCredential);
      //Wordpress Login user with
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, appStateModel.blocks.localeText.inValidCode);
    }
    _btnController.stop();
  }

  handlePhoneNumberError(FirebaseAuthException error, BuildContext context) {
    switch (error.code) {
      case 'TOO_LONG':
        FocusScope.of(context).requestFocus(new FocusNode());
        showSnackBar(context, appStateModel.blocks.localeText.inValidNumber);
        break;
      case 'TOO_SHORT':
        FocusScope.of(context).requestFocus(new FocusNode());
        showSnackBar(context, appStateModel.blocks.localeText.inValidNumber);
        Navigator.of(context).pop();
        break;
      case 'SESSION_EXPIRED':
        break;
      case 'INVALID_SESSION_INFO':
        break;
      default:
        showSnackBar(context, appStateModel.blocks.localeText.inValidNumber);
        break;
    }
  }

  showSnackBar(BuildContext context, String message) {
    //Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);

    final snackBar =
        SnackBar(backgroundColor: Colors.red, content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
