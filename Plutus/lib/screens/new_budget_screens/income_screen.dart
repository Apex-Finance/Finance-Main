import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import './first_budget_screen.dart';
import '../../models/budget.dart';
import '../../models/month_changer.dart';
import 'dart:math' as math;

class IncomeScreen extends StatefulWidget {
  static const routeName = '/income';
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

// Prevents user from inputting numbers in the thousandths+
// TODO Currently this class allows the user to input past the hundreths place; those numbers will not be visible
// TODO to the user. Any data passed the hundreths is still there, however. The user can change the data, but will have to backspace several times
// TODO (depending on how many numbers past the decimal point he inputted) to see any changes.

/* USE CASE: User inputs 34.56293 but only sees 34.56. User can hit "Done" and be taken to first_budget_screen.dart where total budget == $34.56
   To change 34.56 to 34.57 however, user MUST hit backspace 4 times (only happens while he is on the same screen). This action deletes the 6293.*/
class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (decimalRange != null) {
      String value = newValue.text;

      if (value.contains(".") &&
          value.substring(value.indexOf(".") + 1).length > decimalRange) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
      } else if (value == ".") {
        truncated = "0.";

        newSelection = newValue.selection.copyWith(
          baseOffset: math.min(truncated.length, truncated.length + 1),
          extentOffset: math.min(truncated.length, truncated.length + 1),
        );
      }

      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }
    return newValue;
  }
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Validates the budget amount and pushes to First Budget Screen

  @override
  Widget build(BuildContext context) {
    var _budget = Provider.of<Budgets>(context)
        .monthlyBudget; // budget initialized to all nulls and subsequent changes will update Provider
    var monthData = Provider.of<MonthChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New Budget', style: Theme.of(context).textTheme.bodyText1),
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
                      Text('\$', style: Theme.of(context).textTheme.bodyText1),
                      Expanded(
                        child: TextFormField(
                          inputFormatters: [
                            DecimalTextInputFormatter(decimalRange: 2)
                          ],
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
                                  .addBudget(_budget);
                              Navigator.of(context)
                                  .pushNamed(FirstBudgetScreen.routeName);
                            }
                          },
                          onSaved: (val) => _budget.amount = double.parse(val),
                          validator: (val) {
                            if (val
                                .contains(new RegExp(r'^-?\d+(\.\d{1,2})?$'))) {
                              // OLD REGEX r'-?[0-9]\d*(\.\d+)?$'
                              // only accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
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
          ),
        ),
      ),
    );
  }
}
