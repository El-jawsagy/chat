import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeShared {
  static const Color primary = Color(0xff34626C);
  static const Color secondry = Color(0xffBDC7C9);

  //colors for button background
  static const Color backGround = Color(0xffCFD3CE);
  static const Color greybackGround = Color(0xffF5EFEF);
  static const Color facebookBackGround = Color(0xff1a538a);

  //colors for text in app
  static const Color textHighPriortyColor = Color(0xff845460);
  static const Color textLightColor = Colors.white;
  static const Color textDarkColor = Colors.black;

  // this is  function return light theme App config.
  static ThemeData getLightTheme() => ThemeData(
        primaryColor: primary,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textLightColor,
          ),
          headline2: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textLightColor,
          ),
          headline3: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: textLightColor,
          ),
          headline4: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          subtitle1: TextStyle(
            fontSize: 16,
          ),
        ),
      );

  // this is  function return dark theme App config.
  ThemeData getDarkTheme() => ThemeData();
}
