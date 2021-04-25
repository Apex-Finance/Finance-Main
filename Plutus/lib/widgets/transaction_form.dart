// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../models/category.dart';
import '../models/transaction.dart' as Transaction;

// Form to add a new transaction
class TransactionForm extends StatefulWidget {
  final Transaction.Transaction transaction;
  TransactionForm(
      {this.transaction}); //optional constructor for editing transaction

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  Transaction.Transaction _transaction = new Transaction.Transaction.empty();

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
  void _setCategory(Category category) {
    if (category.getTitle() == null) return; // if user taps out of popup
    setState(() {
      _transaction.setCategoryId(category.getID());
      _transaction.setCategoryCodePoint(category.getCodepoint());
      _transaction.setCategoryTitle(category.getTitle());
    });
  }

  // If each textformfield passes the validation, save it's value to the transaction, and return the transaction to the previous screen
  void _submitTransactionForm(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_transaction.getID() == null) {
        transactionDataProvider.addTransaction(
          transaction: _transaction,
          context: context,
        );
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
    if (widget.transaction == null) {
      _transaction.setDate(_date);
      _transaction.setCategoryId(
          "CbPdG5AksSODRfuf7319"); // id for uncategorized category
      _transaction.setCategoryTitle("Uncategorized");
      _transaction.setCategoryCodePoint(58947);
    }

    // _transaction.category =
    //     category; // initialize date and category since no onsave property
    // _transaction.date = _date;

    if (widget.transaction != null) {
      // if editing, store previous values in transaction to display previous values and submit them later
      _transaction.setID(widget.transaction.getID());
      _transaction.setTitle(widget.transaction.getTitle());
      _transaction.setAmount(widget.transaction.getAmount());
      _transaction.setDate(widget.transaction.getDate());
      _transaction.setCategoryId(widget.transaction.getCategoryId());
      _transaction.setCategoryTitle(widget.transaction.getCategoryTitle());
      _transaction
          .setCategoryCodePoint(widget.transaction.getCategoryCodePoint());
      _transaction.setGoalId(widget.transaction.getGoalId());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      // stops keyboard from overlapping form
      child: SingleChildScrollView(
        child: Container(
          height: 390, // large enough to accommodate all errors
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
          transactionId == null ? 'Add Transaction' : 'Edit Transaction',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  Row buildDateChanger(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: _transaction.getDate().year == DateTime.now().year ? 125 : 175,
          child: Text(
            _transaction.getDate().year == DateTime.now().year
                ? 'Date: ${DateFormat.MMMd().format(_transaction.getDate())}'
                : 'Date: ${DateFormat.yMMMd().format(_transaction.getDate())}',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Pick Date',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          onPressed: () => showDatePicker(
            context: context,
            initialDate: _transaction.getDate(),
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

  Widget buildCategoryChanger(BuildContext context) {
    Category category = new Category();
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);
    List<Category> categories = [];
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Category: ',
          style: TextStyle(
            fontSize: 16,
            color: _transaction.getGoalId() != null
                ? Colors.grey
                : Theme.of(context).primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => _transaction.getGoalId() != null
              ? null
              : showDialog(
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 600,
                            width: 400,
                            child: StreamBuilder(
                                stream: categoryDataProvider
                                    .streamCategoriesWithoutGoal(context),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      {
                                        return Text(
                                            'There was an error loading your categories.');
                                      }
                                    case ConnectionState.waiting:
                                      {
                                        return CircularProgressIndicator();
                                      }
                                    default:
                                      {
                                        snapshot.data.docs.forEach((element) {
                                          categories.add(categoryDataProvider
                                              .initializeCategory(element));
                                        });
                                        return ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (context, index) {
                                            category = categoryDataProvider
                                                .initializeCategory(
                                                    snapshot.data.docs[index]);
                                            return ListTile(
                                              tileColor:
                                                  Theme.of(context).canvasColor,
                                              leading: Icon(
                                                IconData(
                                                  categories[index]
                                                      .getCodepoint(),
                                                  fontFamily: 'MaterialIcons',
                                                ),
                                                size: 30,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              title: Text(
                                                '${categories[index].getTitle()}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 18,
                                                  fontFamily: 'Anton',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () {
                                                _setCategory(categories[index]);

                                                Navigator.of(context)
                                                    .pop(category);
                                              },
                                            );
                                          },
                                        );
                                      }
                                  }
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          child: Chip(
            avatar: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Icon(
                IconData(
                  _transaction.getCategoryCodePoint(),
                  fontFamily: 'MaterialIcons',
                ),
                size: 22,
                color: _transaction.getGoalId() != null
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
            ),
            label: Text(
              '${_transaction.getCategoryTitle()}',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            backgroundColor: _transaction.getGoalId() != null
                ? Colors.grey
                : Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

// will return the collection of default categories or categories for the bduget if a corresponding budget exists

class AmountTFF extends StatelessWidget {
  const AmountTFF({
    Key key,
    @required Transaction.Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction.Transaction _transaction;

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
      autofocus: _transaction.getGoalId() != null,
      onEditingComplete: () => FocusScope.of(context).unfocus(),
      onSaved: (val) => _transaction.setAmount(double.parse(val)),
      validator: (val) {
        if (val.isEmpty) return 'Please enter an amount.';
        if (val.contains(new RegExp(r'^\d*(\.\d*)?$'))) {
          // only accept any number of digits followed by 0 or 1 decimals followed by any number of digits
          if (double.parse(double.parse(val).toStringAsFixed(2)) <=
              0.00) // seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
            return 'Please enter an amount greater than 0.';
          if (double.parse(double.parse(val).toStringAsFixed(2)) > 999999999.99)
            return 'Max amount is \$999,999,999.99'; // no transactions >= $1billion
          return null;
        } else {
          return 'Please enter a valid number.';
        }
      },
    );
  }
}

class DescriptionTFF extends StatelessWidget {
  const DescriptionTFF({
    Key key,
    @required Transaction.Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction.Transaction _transaction;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: _transaction.getGoalId() == null,
      initialValue: _transaction.getTitle() ?? '',
      decoration: InputDecoration(
        labelText: 'Transaction Title',
        labelStyle: new TextStyle(
            color: _transaction.getGoalId() != null
                ? Colors.grey
                : Theme.of(context).primaryColor,
            fontSize: 16.0),
      ),
      style: TextStyle(
          fontSize: 20.0,
          color: _transaction.getGoalId() != null
              ? Colors.grey
              : Theme.of(context).primaryColor),
      autofocus: _transaction.getGoalId() == null,
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      maxLength: 20,
      readOnly: _transaction.getGoalId() != null,
      onEditingComplete: () => FocusScope.of(context).nextFocus(),
      onSaved: (val) => _transaction.setTitle(val.trim()),
      validator: (val) {
        if (val.trim().length > 20) return 'Description is too long.';
        if (val.isEmpty) return 'Please enter a description.';
        return null;
      },
    );
  }
}
