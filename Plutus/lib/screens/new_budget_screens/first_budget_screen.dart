import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  var errorMessage = '';

  @override
  Widget build(BuildContext context) {
    final Budget budget = Provider.of<Budget>(
        context); // budget contains the amounts; rest are null on first run of build
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
          //height: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "New Monthly Budget",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Total Budget: \$${budget.amount}   Remaining Budget:\$${budget.remainingAmount}',
                    style: TextStyle(color: Colors.amber, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: MainCategory.values.length,
                    itemBuilder: (context, index) => CategoryListTile(
                      MainCategory.values[index],
                      //budget.categoryAmount != null
                      //?
                      //: 0
                    ),
                    //Navigator.of(context).pushNamed(CategoryListTile.routeName, arguments: budget),//.then((budgets) => function_to_subtract_budgets.categoryData['category_name']_from_totalprice);
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      //TODO UPDATE WHATEVER FIELD THEY WERE ENTERING WHEN TAPPED..would need the list of focusnodes first
                      setState(() {
                        if (budget.remainingAmount < 0.00)
                          errorMessage =
                              'You have budgeted more money than is available this month.';
                        else if (budget.remainingAmount > 0.00) {
                          errorMessage =
                              'You have some money that still needs to be budgeted.';
                        } else {
                          //TODO ADD A BUDGET ID, TITLE, ETC.
                          errorMessage = '';
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/tab', (Route<dynamic> route) => false);
                        }
                      });
                    }, // removes all screens besides tab (useful after intro or just normal budget creation)
                    label: Text('Add Budget'),
                  ),
                ),
                if (errorMessage != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
