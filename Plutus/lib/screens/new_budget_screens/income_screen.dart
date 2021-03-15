import 'package:Plutus/models/budget.dart';
import 'package:Plutus/screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import './first_budget_screen.dart';
import '../../models/budget.dart';
import '../../models/month_changer.dart';
import '../../models/category.dart' as Category;

// Screen that asks for the monthly income and creates a budget on that amount
class IncomeScreen extends StatefulWidget {
  final Budget budget;
  IncomeScreen({this.budget});
  static const routeName = '/income';
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var category = Category.Category();
    var monthData = Provider.of<MonthChanger>(context);

    // Creates an AlertDialog Box that notifies the user of discard changes
    Future<void> _showDiscardBudgetDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Text(
              'Cancel',
              style: Theme.of(context).textTheme.headline1,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Would you like to discard these changes?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  // TODO Any changes made to this budget (does not include first creation) will be saved as a brand new budget
                  // TODO Will need to be addressed once the DB is incorporated into budget.dart
                  Provider.of<BudgetDataProvider>(context, listen: false)
                      .deleteBudget(widget.budget.getID(), context);
                  Navigator.of(context).pushNamed(TabScreen.routeName);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        if (widget.budget.getAmount() != null) _showDiscardBudgetDialog();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('New Budget', style: Theme.of(context).textTheme.bodyText1),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: KeyboardAvoider(
            child: Container(
              height: 400,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Title
                    Text(
                      "Monthly Income",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 35,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        // Textfield where monthly income is entered
                        Text('\$',
                            style: Theme.of(context).textTheme.bodyText1),
                        Expanded(
                          child: TextFormField(
                            style: Theme.of(context).textTheme.bodyText1,
                            autofocus: true,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            onEditingComplete: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                widget.budget.setDate(DateTime(
                                    monthData.selectedYear,
                                    monthData.selectedMonth,
                                    1));
                                if (widget.budget.getID() == null) {
                                  Provider.of<BudgetDataProvider>(context,
                                          listen: false)
                                      .editBudget(widget.budget, context);
                                } else {
                                  Provider.of<BudgetDataProvider>(context,
                                          listen: false)
                                      .addBudget(widget.budget, context);
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FirstBudgetScreen(
                                          budget: widget.budget),
                                    ));
                              }
                            },
                            // Prevents users from entering budgets >= $1billion
                            maxLength: 14,
                            onSaved: (val) => widget.budget.setAmount(
                                double.parse(val.replaceAll(",", ""))),

                            validator: (val) {
                              if (val.contains(
                                  new RegExp(r'^-?\d+(\.\d{1,2})?$'))) {
                                // OLD REGEX r'-?[0-9]\d*(\.\d+)?$'
                                // only accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) <=
                                    0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                                  return 'Please enter an amount greater than 0.';
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) >
                                    999999999.99)
                                  return 'Max amount is \$999,999,999.99'; // no budget >= $1billion
                                return null;
                              } else {
                                return 'Please enter a number.';
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
