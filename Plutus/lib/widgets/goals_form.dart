//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../models/goals.dart';
import '../models/transaction.dart' as Transaction;

// Form to add a new goal
class GoalsForm extends StatefulWidget {
  final Goal goal;
  GoalsForm({this.goal}); // Optional constructor for editing goal

  @override
  _GoalsFormState createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date;
  Goal _goal = Goal.empty();
  //File _goalImage; // Image selected from the phone gallery

  @override
  // If editing, store previous values in goal to display previous values and submit them later
  void initState() {
    if (widget.goal != null) {
      _goal.setID(widget.goal.getID());
      _goal.setTitle(widget.goal.getTitle());
      _goal.setGoalAmount(widget.goal.getGoalAmount());
      _goal.setDate(widget.goal.getDate());
    } else {
      _goal.setDate(_date);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
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
                  children: <Widget>[
                    // Title Text Field
                    GoalTitleField(
                      goal: _goal,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Goal Amount Text Field
                    GoalAmountField(
                      goal: _goal,
                    ),
                    DateChanger(
                      goal: _goal,
                    ),
                    SubmitButton(
                      goal: _goal,
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

// Changes the date of the goal
class DateChanger extends StatefulWidget {
  const DateChanger({
    Key key,
    @required Goal goal,
  })  : _goal = goal,
        super(key: key);

  final Goal _goal;

  @override
  _DateChangerState createState() => _DateChangerState();
}

class _DateChangerState extends State<DateChanger> {
  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      widget._goal.setDate(
          value); // update date if date changes since no onsave property
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
            ),
            child: widget._goal.getDate() == null
                ? Text(
                    'Due Date',
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  )
                : Text(
                    widget._goal.getDate().year == DateTime.now().year
                        ? '${DateFormat.MMMd().format(widget._goal.getDate())}'
                        : '${DateFormat.yMMMd().format(widget._goal.getDate())}',
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
            onPressed: () => showDatePicker(
              context: context,
              initialDate: widget._goal.getDate() == null
                  ? DateTime.now()
                  : (widget._goal.getDate().isBefore(DateTime.now())
                      ? DateTime.now()
                      : widget._goal.getDate()),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                Duration(
                  days: 3652, // ~=10 years
                ),
              ),
            ).then(
              (value) => _setDate(value),
            ),
          ),
        ),
      ],
    );
  }
}

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    Key key,
    @required Goal goal,
    @required GlobalKey<FormState> formKey,
  })  : _goal = goal,
        _formKey = formKey,
        super(key: key);

  final Goal _goal;
  final GlobalKey<FormState> _formKey;

  // Validates each required textfield, saves its value to the goal, and
  // returns the goal to the previous screen
  void _submitGoalForm(BuildContext context) {
    var goalDataProvider =
        Provider.of<GoalDataProvider>(context, listen: false);
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context, listen: false);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      // If no date is set, set the date to today's date
      if (_goal.getDate() == null) _goal.setDate(DateTime.now());
      if (_goal.getID() == null) {
        goalDataProvider.addGoal(_goal, context);
      } else {
        goalDataProvider.updateGoal(_goal, context);
        transactionDataProvider.updateGoalTransactions(_goal, context);
      }
      Navigator.of(context).pop(_goal);
    }
  }

  // Validates required fields and sends goal data to DB
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
      child: Container(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _submitGoalForm(context),
          label: Text(
            _goal.getID() == null ? "Add Goal" : "Edit Goal",
            style: TextStyle(color: Theme.of(context).canvasColor),
          ),
        ),
      ),
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
        labelStyle:
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
        labelText: "Goal Title",
      ),
      autofocus: true,
      style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
      inputFormatters: [
        LengthLimitingTextInputFormatter(20),
      ],
      maxLength: 20,
      onEditingComplete: () {
        FocusScope.of(context).nextFocus();
      },
      onSaved: (val) => _goal.title = val.trim(),
      validator: (val) {
        if (val.trim().length > 20) return 'Title is too long.';
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
        labelStyle:
            TextStyle(color: Theme.of(context).primaryColor, fontSize: 16.0),
        labelText: "Target Amount",
      ),
      style: TextStyle(fontSize: 20.0, color: Theme.of(context).primaryColor),
      keyboardType: TextInputType
          .number, // May want to use Currency_Input_Formatter like income.dart
      onSaved: (val) => _goal.goalAmount = double.parse(val),
      validator: (val) {
        if (val.isEmpty) return 'Please enter an amount.';
        if (val.contains(RegExp(r'^\d*(\.\d*)?$'))) {
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
