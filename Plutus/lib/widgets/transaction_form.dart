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

  @override
  void initState() {
    if (widget.transaction == null) {
      _transaction.setDate(_date);
      _transaction.setCategoryId(
          "CbPdG5AksSODRfuf7319"); // id for uncategorized category
      _transaction.setCategoryTitle("Uncategorized");
      _transaction.setCategoryCodePoint(58947);
    }

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
            color: Theme.of(context).cardColor,
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
                    CategoryChanger(transaction: _transaction),
                    DateChanger(transaction: _transaction),
                    const SizedBox(
                      height: 25,
                    ),
                    SubmitButton(
                      transaction: _transaction,
                      formKey: _formKey,
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

class DateChanger extends StatefulWidget {
  const DateChanger({
    Key key,
    @required Transaction.Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction.Transaction _transaction;

  @override
  _DateChangerState createState() => _DateChangerState();
}

class _DateChangerState extends State<DateChanger> {
  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      widget._transaction.setDate(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: widget._transaction.getDate().year == DateTime.now().year
              ? 125
              : 175,
          child: Text(
            widget._transaction.getDate().year == DateTime.now().year
                ? 'Date: ${DateFormat.MMMd().format(widget._transaction.getDate())}'
                : 'Date: ${DateFormat.yMMMd().format(widget._transaction.getDate())}',
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
            style: TextStyle(color: Theme.of(context).canvasColor),
          ),
          onPressed: () => showDatePicker(
            context: context,
            initialDate: widget._transaction.getDate().isBefore(DateTime.now()
                    .subtract(Duration(
                        days:
                            730))) // not perfect cuz of leap years but it'll do
                // people most likely won't be editing a transaction that's two years old and want that much precision
                ? DateTime.now()
                : widget._transaction.getDate(),
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
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key key, @required transaction, @required formKey})
      : _transaction = transaction,
        _formKey = formKey,
        super(key: key);

  final Transaction.Transaction _transaction;
  final GlobalKey<FormState> _formKey;

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
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _submitTransactionForm(context);
        },
        label: Text(
            _transaction.getID() == null
                ? 'Add Transaction'
                : 'Edit Transaction',
            style: TextStyle(color: Theme.of(context).canvasColor)),
      ),
    );
  }
}

class CategoryChanger extends StatefulWidget {
  const CategoryChanger({
    Key key,
    @required Transaction.Transaction transaction,
  })  : _transaction = transaction,
        super(key: key);

  final Transaction.Transaction _transaction;

  @override
  _CategoryChangerState createState() => _CategoryChangerState();
}

class _CategoryChangerState extends State<CategoryChanger> {
  Category category = new Category();

  List<Category> categories = [];

  void _setCategory(Category category) {
    if (category.getTitle() == null) return; // if user taps out of popup
    setState(() {
      widget._transaction.setCategoryId(category.getID());
      widget._transaction.setCategoryCodePoint(category.getCodepoint());
      widget._transaction.setCategoryTitle(category.getTitle());
    });
  }

  @override
  Widget build(BuildContext context) {
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Category: ',
          style: TextStyle(
            fontSize: 16,
            color: widget._transaction.getGoalId() != null
                ? Colors.grey
                : Theme.of(context).primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => widget._transaction.getGoalId() != null
              ? null
              : showDialog(
                  context: context,
                  builder: (bctx) => SimpleDialog(
                    backgroundColor: Theme.of(context).primaryColor,
                    title: Text(
                      'Choose Category',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
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
                                            'There was an error loading your categories.',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor));
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
                                                  fontFamily: 'Lato',
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
              backgroundColor: Theme.of(context).canvasColor,
              child: Icon(
                IconData(
                  widget._transaction.getCategoryCodePoint(),
                  fontFamily: 'MaterialIcons',
                ),
                size: 22,
                color: widget._transaction.getGoalId() != null
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ),
            ),
            label: Text(
              '${widget._transaction.getCategoryTitle()}',
              style: TextStyle(color: Theme.of(context).canvasColor),
            ),
            backgroundColor: widget._transaction.getGoalId() != null
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
