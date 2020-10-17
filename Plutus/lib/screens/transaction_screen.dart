import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/transaction.dart';
import '../widgets/transaction_list_tile.dart';

class TransactionScreen extends StatefulWidget {
  static const routeName = '/transaction';
  List<Transaction> transactions;

  TransactionScreen({@required this.transactions});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
//TODO add cards/expenses
    return Column(
      children: [
        Text('month changer', style: Theme.of(context).textTheme.bodyText1),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 40),
            child: widget.transactions.isEmpty
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
                            '\$number',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Divider(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: widget.transactions.length,
                          itemBuilder: (context, index) =>
                              TransactionListTile(widget.transactions[index]),
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
