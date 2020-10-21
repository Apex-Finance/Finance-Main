import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class BudgetForm extends StatefulWidget {
  @override
  _BudgetFormState createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  Budget _budget = Budget(
    id: null,
    title: null,
    category: null,
    amount: null,
  );

  void _submitBudgetForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(
          '${_budget.amount}${_budget.category}${_budget.title}${_budget.id}');
      Navigator.of(context).pop(
        _budget,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      // stops keyboard from overlapping form
      child: Container(
        height: 400, // large enough to accommodate all errors
        child: Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              10,
              20,
              10,
              0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                    autofocus: true,
                    maxLength: null,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onSaved: (val) => _budget.title = val,
                    validator: (val) {
                      if (val.isEmpty) return 'Please enter a description.';
                      return null;
                    },
                  ),
                  TextFormField(
                    //TODO update to dropdown/another modal/card instead of string
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                    maxLength: null,
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    onSaved: (val) => _budget.category = val,
                    validator: (val) {
                      if (val.isEmpty) return 'Please enter a category.';
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Amount',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: null,
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    onSaved: (val) => _budget.amount = double.parse(val),
                    validator: (val) {
                      if (val.isEmpty) return 'Please enter an amount.';
                      if (val.contains(new RegExp(r'^\d*(\.\d+)?$'))) {
                        if (double.parse(
                                double.parse(val).toStringAsFixed(2)) <=
                            0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                          return 'Please enter an amount greater than 0.'; // only accept any number of digits followed by 0 or 1 decimals followed by any number of digits
                        return null;
                      } else {
                        return 'Please enter a number.';
                      }
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: _submitBudgetForm,
                      label: Text('Add Budget'),
                    ),
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
