import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../models/budget.dart';
import '../widgets/budget_form.dart';
import '../widgets/budget_list_tile.dart';

class BudgetScreen extends StatefulWidget {
  static const routeName = '/budget';

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  List<Budget> budgets = [];

  void addBudget(Budget budget) {
    setState(() {
      budgets.add(budget);
    });
  }

  void _enterBudget(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => BudgetForm(),
    ).then((newBudget) {
      if (newBudget == null) return;
      addBudget(newBudget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'month changer',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        RaisedButton(
          child: Text('Add Budget'),
          onPressed: () => _enterBudget(context),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 40),
            child: budgets.isEmpty
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Text(
                        'No budget has been added this month.',
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
                          tileColor: Colors.grey[850],
                          title: Column(
                            children: [
                              Text(
                                'Total Budget',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Remaining',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        '\$4,900.00',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 150,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Available per day',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        '\$213.04',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new LinearPercentIndicator(
                                    width: 310.0,
                                    lineHeight: 14.0,
                                    percent: 0.5,
                                    backgroundColor: Colors.black,
                                    progressColor: Colors.amber,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$2,000.00 of \$6,900.00',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: budgets.length,
                          itemBuilder: (context, index) =>
                              BudgetListTile(budgets[index]),
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
