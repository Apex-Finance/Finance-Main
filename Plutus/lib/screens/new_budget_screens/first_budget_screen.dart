import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../widgets/category_list_tile.dart';
import '../../models/categories.dart';
import '../../models/budget.dart';

class FirstBudgetScreen extends StatefulWidget {
  static const routeName = '/first_budget';

  @override
  _FirstBudgetScreenState createState() => _FirstBudgetScreenState();
}

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  MainCategory activeCategory = MainCategory.values[0];
  double activeAmount = 0;

  void setActiveCategory(MainCategory category, double amount) {
    activeCategory = category;
    activeAmount = amount ?? 0;
    return;
  }

  @override
  Widget build(BuildContext context) {
    final Budget budget = Provider.of<Budgets>(context)
        .monthlyBudget; // budget contains the amounts; rest are null on first run of build
    budget.categoryAmount =
        budget.categoryAmount == null ? {} : budget.categoryAmount;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('First Budget', style: Theme.of(context).textTheme.bodyText1),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "New Monthly Budget",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Budget:',
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                          ),
                          AutoSizeText(
                            '\$${budget.amount.toStringAsFixed(2)}',
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining Budget:',
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                          ),
                          AutoSizeText(
                            '\$${budget.remainingAmount.toStringAsFixed(2)}',
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: MainCategory.values.length,
                    itemBuilder: (context, index) => CategoryListTile(
                        MainCategory.values[index], setActiveCategory
                        //?
                        ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 50),
                  alignment: Alignment.bottomRight,
                  child: Builder(
                    builder: (context) => FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Provider.of<Budgets>(context, listen: false)
                            .setCategoryAmount(
                                activeCategory, activeAmount, context);
                        //TODO UPDATE WHATEVER FIELD THEY WERE ENTERING WHEN TAPPED..would need the list of focusnodes first
                        //TODO Add a Budget (BUG: If you don't hit this button but have added a monthly income and have hit the
                        //TODO button, it adds the budget anyway.)
                        setState(() {
                          if (budget.remainingAmount < 0.00)
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'You have budgeted more money than is available this month.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                            );
                          else if (budget.remainingAmount > 0.00) {
                            Scaffold.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Text(
                                    'You have some money that still needs to be budgeted.',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/tab', (Route<dynamic> route) => false);
                          }
                        });
                      }, // removes all screens besides tab (useful after intro or just normal budget creation)
                      label: Text('Add Budget'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
