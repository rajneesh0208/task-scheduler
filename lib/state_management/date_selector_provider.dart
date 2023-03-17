import 'package:flutter/cupertino.dart';

class DateSelector with ChangeNotifier{

  DateTime eventDate = DateTime.now();

  selectDate(date){
    eventDate = date;
    notifyListeners();
  }

}