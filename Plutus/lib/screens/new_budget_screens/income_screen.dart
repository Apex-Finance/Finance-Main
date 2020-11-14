import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import './first_budget_screen.dart';
import '../../models/budget.dart';

class IncomeScreen extends StatefulWidget {
  static const routeName = '/income';
  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _budget = Provider.of<Budget>(
        context); // budget initialized to all nulls and subsequent changes will update Provider
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
                  Text("Monthly Income",
                      style: Theme.of(context).textTheme.bodyText1),
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
                              Navigator.of(context)
                                  .pushNamed(FirstBudgetScreen.routeName);
                            }
                          },
                          onSaved: (val) => _budget.amount = double.parse(val),
                          validator: (val) {
                            if (val.contains(new RegExp(r'^\d*(\.\d+)?$'))) {
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
          ),
        ),
      ),
    );
  }
}
