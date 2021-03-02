import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import '../models/goals.dart';

// Form to add a new goal
class GoalsForm extends StatefulWidget {
  @override
  _GoalsFormState createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  Goal _goal = Goal(
    title: null,
    amountSaved: 0,
    goalAmount: null,
    dateOfGoal: null,
  );

  // TODO May need to change to update to DB
  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      // update date if date changes since no onsave property
      _goal.setDate(_date = value);
    }
        // TODO call GoalDataProvider to update date attribute; will need a date attribute in Firestore
        );
  }

  // Validates the goal object then pushes its data to the DB
  void _submitGoalForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_goal.getID() == null)
        Provider.of<GoalDataProvider>(context, listen: false)
            .addGoal(_goal, context);
      Provider.of<GoalDataProvider>(context, listen: false)
          .updateGoal(_goal, context);
      Navigator.of(context).pop(
        _goal,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Container(
        height: 380,
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
                children: <Widget>[
                  GoalTitleField(
                    goal: _goal,
                  ),
                  GoalAmountField(
                    goal: _goal,
                  ),
                  buildDateChanger(context),
                  SizedBox(
                    height: 25,
                  ),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildSubmitButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _submitGoalForm(context);
        },
        label: Text("Add Goal"),
      ),
    );
  }

  // Changes the date of the goal
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
}

// Accepts input from keyboard and validates as Goal Title
class GoalTitleField extends StatelessWidget {
  const GoalTitleField({
    Key key,
    @required Goal goal,
  })  : _goal = goal,
        super(key: key);

  final Goal _goal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _goal.title ?? '',
      decoration: InputDecoration(
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
        labelText: "Goal Title",
      ),
      autofocus: true,
      style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
      inputFormatters: [
        LengthLimitingTextInputFormatter(15),
      ],
      maxLength: 50,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      onSaved: (val) => _goal.title = val.trim(),
      validator: (val) {
        if (val.trim().length > 50) return 'Title is too long.';
        if (val.isEmpty) return 'Please enter a title.';
        return null;
      },
    );
  }
}

// Accepts input from keyboard and validates as Goal Amount
class GoalAmountField extends StatelessWidget {
  const GoalAmountField({
    Key key,
    @required Goal goal,
  })  : _goal = goal,
        super(key: key);

  final Goal _goal;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: _goal.goalAmount == null ? '' : _goal.goalAmount.toString(),
      decoration: InputDecoration(
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
        labelText: "Amount",
      ),
      keyboardType: TextInputType
          .number, // May want to use Currency_Input_Formatter like income.dart
      onSaved: (val) => _goal.goalAmount = double.parse(val),
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
