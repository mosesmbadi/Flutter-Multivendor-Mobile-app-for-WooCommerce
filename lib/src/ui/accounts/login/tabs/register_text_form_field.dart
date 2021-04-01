import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// RegisterTextFormField custom class
class CustomTextFormField extends StatelessWidget {
  bool password;
  String label;
  String validationMsg;
  TextEditingController controller;
  IconData icon;
  TextInputType inputType;
  FormFieldSetter onSaved;

  CustomTextFormField(
      {this.label,
      this.validationMsg,
      this.controller,
      this.icon,
      this.inputType,
      this.password,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: password,
      controller: controller,
      onSaved: onSaved,
      validator: (value) {
        if (value.isEmpty) {
          return validationMsg;
        }
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          border: InputBorder.none,
          labelText: label,
          prefixIcon: Icon(icon),
          labelStyle: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Sans',
              letterSpacing: 0.3,
              //color: Colors.black38,
              fontWeight: FontWeight.w600)),
      keyboardType: inputType,
    );
  }
}
