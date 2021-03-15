import 'package:Plutus/models/categories.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '../models/category_icon.dart';

class BudgetListTile extends StatefulWidget {
  final MainCategory category;

  BudgetListTile(this.category);

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
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    categoryIcon[widget.category],
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  AutoSizeText(
                    stringToUserString(enumValueToString(widget.category)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                  // category budget allocated
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${monthlyBudget.categoryAmount[widget.category]}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  new LinearPercentIndicator(
                    alignment: MainAxisAlignment.center,
                    width: MediaQuery.of(context).size.width * .8,
                    lineHeight: 12.0,
                    percent: monthlyBudget.transactions == null
                        ? 0.0
                        : monthlyBudget.getCategoryTransactionsAmount(
                                    monthlyBudget, widget.category) >
                                monthlyBudget.categoryAmount[widget.category]
                            ? 1
                            : monthlyBudget.getCategoryTransactionsAmount(
                                    monthlyBudget, widget.category) /
                                monthlyBudget.categoryAmount[widget.category],
                    backgroundColor: Theme.of(context).canvasColor,
                    progressColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$${monthlyBudget.categoryAmount[widget.category] - monthlyBudget.getCategoryTransactionsAmount(monthlyBudget, widget.category)} remaining',
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${monthlyBudget.getCategoryTransactionsAmount(monthlyBudget, widget.category)}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Divider(
                        color: Theme.of(context).primaryColor,
                        height: 10,
                        thickness: 2,
                        indent: 0,
                        endIndent: 0,
                      ),
                      monthlyBudget.getCategoryTransactionsAmount(
                                  monthlyBudget, widget.category) ==
                              0
                          ? Text(
                              'No transaction has been added yet',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 18),
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              children: monthlyBudget
                                  .getCategoryTransactions(
                                      monthlyBudget, widget.category)
                                  .map(
                                    (trans) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          trans.getTitle(),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18),
                                        ),
                                        Text(
                                          '\$${trans.getAmount()}',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 18),
                                        )
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
