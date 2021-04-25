// Imported Flutter packages
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../models/month_changer.dart';
import '../models/transaction.dart' as Transaction;
import '../widgets/transaction_list_tile.dart';
import '../widgets/transaction_form.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // Pull up transaction form when button is tapped; add the returned transaction to the list of transactions
  void _enterTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(),
    );
  }

  var user = FirebaseAuth.instance.currentUser;

  CollectionReference getDbRef(
      {category, // add other parameters to filter by or orderBy
      filterByCategory = false,
      orderByPrice = false}) {
    var dbRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Transactions');
    dbRef = filterByCategory
        ? dbRef.where('categoryId', isEqualTo: category)
        : dbRef;
    return dbRef = orderByPrice ? dbRef.orderBy('amount') : dbRef;
  }

  @override
  Widget build(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context);
    var monthData = Provider.of<MonthChanger>(context);
    return StreamBuilder<QuerySnapshot>(
      stream: transactionDataProvider
          .getMonthlyTransactions(
              context,
              DateTime(
                monthData.selectedYear,
                monthData.selectedMonth,
              ))
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          // no waiting state to avoid flashing of screen on month change or transaction deletion
          // fallback to generic red screen error widget in main instead
          // case ConnectionState
          //     .waiting: // not sure if this is a good solution... keeps the screen from shifting left though... needs to be improved to stop screen from flashing on month change
          //   return Row(
          //     children: [],
          //     mainAxisSize: MainAxisSize.max,
          //   );
          default:
            return Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: 250,
                  child: monthData.buildMonthChanger(context),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: snapshot.data.docs.isEmpty
                      ? NoTransactionsYetText(_enterTransaction)
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: TransactionsCard(
                            transactionsSnapshot: snapshot.data,
                          ),
                        ),
                ),
              ),
            ]);
        }
      },
    );
  }
}

class TransactionsCard extends StatefulWidget {
  TransactionsCard({Key key, @required this.transactionsSnapshot})
      : super(key: key);

  final QuerySnapshot transactionsSnapshot;

  @override
  _TransactionsCardState createState() => _TransactionsCardState();
}

class _TransactionsCardState extends State<TransactionsCard> {
  final Transaction.Transaction transaction =
      new Transaction.Transaction.empty();

  @override
  Widget build(BuildContext context) {
    var transactionData = Provider.of<Transaction.Transactions>(context);

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: TotalExpenses(
            monthlyExpenses: transactionData
                .getTransactionExpenses(widget.transactionsSnapshot),
          ),
        ),
        Divider(height: 10),
        Expanded(
          child: ListView.builder(
              itemCount: widget.transactionsSnapshot.docs.length,
              itemBuilder: (context, index) {
                // initialize the transaction document into a transaction object
                return TransactionListTile(
                    transactionData.initializeTransaction(
                        widget.transactionsSnapshot.docs[index]));
              }),
        ),
      ],
    );
  }
}

class TotalExpenses extends StatefulWidget {
  const TotalExpenses({
    Key key,
    @required this.monthlyExpenses,
  }) : super(key: key);

  final double monthlyExpenses;

  @override
  _TotalExpensesState createState() => _TotalExpensesState();
}

class _TotalExpensesState extends State<TotalExpenses> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Total Expenses',
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
      trailing: AutoSizeText(
        '\$${widget.monthlyExpenses.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class NoTransactionsYetText extends StatelessWidget {
  final enterTransactionsHandler;

  NoTransactionsYetText(this.enterTransactionsHandler);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: Column(
          children: [
            Text(
              'No transactions have been added this month.',
              style: TextStyle(
                  fontSize: 18, color: Theme.of(context).primaryColor),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              child: Text(
                'Add Transaction',
                style: TextStyle(color: Theme.of(context).canvasColor),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              onPressed: () => enterTransactionsHandler(context),
            ),
          ],
        ),
      ),
    );
  }
}
