import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/budget.dart';
import 'new_budget_screens/income_screen.dart';
import '../widgets/budget_list_tile.dart';
import '../models/categories.dart';

import 'package:provider/provider.dart';
import '../models/month_changer.dart';

class BudgetScreen extends StatefulWidget {
  static const routeName = '/budget';

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  void _enterBudget(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => IncomeScreen(),
    ).then((newBudget) {
      if (newBudget == null) return;
      Provider.of<Budgets>(context, listen: false).addBudget(newBudget);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthlyBudget = Provider.of<Budgets>(context).monthlyBudget;
    var monthData = Provider.of<MonthChanger>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            width: 250,
            child: buildMonthChanger(context, monthData),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 40),
            child: monthlyBudget == null
                ? Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 250),
                      child: Column(
                        children: [
                          Text(
                            'No budget has been added this month.',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.center,
                          ),
                          RaisedButton(
                            child: Text('Add Budget'),
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).canvasColor,
                            onPressed: () => _enterBudget(context),
                          ),
                        ],
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      AutoSizeText(
                                        '\$4,900.00',
                                        maxLines: 1,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18),
                                      ),
                                    ],
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
                                      AutoSizeText(
                                        '\$213.04',
                                        maxLines: 1,
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
                                    width:
                                        MediaQuery.of(context).size.width * .80,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    '\$2,000.00 of \$3,000.00',
                                    maxLines: 1,
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
                          itemCount: monthlyBudget.categoryAmount.length,
                          itemBuilder: (context, index) =>
                              BudgetListTile(MainCategory.values[index]),
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

Row buildMonthChanger(BuildContext context, MonthChanger monthData) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    if (monthData.selectedMonth > DateTime.now().month ||
        monthData.selectedYear >= DateTime.now().year)
      IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => monthData.changeMonth('back')),
    Expanded(
      child: Center(
        child: Text(
          '${MonthChanger.months[monthData.selectedMonth - 1]}' +
              (monthData.selectedYear == DateTime.now().year
                  ? ''
                  : ' ${monthData.selectedYear}'),
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16,
          ),
        ),
      ),
    ),
    if (monthData.selectedMonth < DateTime.now().month ||
        monthData.selectedYear <= DateTime.now().year)
      IconButton(
          icon: Icon(
            Icons.arrow_forward,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => monthData.changeMonth('forward')),
  ]);
}
