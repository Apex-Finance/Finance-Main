import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthChanger with ChangeNotifier {
  var selectedMonth = DateTime.now().month;
  var selectedYear = DateTime.now().year;

  static const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  void changeMonth(String direction) {
    if (direction == 'back') {
      if (selectedMonth == 1) {
        selectedMonth = 12;
        selectedYear -= 1;
      } else
        selectedMonth -= 1;
    } else if (direction == 'forward') {
      if (selectedMonth == 12) {
        selectedMonth = 1;
        selectedYear += 1;
      } else
        selectedMonth += 1;
    }
    notifyListeners();
    return;
  }
}
