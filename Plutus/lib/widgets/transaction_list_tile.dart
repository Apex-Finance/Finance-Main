// Imported Flutter packages
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
            tileColor: Theme.of(context).backgroundColor,
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
              style: TextStyle(color: Theme.of(context).accentColor),
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
