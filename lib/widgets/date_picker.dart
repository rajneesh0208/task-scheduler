import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskscheduler/constants/app_colors.dart';
import 'package:taskscheduler/state_management/date_selector_provider.dart';

Future<DateTime?> pickDate(BuildContext context) async {
  DateSelector dateSelector =
  Provider.of(context, listen: false);
  DateTime? dateTime = await showDatePicker(
    initialEntryMode: DatePickerEntryMode.calendar,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.purpleBackground, // header background color
            onPrimary: AppColors.white, // header text color
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // button text color
            ),
          ),
        ),
        child: child!,
      );
    },
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2099),
    initialDate: DateTime.now(),
  );

  // if (dateTime == null) return;
await dateSelector.selectDate(dateTime!);
  return dateTime;
}