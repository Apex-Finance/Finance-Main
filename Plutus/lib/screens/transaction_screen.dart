import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    var monthData = Provider.of<MonthChanger>(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 250,
            child: buildMonthChanger(context, monthData),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: getDbRef().snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            switch (snapshot.connectionState) {
              case ConnectionState
                  .waiting: // not sure if this is a good solution... keeps the screen from shifting left though... needs to be improved to stop screen from flashing on month change
                return Row(
                  children: [],
                  mainAxisSize: MainAxisSize.max,
                );
              default:
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 25),
                    child: snapshot.data.docs.isEmpty
                        ? NoTransactionsYetText()
                        : Card(
                            color: Colors.grey[900],
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
                );
            }
          },
        ),
      ],
    );
  }
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
      tileColor: Colors.grey[900],
      title: Text(
        'Total Expenses',
        style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
      ),
      trailing: Text(
        '\$${widget.monthlyExpenses.toStringAsFixed(2)}',
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
