import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../login3/phone_verification.dart';

class SmsLogin extends StatelessWidget {
  const SmsLogin({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: StadiumBorder(),
      margin: EdgeInsets.all(0),
      color: Color(0xFF34B7F1),
      child: Container(
        height: 50,
        width: 50,
        child: IconButton(
          //splashRadius: 25.0,
          icon: Icon(
            FontAwesomeIcons.sms,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () async {
            dynamic response = await showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) => PhoneVerification(
                  fullscreen: false,
                )
            );
            if(response == true){
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }
}