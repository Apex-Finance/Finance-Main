import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/transaction.dart';
import '../models/categories.dart';
import '../models/category_icon.dart';
import 'package:provider/provider.dart';
import './transaction_form.dart';

class TransactionListTile extends StatefulWidget {
  final Transaction transaction;

  TransactionListTile(this.transaction);

  @override
  _TransactionListTileState createState() => _TransactionListTileState();
}

class _TransactionListTileState extends State<TransactionListTile> {
  void _updateTransaction(BuildContext context, Transaction transaction) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(transaction: transaction),
    ).then((newTransaction) {
      if (newTransaction == null) return;
      Provider.of<Transactions>(context, listen: false)
          .editTransaction(newTransaction, context);
    });
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
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
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
            Provider.of<Transactions>(context, listen: false)
                .deleteTransaction(widget.transaction, context);
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Transaction deleted.'),
                ),
              );
          },
          child: ListTile(
            onTap: () => _updateTransaction(context, widget.transaction),
            tileColor: Colors.grey[850],
            leading: CircleAvatar(
                child: Icon(categoryIcon[widget.transaction.getCategory()])),
            title: AutoSizeText(
              '${widget.transaction.getTitle()}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 18),
            ),
            subtitle: Text(
                '${stringToUserString(enumValueToString(widget.transaction.getCategory()))} | ${DateFormat.MMMd().format(widget.transaction.getDate())}',
                style: TextStyle(color: Theme.of(context).primaryColorLight)),
            trailing: Text(
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
