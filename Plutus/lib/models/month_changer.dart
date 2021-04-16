import 'package:flutter/material.dart';

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

  Row buildMonthChanger(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (selectedMonth > DateTime.now().month ||
            selectedYear >= DateTime.now().year)
          IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => changeMonth('back')),
        if (selectedMonth == DateTime.now().month &&
            selectedYear ==
                DateTime.now().year -
                    1) // keep width constant if looking at earliest available month
          SizedBox(width: 32.0, height: 32.0),
        Text(
          '${MonthChanger.months[selectedMonth - 1]}' +
              (selectedYear == DateTime.now().year ? '' : ' $selectedYear'),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
        if (selectedMonth < DateTime.now().month ||
            selectedYear <= DateTime.now().year)
          IconButton(
              icon: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () => changeMonth('forward')),
        if (selectedMonth == DateTime.now().month &&
            selectedYear ==
                DateTime.now().year +
                    1) // keep width constant if looking at latest available month
          SizedBox(width: 32.0, height: 32.0),
      ],
    );
  }
}
