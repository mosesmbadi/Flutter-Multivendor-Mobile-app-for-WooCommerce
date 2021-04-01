import 'package:flutter/material.dart';

class ThemeOverride extends StatelessWidget {
  const ThemeOverride({Key key, this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Theme(
      child: child,
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
        backgroundColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        buttonColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: ColorScheme(
              primary: Colors.red,//Color(0xff6200ee),
              primaryVariant: Colors.redAccent,//const Color(0xff3700b3),
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.black, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.red, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.red, width: 1.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    ) : Theme(
      child: child,
      data: ThemeData(
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark
        ),
        brightness: Brightness.dark,
        primaryColor: Colors.blue,
        accentColor: Colors.cyan[600],
        backgroundColor: Colors.pink,
        scaffoldBackgroundColor: Colors.pink,
        buttonColor: Colors.white,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white,
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: ColorScheme(
              primary: Colors.red,//Color(0xff6200ee),
              primaryVariant: Colors.redAccent,//const Color(0xff3700b3),
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
          filled: true,
          errorStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          labelStyle: TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.white, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.white, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide:
            BorderSide(color: Colors.white, width: 1.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        ),
      ),
    );
  }
}