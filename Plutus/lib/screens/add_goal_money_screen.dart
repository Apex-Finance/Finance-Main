import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import '../models/goals.dart';

class AddGoalMoneyScreen extends StatefulWidget {
  final Goal goal;
  @override
  _AddGoalMoneyScreenState createState() => _AddGoalMoneyScreenState();
  AddGoalMoneyScreen({this.goal}); // TODO comment this
}

class _AddGoalMoneyScreenState extends State<AddGoalMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
// TODO Set initstate

  void _submitAddMoneyForm(BuildContext context) {
    var goalDataProvider =
        Provider.of<GoalDataProvider>(context, listen: false);

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      goalDataProvider.updateGoal(widget.goal, context);
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
                children: <Widget>[
                  Text(
                    'Add money to your goal',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  Text(
                    '\$ ${widget.goal.getAmount()}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {},
                        color: Theme.of(context).primaryColorLight,
                        child: Text('+ \$10'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: Theme.of(context).primaryColorLight,
                        child: Text('+ \$25'),
                      ),
                      RaisedButton(
                        onPressed: () {},
                        color: Theme.of(context).primaryColorLight,
                        child: Text('+ \$100'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Text(
                          'Custom Amount: ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: GoalAmountField(
                          goal: widget.goal,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
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

// TODO Comment
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
      initialValue:
          _goal.amountSaved == null ? '' : '\$ ${_goal.amountSaved.toString()}',
      decoration: InputDecoration(
        labelStyle: new TextStyle(
            color: Theme.of(context).primaryColor, fontSize: 16.0),
      ),
      keyboardType: TextInputType.number,
      onSaved: (val) {
        _goal.amountSaved = _goal.amountSaved + double.parse(val);
      },
      inputFormatters: [
        CurrencyTextInputFormatter(),
      ],
      // REGEX from income.dart
      validator: (val) {
        if (val.contains(new RegExp(r'^-?\d{0,3}(,\d{3}){0,3}(.\d+)?$'))) {
          // ^-?\d+(\.\d{1,2})?$
          // OLD REGEX r'-?[0-9]\d*(\.\d+)?$'
          // only accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
          if (double.parse(
                  double.parse(val.replaceAll(",", "")).toStringAsFixed(2)) <=
              0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
            return 'Please enter an amount greater than 0.';
          return null;
        } else {
          return 'Please enter a number.';
        }
      },
    );
  }
}
