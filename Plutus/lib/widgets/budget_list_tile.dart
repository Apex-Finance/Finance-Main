import 'package:Plutus/models/categories.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BudgetListTile extends StatefulWidget {
  final MainCategory category;

  BudgetListTile(this.category);

  // void selectBudget(BuildContext ctx) {
  //   Navigator.of(ctx).push(
  //     MaterialPageRoute(
  //       builder: (_) {
  //         return BudgetInfoScreen(
  //             budget.title, ''); //TODO update to the right maincategory
  //       },
  //     ),
  //   );
  @override
  _BudgetListTileState createState() => _BudgetListTileState();
}

class _BudgetListTileState extends State<BudgetListTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final monthlyBudget = Provider.of<Budgets>(context).monthlyBudget;
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
                stringToUserString(enumValueToString(widget.category)),
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
                    percent: monthlyBudget.transactions ==
                            null //TODO FIX ALL TRANSACTION CALLS WITH PROVIDER FUNCTION
                        ? 0.0
                        : monthlyBudget.getCategoryTransactionsAmount(
                                    monthlyBudget, widget.category) >
                                monthlyBudget.categoryAmount[widget.category]
                            ? 1
                            : monthlyBudget.getCategoryTransactionsAmount(
                                    monthlyBudget, widget.category) /
                                monthlyBudget.categoryAmount[widget.category],
                    backgroundColor: Colors.black,
                    progressColor: Colors.amber,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${monthlyBudget.getCategoryTransactionsAmount(monthlyBudget, widget.category) > monthlyBudget.categoryAmount[widget.category] ? monthlyBudget.getCategoryTransactionsAmount(monthlyBudget, widget.category) : monthlyBudget.categoryAmount[widget.category] - monthlyBudget.getCategoryTransactionsAmount(monthlyBudget, widget.category)} of \$${monthlyBudget.categoryAmount[widget.category]}',
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
                child: monthlyBudget.transactions == null
                    ? Text(
                        'No transaction has been added yet',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      )
                    : ListView(
                        children: monthlyBudget.transactions
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
