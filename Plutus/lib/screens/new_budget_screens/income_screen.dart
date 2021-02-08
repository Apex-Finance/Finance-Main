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

// Asks the user for his monthly income and creates the budget based on that amount
class IncomeScreen extends StatefulWidget {
  static const routeName = '/income';
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Validates the budget amount and pushes to First Budget Screen
  @override
  Widget build(BuildContext context) {
    var _budget = Provider.of<Budgets>(context)
        .monthlyBudget; // budget initialized to all nulls and subsequent changes will update Provider
    var monthData = Provider.of<MonthChanger>(context);

    // Alerts the user of discarding his budget changes. User may discard or keeping editing.
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
                      Text('\$', style: Theme.of(context).textTheme.bodyText1),
                      Expanded(
                        child: TextFormField(
                          style: Theme.of(context).textTheme.bodyText1,
                          autofocus: true,
                          keyboardType: TextInputType.number,
                          //initialValue: '0.00', // Since autofocus == true, not needed
                          onEditingComplete: () {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              // perhaps we need to call addBudget here?
                              _budget.id = DateTime(monthData.selectedYear,
                                      monthData.selectedMonth)
                                  .toIso8601String();
                              _budget.title = DateTime(monthData.selectedYear,
                                      monthData.selectedMonth)
                                  .toIso8601String();
                              Provider.of<Budgets>(context, listen: false)
                                  .addBudget(_budget, context);
                              Navigator.of(context)
                                  .pushNamed(FirstBudgetScreen.routeName);
                            }
                          },
                          onSaved: (val) => _budget.amount = double.parse(val),
                          validator: (val) {
                            if (val
                                .contains(new RegExp(r'-?[0-9]\d*(\.\d+)?$'))) {
                              print(val);
                              // TODO Restrict the decimal place to hundreths
                              // only accept any number of digits followed by 0 or 1 decimals followed by any number of digits
                              if (double.parse(
                                      double.parse(val).toStringAsFixed(2)) <=
                                  0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                                return 'Please enter an amount greater than 0.';
                              if (double.parse(
                                      double.parse(val).toStringAsFixed(2)) >
                                  999999999.99)
                                return 'Max amount is \$999,999,999.99'; // no transactions >= $1billion
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
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  // TODO Any changes made to this budget (does not include first creation) will be saved as a brand new budget
                  // TODO Will need to be addressed once the DB is incorporated into budget.dart
                  Provider.of<Budgets>(context, listen: false)
                      .deleteBudget(_budget.id);
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
        if (_budget.amount != null) _showDiscardBudgetDialog();
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
                    Text(
                      "Monthly Income",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 35,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Text('\$',
                            style: Theme.of(context).textTheme.bodyText1),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              CurrencyTextInputFormatter(),
                            ],
                            style: Theme.of(context).textTheme.bodyText1,
                            autofocus: true,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false, signed: true),
                            onEditingComplete: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                _budget.id = DateTime(monthData.selectedYear,
                                        monthData.selectedMonth)
                                    .toIso8601String();
                                _budget.title = DateTime(monthData.selectedYear,
                                        monthData.selectedMonth)
                                    .toIso8601String();
                                Provider.of<Budgets>(context, listen: false)
                                    .addBudget(_budget, context);
                                Navigator.of(context)
                                    .pushNamed(FirstBudgetScreen.routeName);
                              }
                            },
                            // Prevents users from entering budgets >= $1billion
                            maxLength: 14,
                            onSaved: (val) => _budget.amount =
                                double.parse(val.replaceAll(",", "")),
                            validator: (val) {
                              if (val.contains(new RegExp(
                                  r'^-?\d{0,3}(,\d{3}){0,3}(.\d+)?$'))) {
                                // ^-?\d+(\.\d{1,2})?$
                                // OLD REGEX r'-?[0-9]\d*(\.\d+)?$'
                                // only accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
                                if (double.parse(
                                        double.parse(val.replaceAll(",", ""))
                                            .toStringAsFixed(2)) <=
                                    0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                                  return 'Please enter an amount greater than 0.';
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
