import 'package:Plutus/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/categories.dart';
import '../models/category_icon.dart';

// Form to add a new transaction
class TransactionForm extends StatefulWidget {
  final Transaction transaction;
  TransactionForm(
      {this.transaction}); //optional constructor for editing transaction

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  Transaction _transaction = new Transaction();
  MainCategory category = MainCategory.uncategorized;

  // Change the date of the transaction
  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      _transaction.setDate(_date = value);
      // _transaction.date =
      //     _date = value;
      // update date if date changes since no onsave property
    });
  }

  // Change the category of the transaction
  //TODO this may need to be heavily revised after we set up the stream for
  //TODO categories
  void _setCategory(String value) {
    if (value == null) return; // if user taps out of popup
    setState(() {
      _transaction.setCategoryId(value);
      // _transaction.category = category =
      //     value; // update category if category changes since no onsave property
    });
  }

  // If each textformfield passes the validation, save it's value to the transaction, and return the transaction to the previous screen
  void _submitTransactionForm(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transactions>(context, listen: false);
    categoryIcon.forEach((key, value) {
      print('$key, ${value.codePoint}');
    });

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_transaction.getID() == null) {
        transactionDataProvider.addTransaction(_transaction, context);
      } else {
        transactionDataProvider.editTransaction(_transaction, context);
      }
      Navigator.of(context).pop(
        _transaction,
      );
    }
  }

  @override
  void initState() {
    // _transaction.setCategory(category);
    _transaction.setDate(_date);
    // _transaction.category =
    //     category; // initialize date and category since no onsave property
    // _transaction.date = _date;

    if (widget.transaction != null) {
      // if editing, store previous values in transaction to display previous values and submit them later
      _transaction.setTitle(widget.transaction.getTitle());
      _transaction.setCategoryId(widget.transaction.getCategoryId());
      _transaction.setAmount(widget.transaction.getAmount());
      _transaction.setDate(widget.transaction.getDate());
      // _transaction.id = widget.transaction.id;
      // _transaction.title = widget.transaction.title;
      // _transaction.category = category = widget.transaction.category;
      // _transaction.amount = widget.transaction.amount;
      // _transaction.date = _date = widget.transaction.date;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      // stops keyboard from overlapping form
      child: Container(
        height: 380, // large enough to accommodate all errors
        child: Card(
          color: Colors.grey[850],
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
                  DescriptionTFF(transaction: _transaction),
                  AmountTFF(transaction: _transaction),
                  buildCategoryChanger(context),
                  buildDateChanger(context),
                  SizedBox(
                    height: 25,
                  ),
                  buildSubmitButton(context, _transaction.getID()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildSubmitButton(BuildContext context, String transactionId) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _submitTransactionForm(context);
        },
        label: Text(
            transactionId == null ? 'Add Transaction' : 'Edit Transaction'),
      ),
    );
  }

  Row buildDateChanger(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 125,
          child: Text(
            'Date: ${DateFormat.MMMd().format(_date)}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
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
    );
  }

  Row buildCategoryChanger(BuildContext context) {
    //TODO this will need to be rebuilt to stream the default categories in the
    //TODO database so we can tie the title and id to the transaction; this will
    //TODO eventually help with custom categories
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Category: ',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => showDialog(
            context: context,
            builder: (bctx) => SimpleDialog(
              backgroundColor: Theme.of(context).primaryColor,
              title: Text(
                'Choose Category',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Anton',
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                ...MainCategory.values
                    .map(
                      (category) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ListTile(
                            tileColor: Theme.of(context).canvasColor,
                            leading: Icon(
                              categoryIcon[category],
                              size: 30,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              '${stringToUserString(enumValueToString(category))}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontFamily: 'Anton',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(category);
                            },
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ],
            ),
          ).then((chosenCategory) => _setCategory(chosenCategory)),
          child: Chip(
            avatar: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                categoryIcon[category],
              ),
            ),
            label: Text(
              '${stringToUserString(enumValueToString(category.toString()))}',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Theme.of(context).primaryColorLight,
          ),
        ),
      ],
    );
  }
}

class AmountTFF extends StatelessWidget {
  const AmountTFF({
    Key key,
    @required Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction _transaction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _transaction.getAmount() == null
          ? ''
          : _transaction.getAmount().toString(),
      decoration: InputDecoration(
        labelText: 'Amount',
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
      ),
      style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
      keyboardType: TextInputType.number,
      maxLength: null,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      onSaved: (val) => _transaction.setAmount(double.parse(val)),
      validator: (val) {
        if (val.isEmpty) return 'Please enter an amount.';
        if (val.contains(new RegExp(r'^\d*(\.\d+)?$'))) {
          // only accept any number of digits followed by 0 or 1 decimals followed by any number of digits
          if (double.parse(double.parse(val).toStringAsFixed(2)) <=
              0.00) // seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
            return 'Please enter an amount greater than 0.';
          if (double.parse(double.parse(val).toStringAsFixed(2)) > 999999999.99)
            return 'Max amount is \$999,999,999.99'; // no transactions >= $1billion
          return null;
        } else {
          return 'Please enter a number.';
        }
      },
    );
  }
}

class DescriptionTFF extends StatelessWidget {
  const DescriptionTFF({
    Key key,
    @required Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction _transaction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _transaction.getTitle() ?? '',
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
      ),
      style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
      autofocus: true,
      inputFormatters: [
        LengthLimitingTextInputFormatter(15),
      ],
      maxLength: 15,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      onSaved: (val) => _transaction.setTitle(val.trim()),
      validator: (val) {
        if (val.trim().length > 15) return 'Description is too long.';
        if (val.isEmpty) return 'Please enter a description.';
        return null;
      },
    );
  }
}
