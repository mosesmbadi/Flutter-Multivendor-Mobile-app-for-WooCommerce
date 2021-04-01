import 'package:flutter/material.dart';

class PrimaryColorOverride extends StatelessWidget {
  const PrimaryColorOverride({Key key, this.child}) : super(key: key);

  //final color = Theme.of(context).accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;//Theme.of(context).accentColor;
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(primaryColor: color),
    );
  }
}