


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}


String formatDate(String dateTime) {
  DateTime newDate = DateTime.parse(dateTime);
  final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm a');
  final String date = formatter.format(newDate);
  return date;
}

displayToast(
    String message,
    ) {
  Fluttertoast.showToast(
      msg: message,
      textColor: Colors.white,
      fontSize: 14,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.indigo.shade900,
      timeInSecForIosWeb: 1);
}