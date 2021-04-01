import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BaseTextField extends StatelessWidget {
  final Widget suffix;
  final String labelText;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String initialValue;

  BaseTextField({
    this.suffix,
    this.labelText,
    this.hintText,
    this.inputFormatters,
    this.onSaved,
    this.validator,
    this.controller,
    this.initialValue,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      validator: validator,
      maxLines: 1,
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: new InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 14.0),
        suffixIcon: suffix == null
            ? null
            : new Padding(
          padding: const EdgeInsetsDirectional.only(end: 12.0),
          child: suffix,
        ),
        errorStyle: const TextStyle(fontSize: 12.0),
        errorMaxLines: 3,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
        hintText: hintText,
      ),
    );
  }
}
