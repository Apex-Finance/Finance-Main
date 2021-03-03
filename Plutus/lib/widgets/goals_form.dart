import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import '../models/goals.dart';

// Form to add a new goal
class GoalsForm extends StatefulWidget {
  final Goal goal;
  GoalsForm({this.goal}); // Optional constructor for editing goal

  @override
  _GoalsFormState createState() => _GoalsFormState();
}

class _GoalsFormState extends State<GoalsForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  File _goalImage; // Image selected from the phone gallery
  Goal _goal = Goal(
    title: null,
    amountSaved: null,
    goalAmount: null,
    dateOfGoal: null,
  );

  void _setDate(DateTime value) {
    if (value == null) return; // if user cancels datepicker
    setState(() {
      _goal.setDate(_date =
          value); // update date if date changes since no onsave property
    });
  }

  // Validates the goal object then pushes its data to the DB
  void _submitGoalForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // TODO save image into DB
      Provider.of<GoalDataProvider>(context, listen: false)
          .addGoal(_goal, context);
      Navigator.of(context).pop(
        _goal,
      );
    }
  }

  // Gets the image from the phone gallery and displays it as an image preview
  Future getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _goalImage = File(pickedFile.path);
      }
    });
  }

  @override
  // If editing, store previous values in goal to display previous values and submit them later
  void initState() {
    if (widget.goal != null) {
      _goal.setTitle(widget.goal.getTitle());
      _goal.setAmountSaved(widget.goal.getAmount());
      _goal.setGoalAmount(widget.goal.getGoalAmount());
      // TODO getDate doesn't retrieve correct date (retrieves DateTime.now())
      _goal.setDate(widget.goal.getDate());
    }
    super.initState();
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
                  buildImageSelector(context),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Selects an image to add to a goal
  Row buildImageSelector(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: () => getImage(),
          child: Container(
            color: Theme.of(context).primaryColorLight,
            width: 85,
            height: 85,
            child: _goalImage == null
                ? Icon(Icons.camera_alt)
                : FittedBox(
                    fit: BoxFit.cover,
                    child: Image.file(_goalImage),
                  ),
          ),
        ),
        Padding(
            padding: EdgeInsets.all(15),
            child: Text("(Optional) Click to enter an Image")),
      ],
    );
  }

  // Validates required fields and sends goal data to DB
  Container buildSubmitButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColorLight,
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
        LengthLimitingTextInputFormatter(50),
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
