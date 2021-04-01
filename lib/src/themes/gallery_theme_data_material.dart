// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class GalleryThemeData {


  static ThemeData lightThemeData = themeDataLight();
  static ThemeData darkThemeData = themeDataDark();

  static ThemeData lightArabicThemeData = themeArabicDataLight();
  static ThemeData darkArabicThemeData = themeArabicDataDark();

  static ThemeData themeDataLight() {
    return ThemeData(
      primarySwatch: Colors.red,
      primaryColor: Colors.red,
      //*** For White App Bar ***/
      primaryTextTheme: _textTheme.apply(bodyColor: Colors.black),
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: Colors.black),
        color: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
      ),
      primaryIconTheme: IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: Colors.black,),


        buttonTheme: ButtonThemeData(
        buttonColor: Colors.red,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: Colors.red,//Color(0xff6200ee),
            primaryVariant: Colors.redAccent,//const Color(0xff3700b3),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xffb00020),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData themeDataDark() {
    return ThemeData(
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          buttonColor:Color(0xff03dac6),
          //shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: new ColorScheme(
              primary: Color(0xff03dac6),
              primaryVariant: const Color(0xff03dac6),
              secondary: const Color(0xff03dac6),
              secondaryVariant: const Color(0xff03dac6),
              background: const Color(0xff000000),
              surface: const Color(0xff121212),
              error: Color(0xffb00020),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light),
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: Colors.black87
    );
  }

  static ThemeData themeArabicDataLight() {
    return ThemeData(
      primarySwatch: Colors.red,

      //*** For White App Bar ***/
      primaryTextTheme: _textTheme.apply(bodyColor: Colors.black),
      appBarTheme: AppBarTheme(
        textTheme: _textTheme.apply(bodyColor: Colors.black),
        color: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        brightness: Brightness.light,
      ),
      primaryIconTheme: IconThemeData(color: Colors.black),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.black,
        labelColor: Colors.black,),


      buttonTheme: ButtonThemeData(
        buttonColor: Colors.green,
        //shape: StadiumBorder(),
        textTheme: ButtonTextTheme.primary,
        height: 45.0,
        colorScheme: new ColorScheme(
            primary: Colors.green,//Color(0xff6200ee),
            primaryVariant: Colors.greenAccent,//const Color(0xff3700b3),
            secondary: Color(0xff03dac6),
            secondaryVariant: const Color(0xff018786),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xffb00020),
            onPrimary: Colors.white,
            onSecondary: Colors.black,
            onSurface: Colors.black,
            onBackground: Colors.black,
            onError: Colors.white,
            brightness: Brightness.light),
      ),
      scaffoldBackgroundColor: Colors.white,
    );
  }

  static ThemeData themeArabicDataDark() {
    return ThemeData(
        brightness: Brightness.dark,
        buttonTheme: ButtonThemeData(
          buttonColor:Color(0xff03dac6),
          //shape: StadiumBorder(),
          textTheme: ButtonTextTheme.primary,
          height: 45.0,
          colorScheme: new ColorScheme(
              primary: Color(0xff03dac6),
              primaryVariant: const Color(0xff03dac6),
              secondary: const Color(0xff03dac6),
              secondaryVariant: const Color(0xff03dac6),
              background: const Color(0xff000000),
              surface: const Color(0xff121212),
              error: Color(0xffb00020),
              onPrimary: Colors.black,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onBackground: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light),
        ),
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        backgroundColor: Colors.black,
        cardColor: Colors.black87
    );
  }

  static TextTheme _textTheme = TextTheme(
    headline4: _GalleryTextStyles.display1,
    headline3: _GalleryTextStyles.display2,
    headline2: _GalleryTextStyles.display3,
    headline1: _GalleryTextStyles.display4,
    caption: _GalleryTextStyles.studyTitle,
    headline5: _GalleryTextStyles.categoryTitle,
    subtitle1: _GalleryTextStyles.listTitle,
    overline: _GalleryTextStyles.listDescription,
    bodyText2: _GalleryTextStyles.sliderTitle,
    subtitle2: _GalleryTextStyles.settingsFooter,
    bodyText1: _GalleryTextStyles.options,
    headline6: _GalleryTextStyles.title,
    button: _GalleryTextStyles.button,
  );

}

class _GalleryTextStyles {
  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static const _montserrat = 'Montserrat';
  static const _oswald = 'Oswald';

  static const display1 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const display2 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 14.0,
  );

  static const display3 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 12.0,
  );

  static const display4 = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 10.0,
  );

  static const studyTitle = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _semiBold,
    fontSize: 16.0,
  );

  static const categoryTitle = TextStyle(
    //fontFamily: _oswald,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listTitle = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 16.0,
  );

  static const listDescription = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 12.0,
  );

  static const sliderTitle = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 14.0,
  );

  static const settingsFooter = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _medium,
    fontSize: 14.0,
  );

  static const options = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _regular,
    fontSize: 16.0,
  );

  static const title = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _bold,
    fontSize: 16.0,
  );

  static const button = TextStyle(
    //fontFamily: _montserrat,
    fontWeight: _semiBold,
    fontSize: 14.0,
  );
}


ColorScheme lightColorScheme = ColorScheme(
  primary: Colors.blue,
  primaryVariant: Colors.blue[700],
  secondary: Colors.blue[700],
  secondaryVariant: const Color(0xFF000000),
  background: const Color(0xFFFFFFFF),
  surface: const Color(0xFFFFFFFF),
  onBackground: Colors.black,
  error: Colors.black,
  onError: Colors.black,
  onPrimary: Colors.black,
  onSecondary: Colors.black,
  onSurface: const Color(0xFF241E30),
  brightness: Brightness.light,
);