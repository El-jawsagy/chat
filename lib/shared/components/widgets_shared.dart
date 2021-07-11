import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateAndFinish(
  context,
  screenName,
) =>
    Navigator.pushNamedAndRemoveUntil(
      context,
      screenName,
      (route) {
        return false;
      },
    );
void navigateTo(
  context,
  screenName,
) =>
    Navigator.pushNamed(
      context,
      screenName,
    );

void showToast({
  @required String text,
  ToastStates state = ToastStates.SUCCESS,
}) =>
    Fluttertoast.showToast(
      msg: text.toString(),
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

/// Toast Length
/// Only for Android Platform

Color chooseToastColor(ToastStates state) {
  Color color;

  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}
