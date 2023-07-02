


import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:taskscheduler/utils/loading.dart';

double screenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}
showLoading(BuildContext context) {
  Dialog alert = const Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    child: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Loading(),
      ),
    ),
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.white.withOpacity(0),
    builder: (BuildContext context) {
      return SizedBox(child: alert);
    },
  );
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