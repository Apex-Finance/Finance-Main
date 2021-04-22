import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import '../models/goals.dart';
import '../models/transaction.dart' as Transaction;

// Form for adding money to a goal
class AddGoalMoneyScreen extends StatefulWidget {
  final Goal goal;
  @override
  _AddGoalMoneyScreenState createState() => _AddGoalMoneyScreenState();
  AddGoalMoneyScreen({this.goal});
}

double amountSaved =
    0.0; // Amount currently saved up for a goal; is calculated in runtime

class _AddGoalMoneyScreenState extends State<AddGoalMoneyScreen> {
  Transaction.Transaction _transaction = new Transaction.Transaction.empty();
  final _formKey = GlobalKey<FormState>();

  // Validates the amount entered, saves its value to the goal, and
  // returns the goal to the previous screen
  void _submitAddMoneyForm(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context, listen: false);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _transaction.setAmount(amountSaved);
      _transaction.setTitle('${widget.goal.getTitle()}');
      // No need to go looking for category name. All transactions created here will have their categories set to Goal.
      _transaction.setCategoryTitle('Goal');
      _transaction.setCategoryId('GYHEkJeJsFG09HUw14p3'); // Goal Id
      _transaction.setCategoryCodePoint(59938); // Goal (star) codepoint

      // Sets the date of the transaction to the date the amount was added
      _transaction.setDate(DateTime.now());

      // Creates a transaction that is tied to the money added to this goal
      transactionDataProvider.addTransaction(
          transaction: _transaction,
          context: context,
          goalID: widget.goal.getID());
      Navigator.of(context).pop(widget.goal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Container(
        height: 300,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Title
                  AutoSizeText(
                    'Add money to ${widget.goal.getTitle()}',
                    style: Theme.of(context).textTheme.headline1,
                    overflow: TextOverflow.visible,
                    textAlign: TextAlign.center,
                  ),
                  // Goal amount left to go
                  StreamBuilder<QuerySnapshot>(
                      stream: Provider.of<Transaction.Transactions>(context,
                              listen: false)
                          .getGoalTransactions(context, widget.goal.getID()),
                      builder: (context, snapshot) {
                        var amountSaved = snapshot.data.docs.isEmpty
                            ? 0
                            : widget.goal
                                .getAmountSaved(context, snapshot.data);
                        return AutoSizeText(
                          widget.goal.getGoalAmount() - amountSaved < 0
                              ? '\$ ${(widget.goal.getGoalAmount() - amountSaved).abs().toStringAsFixed(2)} extra saved'
                              : '\$ ${(widget.goal.getGoalAmount() - amountSaved).toStringAsFixed(2)} left to go',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                          ),
                        );
                      }),
                  // Textfield for adding amounts
                  Row(
                    children: <Widget>[
                      Text('\$', style: Theme.of(context).textTheme.bodyText1),
                      Expanded(
                        child: GoalAmountField(
                          goal: widget.goal,
                        ),
                      ),
                    ],
                  ),
                  // Add Money button
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      label: Text('Add Money'),
                      onPressed: () => _submitAddMoneyForm(context),
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

// Accepts input from keyboard and validates as Goal Amount Saved
class GoalAmountField extends StatelessWidget {
  GoalAmountField({
    Key key,
    @required Goal goal,
  }) : //_goal = goal,
        super(key: key);

  //final Goal _goal;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context).textTheme.bodyText1,
      autofocus: true,
      decoration: InputDecoration(
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
      ),
      keyboardType: TextInputType.number,
      onSaved: (val) {
        amountSaved = double.parse(val);
      },
      validator: (val) {
        if (val.contains(new RegExp(r'^\d*(\.\d*)?$'))) {
          // OLD REGEX r'-?[0-9]\d*(\.\d+)?$'
          // only accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
          if (double.parse(double.parse(val).toStringAsFixed(2)) <=
              0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
            return 'Please enter an amount greater than 0.';
          // Let user save more than goal amount
          // if (double.parse(double.parse(val).toStringAsFixed(2)) >
          //     _goal.getGoalAmount())
          //   return 'Amount cannot be greater than the Goal Amount';
          return null;
        } else {
          return 'Please enter a valid number.';
        }
      },
    );
  }
}
