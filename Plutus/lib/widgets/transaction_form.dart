import 'package:Plutus/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  Transaction _transaction = Transaction(
    id: null,
    title: null,
    category: null,
    amount: null,
    date: null,
  );

  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      _date = value;
      _transaction.date =
          _date; // update date if date changes since no onsave property
    });
  }

  void _submitTransactionForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print(
          '${_transaction.amount}${_transaction.category}${_transaction.title}${_transaction.date}${_transaction.id}');
      Navigator.of(context).pop(
        _transaction,
      );
    }
  }

  @override
  void initState() {
    _transaction.date = _date; // initialize date since no onsave property
    super.initState();
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
                    onSaved: (val) => _transaction.title = val,
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
                    onSaved: (val) => _transaction.category = val,
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
                    onSaved: (val) => _transaction.amount = double.parse(val),
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 125,
                        child: Text(
                          'Date: ${DateFormat.MMMd().format(_date)}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      RaisedButton(
                        color: Theme.of(context).primaryColorLight,
                        child: Text('Pick Date'),
                        onPressed: () => showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now().subtract(
                            Duration(
                              days: 365,
                            ),
                          ),
                          lastDate: DateTime.now().add(
                            Duration(
                              days: 365,
                            ),
                          ),
                        ).then(
                          (value) => _setDate(value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: _submitTransactionForm,
                      label: Text('Add Transaction'),
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
