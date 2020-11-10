import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetListTile extends StatefulWidget {
  final Budget budget;

  BudgetListTile(this.budget);

  @override
  _BudgetListTileState createState() => _BudgetListTileState();
}

class _BudgetListTileState extends State<BudgetListTile> {
  var _expanded = false;

  double get totalTransactions {
    var sum = 0.0;
    for (var i = 0; i < widget.budget.transactions.length; i++) {
      sum += widget.budget.transactions[i].amount;
    }
    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(
            20)), //BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              tileColor: Colors.grey[850],
              title: AutoSizeText(
                '${widget.budget.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  new LinearPercentIndicator(
                    width: 350.0,
                    lineHeight: 12.0,
                    percent: widget.budget.transactions == null
                        ? 0.0
                        : totalTransactions > widget.budget.amount
                            ? 1
                            : totalTransactions / widget.budget.amount,
                    backgroundColor: Colors.black,
                    progressColor: Colors.amber,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${totalTransactions > widget.budget.amount ? totalTransactions : widget.budget.amount - totalTransactions} of \$${widget.budget.amount}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                color: Colors.grey[550],
                height: 100,
                child: widget.budget.transactions == null
                    ? Text(
                        'No transaction has been added yet',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      )
                    : ListView(
                        children: widget.budget.transactions
                            .map(
                              (trans) => Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    trans.title,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                  Text(
                                    '\$${trans.amount}',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                            )
                            .toList(),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
