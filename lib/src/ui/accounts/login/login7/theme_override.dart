import 'package:flutter/material.dart';
import 'package:gradient_input_border/gradient_input_border.dart';

class ThemeOverride extends StatelessWidget {
  ThemeOverride({Key key, this.child}) : super(key: key);
  final Widget child;

  final LinearGradient gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xff02A4E6),
        Color(0xff041F5F),
      ]);
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? Theme(
            child: child,
            data: ThemeData(
                brightness: Brightness.dark,
                primaryColor: Colors.lightBlue[800],
                accentColor: Colors.cyan[600],
                backgroundColor: isDark ? Colors.black : Colors.white,
                scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
                buttonColor: Colors.white,
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.white,
                  textTheme: ButtonTextTheme.primary,
                  height: 45.0,
                  colorScheme: ColorScheme(
                      primary: Colors.red, //Color(0xff6200ee),
                      primaryVariant:
                          Colors.redAccent, //const Color(0xff3700b3),
                      secondary: Color(0xff03dac6),
                      secondaryVariant: const Color(0xff018786),
                      surface: Colors.white,
                      background: Colors.white,
                      error: Color(0xffb00020),
                      onPrimary: Colors.black,
                      onSecondary: Colors.black,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onError: Colors.white,
                      brightness: Brightness.light),
                ),
                inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    fillColor: Colors.grey.shade400,
                    filled: true)),
          )
        : Theme(
            child: child,
            data: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.lightBlue[500],
                accentColor: Colors.cyan[600],
                backgroundColor: isDark ? Colors.black : Colors.white,
                scaffoldBackgroundColor: isDark ? Colors.black : Colors.white,
                buttonColor: Colors.white,
                buttonTheme: ButtonThemeData(
                  buttonColor: Colors.white,
                  textTheme: ButtonTextTheme.primary,
                  height: 45.0,
                  colorScheme: ColorScheme(
                      primary: Colors.red, //Color(0xff6200ee),
                      primaryVariant:
                          Colors.redAccent, //const Color(0xff3700b3),
                      secondary: Color(0xff03dac6),
                      secondaryVariant: const Color(0xff018786),
                      surface: Colors.white,
                      background: Colors.white,
                      error: Color(0xffb00020),
                      onPrimary: Colors.black,
                      onSecondary: Colors.black,
                      onSurface: Colors.black,
                      onBackground: Colors.black,
                      onError: Colors.white,
                      brightness: Brightness.light),
                ),
                inputDecorationTheme: InputDecorationTheme(
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    fillColor: Color(0xfff3f3f4),
                    filled: true)),
          );
  }
}
