// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
import '../models/transaction.dart' as Transaction;
import '../models/category_icon.dart';
import './transaction_form.dart';

class TransactionListTile extends StatefulWidget {
  final Transaction.Transaction transaction;

  TransactionListTile(this.transaction);

  @override
  _TransactionListTileState createState() => _TransactionListTileState();
}

class _TransactionListTileState extends State<TransactionListTile> {
  void _updateTransaction(
      BuildContext context, Transaction.Transaction transaction) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(transaction: transaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Dismissible(
          key: ValueKey(widget.transaction.getID()),
          background: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Do you want to remove this transaction?'),
                content: Text(
                  'This cannot be undone later.',
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<Transaction.Transactions>(context, listen: false)
                .deleteTransaction(widget.transaction, context);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text('Transaction deleted.'),
                ),
              );
          },
          child: ListTile(
            onTap: () => _updateTransaction(context, widget.transaction),
            tileColor: Colors.grey[850],
            leading: CircleAvatar(
              child:
                  Icon(categoryIcon[widget.transaction.getCategoryCodePoint()]),
            ),
            title: AutoSizeText(
              '${widget.transaction.getTitle()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            subtitle: AutoSizeText(
              '${widget.transaction.getCategoryTitle()} | ${DateFormat.MMMd().format(widget.transaction.getDate())}',
              style: TextStyle(color: Theme.of(context).primaryColorLight),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: AutoSizeText(
              '\$${widget.transaction.getAmount().toStringAsFixed(2)}',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

// Displays the 3 most recent transactions in the Dashboard Screen
class RecentTransactionsCard extends StatelessWidget {
  final int tileCount;
  RecentTransactionsCard(this.tileCount);
  @override
  Widget build(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context);

    return StreamBuilder<QuerySnapshot>(
        stream:
            transactionDataProvider.getRecentTransactions(context, tileCount),
        builder: (context, snapshot) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              ),
            ),
            child: Container(
              width: 400,
              height: 300,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    width: 400,
                    child: Center(
                      child: Text(
                        'Recent Transactions',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  (!snapshot.hasData || snapshot.data.docs.isEmpty)
                      ? Container()
                      : Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // initialize the transaction document into a transaction object
                                return TransactionListTile(
                                    transactionDataProvider
                                        .initializeTransaction(
                                            snapshot.data.docs[index]));
                              }),
                        ),
                ],
              ),
            ),
          );
        });
  }
}
