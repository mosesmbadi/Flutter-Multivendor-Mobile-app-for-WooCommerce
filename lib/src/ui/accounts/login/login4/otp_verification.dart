import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/widgets/buttons/button.dart';

import '../../../color_override.dart';

class OTPVerification extends StatefulWidget {

  OTPVerification({
    Key key,
    @required this.verificationId,
    @required this.phoneNumber,
  }) : super(key: key);

  String verificationId;
  final String phoneNumber;

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {

  final appStateModel = AppStateModel();
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  TextEditingController otpController = new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RoundedLoadingButtonController _btnController = new RoundedLoadingButtonController();
  StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

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
            ListView(
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
                                  'Enter OTP',
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
                              height: 200,
                              width: 180,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 16,),
                                  Center(
                                    child: Text(
                                      'Enter OTP recieved on your phone',
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
                        padding: const EdgeInsets.all(24.0),
                        child: SizedBox(
                          height: 50,
                          child: PinCodeTextField(
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: false,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v.length < 6) {
                                showSnackBar(context, 'Invalid Code');
                                return null;
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                              inactiveColor: Colors.grey.withOpacity(.2),
                              inactiveFillColor: Colors.white,
                              disabledColor: Colors.grey,
                              selectedColor: Colors.blue,
                              activeColor: Colors.black,
                              selectedFillColor: Colors.white,
                              shape: PinCodeFieldShape.box,
                              borderWidth: 2,
                              borderRadius: BorderRadius.circular(3),
                              fieldHeight: 50,
                              fieldWidth: 40,
                              activeFillColor: Colors.white,
                            ),
                            animationDuration: Duration(milliseconds: 300),
                            backgroundColor: Colors.transparent,
                            // backgroundColor: Colors.transparent,
                            enableActiveFill: true,
                            errorAnimationController: errorController,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            onCompleted: (v) {
                              //
                            },
                            onChanged: (value) {
                              print(value);
                            },
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      RoundedLoadingButton(
                        color: Colors.white,
                        elevation: 0,
                        valueColor: Colors.black,
                        child: Text(appStateModel.blocks.localeText.signIn, style: TextStyle(color: Color(0xFF00363a),fontSize: 20)),
                        controller: _btnController,
                        onPressed: () {
                          verifyOTP(context);
                        },
                        animateOnTap: false,
                        width: 200,
                      ),
                      SizedBox(height: 30.0),
                      Align(
                        alignment: Alignment.center,
                        child: FlatButton(
                            onPressed: () {
                              sendOTP(context);
                            },
                            child: Text(
                                appStateModel.blocks.localeText.resendOTP,
                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.6)
                                ))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  verifyOTP(BuildContext context) async {

    _btnController.start();

    //Server end verification
    var data = new Map<String, dynamic>();
    data["smsOTP"] = otpController.text;
    data["verificationId"] = widget.verificationId;
    data["phoneNumber"] = widget.phoneNumber;
    bool status = await appStateModel.phoneLogin(data, context);
    if (status) {
      Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
    }

    //Local verification. Do not use this, Use server end verification instead
    /*PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: otpController.text);
    try {
      await _auth.signInWithCredential(phoneAuthCredential);
      //Wordpress Login user with
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, 'The SMS verification code used is invalid.');
    }*/

    _btnController.stop();
  }

  showSnackBar(BuildContext context, String message) {
    //Fluttertoast.showToast(msg: message, gravity: ToastGravity.TOP);

    final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> sendOTP(BuildContext context) async {
    _btnController.start();
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          codeAutoRetrievalTimeout: (String verId) {
            widget.verificationId = verId;
          },
          codeSent: (String verId, [int forceCodeResend]) {
            _btnController.stop();
            widget.verificationId = verId;
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

  onVerificationCompleted(AuthCredential phoneAuthCredential) {
    //TODO Wordpress Login User
  }
}
