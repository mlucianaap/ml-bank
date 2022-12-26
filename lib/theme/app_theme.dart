import 'package:flutter/material.dart';
import 'package:mlbank/utils/constants.dart';

ThemeData appThemeData = ThemeData(
  primarySwatch: Constants.mycolor,
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: Constants.ligthBlue),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2.5,
        color: Constants.ligthGrey,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    border: OutlineInputBorder(
      borderSide: const BorderSide(width: 3, color: Constants.ligthGrey),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 3, color: Constants.ligthBlue),
      borderRadius: BorderRadius.circular(10),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 3, color: Constants.ligthGrey),
      borderRadius: BorderRadius.circular(10),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 3, color: Constants.ligthBlue),
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 10,
    ),
    labelStyle: const TextStyle(color: Constants.midleGrey),
  ),
  fontFamily: 'Inter',
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 32.0,
      color: Constants.darkBlue,
    ),
    headline2: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'Comfortaa',
      fontSize: 24.0,
      color: Constants.darkBlue,
    ),
    headline3: TextStyle(
      fontFamily: 'Comfortaa',
      fontSize: 20.0,
      color: Constants.darkBlue,
    ),
    headline4: TextStyle(
      fontSize: 16.0,
      color: Constants.darkBlue,
    ),
    headline5: TextStyle(
      fontSize: 14.0,
      color: Constants.darkBlue,
    ),
    headline6: TextStyle(
      fontSize: 12.0,
      color: Constants.darkBlue,
    ),
    bodyText1: TextStyle(
      fontSize: 15.0,
      color: Constants.grey,
    ),
    bodyText2: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15.0,
      color: Constants.ligthBlue,
    ),
  ),
);
