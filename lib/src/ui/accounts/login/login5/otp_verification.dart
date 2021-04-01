import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import './../../../../models/app_state_model.dart';
import './../../../../ui/accounts/login/login5/clipper.dart';
import 'theme_override.dart';

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
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ThemeOverride(
      child: Builder(
        builder: (context) =>  AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Builder(
              builder: (context) => Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: CurvePainter2(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: CurvePainter(color: Theme.of(context).backgroundColor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(32),
                    child: new Form(
                      key: _formKey,
                      child: new ListView(
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.15,
                          ),
                          Text('Enter OTP!', style: Theme.of(context).textTheme.headline6.copyWith(
                            //color: Colors.white,
                              fontSize: 32
                          )),
                          Text('Enter OTP to SignIn', style: Theme.of(context).textTheme.caption.copyWith(
                            //color: Colors.white,
                              fontSize: 14
                          )),
                          SizedBox(
                            height: height * 0.15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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

                                },
                                beforeTextPaste: (text) {
                                  return true;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 30.0),
                          RoundedLoadingButton(
                            color: Theme.of(context).buttonColor,
                            elevation: 0,
                            valueColor: Theme.of(context).buttonTheme.colorScheme.onPrimary,
                            child: Text(appStateModel.blocks.localeText.signIn),
                            controller: _btnController,
                            onPressed: () {
                              verifyOTP(context);
                            },
                            animateOnTap: false,
                            width: MediaQuery.of(context).size.width - 34,
                          ),
                          SizedBox(height: 30.0),
                          FlatButton(
                              onPressed: () {
                                sendOTP(context);
                              },
                              child: Text(
                                  appStateModel.blocks.localeText.resendOTP,
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                      fontSize: 15,
                                      color: Colors.white
                                  ))),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 36,
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
                          }))

                ],
              ),
            ),
          ),
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
