import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transaction.dart' as Transaction;
import '../widgets/transaction_list_tile.dart';
import 'package:provider/provider.dart';
import '../models/month_changer.dart';
import '../providers/auth.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionData = Provider.of<Transaction.Transactions>(context);
    var monthData = Provider.of<MonthChanger>(context);
    var authData = Provider.of<Auth>(context);
    var dbRef = FirebaseFirestore.instance
        .collection('users')
        .doc(authData.getUserId())
        .collection('Transactions');
    return StreamBuilder<QuerySnapshot>(
      stream: dbRef.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // Do we need this? It appears everytime you switch to the Goal tab -Juan
            return Text('Loading...');
          default:
            switch (snapshot.data.docs.isEmpty) {
              case true:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('No transactions yet. Ready to add one?',
                          style: Theme.of(context).textTheme.bodyText1),
                      RaisedButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).canvasColor,
                        child: Text(
                          "Add Goal",
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              default:
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Container(
                        width: 250,
                        child: buildMonthChanger(context, monthData),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        child: transactionData.monthlyTransactions.isEmpty
                            ? NoTransactionsYetText()
                            : Card(
                                color: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                child: TransactionsCard(
                                  transactionsSnapshot: snapshot,
                                ),
                              ),
                      ),
                    ),
                  ],
                );
            }
        }
      },
    );
  }

  Row buildMonthChanger(BuildContext context, MonthChanger monthData) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      if (monthData.selectedMonth > DateTime.now().month ||
          monthData.selectedYear >= DateTime.now().year)
        IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => monthData.changeMonth('back')),
      Expanded(
        child: Center(
          child: Text(
            '${MonthChanger.months[monthData.selectedMonth - 1]}' +
                (monthData.selectedYear == DateTime.now().year
                    ? ''
                    : ' ${monthData.selectedYear}'),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
      if (monthData.selectedMonth < DateTime.now().month ||
          monthData.selectedYear <= DateTime.now().year)
        IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onPressed: () => monthData.changeMonth('forward')),
    ]);
  }
}

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({Key key, @required this.transactionsSnapshot})
      : super(key: key);

  AsyncSnapshot<QuerySnapshot> transactionsSnapshot;
  final double monthlyExpenses;
  final List<Transaction.Transaction> monthlyTransactions;
  Transaction.Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final transactionData = Provider.of<Transaction.Transactions>(context);

    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: TotalExpenses(monthlyExpenses: monthlyExpenses),
      ),
      Divider(height: 10),
      Expanded(
        child: ListView.builder(
          itemCount: transactionsSnapshot.data.docs.length,
          itemBuilder: (context, index) {
            transactionsSnapshot.data.docs.map((doc) {
              // initialize the transaction document into a transaction object
              transaction = transactionData.initializeTransaction(doc);
            });
            return TransactionListTile(transaction);
          },
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
