import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;

  TransactionListTile(this.transaction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(
            20)), //BorderRadius.vertical(top: Radius.circular(20)),
        child: ListTile(
          tileColor: Colors.grey[850],
          leading: CircleAvatar(child: Icon(Icons.category)),
          title: AutoSizeText(
            '${transaction.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
          subtitle: Text(
              '${transaction.category} | ${DateFormat.MMMd().format(transaction.date)}',
              style: TextStyle(color: Theme.of(context).primaryColorLight)),
          trailing: Text(
            '\$${transaction.amount.toStringAsFixed(2)}',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
