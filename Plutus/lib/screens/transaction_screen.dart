import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_list_tile.dart';
import 'package:provider/provider.dart';

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
  // List<Transaction> transactions;

  // TransactionScreen({@required this.transactions});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  var selectedMonth = DateTime.now().month;
  var selectedYear = DateTime.now().year;

  // Change the year and month
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
    final transactionsData = Provider.of<Transactions>(context);
    print(transactionsData.transactions);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 250,
            child: buildMonthChanger(context),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 25),
            child: transactionsData.monthlyTransactions.isEmpty
                ? NoTransactionsYetText()
                : Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    )),
                    child: TransactionsCard(
                        monthlyExpenses: transactionsData.monthlyExpenses,
                        monthlyTransactions:
                            transactionsData.monthlyTransactions),
                  ),
          ),
        ),
      ],
    );
  }

  Row buildMonthChanger(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                (selectedYear == DateTime.now().year ? '' : ' $selectedYear'),
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
    ]);
  }
}

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({
    Key key,
    @required this.monthlyExpenses,
    @required this.monthlyTransactions,
  }) : super(key: key);

  final double monthlyExpenses;
  final List<Transaction> monthlyTransactions;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: TotalExpenses(monthlyExpenses: monthlyExpenses),
      ),
      Divider(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: monthlyTransactions.length,
          itemBuilder: (context, index) =>
              TransactionListTile(monthlyTransactions[index]),
        ),
      ),
    ]);
  }
}

class TotalExpenses extends StatelessWidget {
  const TotalExpenses({
    Key key,
    @required this.monthlyExpenses,
  }) : super(key: key);

  final double monthlyExpenses;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[900],
      title: Text(
        'Total Expenses',
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
      trailing: Text(
        '\$${monthlyExpenses.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class NoTransactionsYetText extends StatelessWidget {
  const NoTransactionsYetText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Text(
          'No transactions have been added this month.',
          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }
}
