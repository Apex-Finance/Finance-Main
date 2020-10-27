import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_list_tile.dart';

const months = [
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

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';
  List<Transaction> transactions;

  TransactionScreen({@required this.transactions});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var selectedMonth = DateTime.now().month;
  var selectedYear = DateTime.now().year;

  List<Transaction> get monthlyTransactions {
    var unsorted = widget.transactions
        .where((transaction) =>
            transaction.date.month == selectedMonth &&
            transaction.date.year == selectedYear)
        .toList();
    unsorted.sort((a, b) => (b.date).compareTo(a.date));
    return unsorted;
  }

  double get monthlyExpenses {
    var sum = 0.00;
    for (var transaction in monthlyTransactions) {
      sum += transaction.amount;
    }
    return sum;
  }

  void changeMonth(String direction) {
    setState(() {
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
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 250,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => changeMonth('back')),
              Expanded(
                child: Center(
                  child: Text(
                    '${months[selectedMonth - 1]}' +
                        (selectedYear == DateTime.now().year
                            ? ''
                            : ' $selectedYear'),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => changeMonth('forward')),
            ]),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            child: monthlyTransactions.isEmpty
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        'No transactions have been added this month.',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                : Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    )),
                    child: Column(children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        child: ListTile(
                          tileColor: Colors.grey[900],
                          title: Text(
                            'Total Expenses',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          trailing: Text(
                            '\$${monthlyExpenses.toStringAsFixed(2)}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Divider(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: monthlyTransactions.length,
                          itemBuilder: (context, index) =>
                              TransactionListTile(monthlyTransactions[index]),
                        ),
                      ),
                    ]),
                  ),
          ),
        ),
      ],
    );
  }
}
