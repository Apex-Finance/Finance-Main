// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
import '../auth_screen.dart';
import './first_budget_screen.dart';
import '../tab_screen.dart';
import '../../models/budget.dart';
import '../../models/month_changer.dart';
import '../../models/category.dart';

// Screen that asks for the monthly income and creates a budget on that amount
class IncomeScreen extends StatefulWidget {
  static const routeName = '/income';

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isNewBudget = false;
  bool init = true;
  List<Category> uneditedBudget = []; // starts out as empty list
  Budget originalBudget;
  bool fbsInit = true;

  // using didChangeDependencies with init "trick" since ModalRoute cant be called in initstate
  // only runs once, right after initstate
  @override
  void didChangeDependencies() {
    if (init) {
      // make a deep copy of the budget (specifically, to store the original amount)
      originalBudget = Budget.copy(ModalRoute.of(context).settings.arguments);

      // check if new or edited budget to display Add or Edit Budget
      if (originalBudget.getID() != null) {
        isNewBudget = false;
      } else
        isNewBudget = true;
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Budget budget = ModalRoute.of(context).settings.arguments;
    var monthData = Provider.of<MonthChanger>(context);
    // Creates an AlertDialog Box that notifies the user of discard changes
    Future<void> _showDiscardBudgetDialog(
        bool isNewBudget, List<Category> uneditedBudget,
        [bool delete = false]) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[800],
            title: Text(
              delete ? 'Do you want to delete this budget?' : 'Cancel',
              style: Theme.of(context).textTheme.headline1,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    delete
                        ? 'This cannot be undone later.'
                        : 'Would you like to discard these changes?',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  if (delete) {
                    // delete the new budget
                    Provider.of<BudgetDataProvider>(context, listen: false)
                        .deleteBudget(budget.getID(), context);
                  } else if (isNewBudget) {
                    // delete the new budget
                    Provider.of<BudgetDataProvider>(context, listen: false)
                        .deleteBudget(budget.getID(), context);
                  } else {
                    //edited budget
                    if (uneditedBudget.isNotEmpty) {
                      // if changes were made to edited budget amounts, revert them
                      uneditedBudget.forEach((category) async {
                        await Provider.of<CategoryDataProvider>(context,
                                listen: false)
                            .uploadCategory(budget.getID(), category, context);
                      });
                      // remove categories of 0 amount
                      uneditedBudget.forEach((category) async {
                        if (category.getAmount() == 0) {
                          await Provider.of<CategoryDataProvider>(context,
                                  listen: false)
                              .removeCategory(
                                  budget.getID(), category.getID(), context);
                        }
                      });
                    }
                    //push the original budget's amount in case it changed
                    Provider.of<BudgetDataProvider>(context, listen: false)
                        .editBudget(originalBudget, context);
                  }
                  // removes all screens except login (i.e., removes IS and FBS so can't re-edit deleted/edited budget; and technically any settings or account screen)
                  // use this and not popUntil to fix bug where if user tapped a unbudgeted category in FBS, it would get removed from budget
                  // and then budget screen needed to be refreshed
                  Navigator.pushNamedAndRemoveUntil(
                      context,
                      TabScreen.routeName,
                      ModalRoute.withName(AuthScreen.routeName));
                },
              ),
              TextButton(
                  child: Text('No'),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          );
        },
      );
    }

    return WillPopScope(
      onWillPop: () async {
        _showDiscardBudgetDialog(isNewBudget, uneditedBudget);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: AutoSizeText('New Budget',
              style: Theme.of(context).textTheme.bodyText1),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                tooltip: 'Delete budget',
                onPressed: () => _showDiscardBudgetDialog(
                    isNewBudget, uneditedBudget, true)),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: KeyboardAvoider(
            child: Container(
              height: 400,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Title
                    AutoSizeText(
                      "Monthly Income",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 35,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        // Textfield where monthly income is entered
                        AutoSizeText('\$',
                            style: Theme.of(context).textTheme.bodyText1),
                        Expanded(
                          child: TextFormField(
                            initialValue: budget.getAmount() != null
                                ? budget.getAmount().toStringAsFixed(2)
                                : '',
                            style: Theme.of(context).textTheme.bodyText1,
                            autofocus: true,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: true, signed: false),
                            onEditingComplete: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                budget.setDate(DateTime(monthData.selectedYear,
                                    monthData.selectedMonth, 1));
                                if (budget.getID() != null) {
                                  Provider.of<BudgetDataProvider>(context,
                                          listen: false)
                                      .editBudget(budget, context);
                                } else {
                                  Provider.of<BudgetDataProvider>(context,
                                          listen: false)
                                      .addBudget(budget, context);
                                  isNewBudget = true;
                                  if (originalBudget.getAmount() == null) {
                                    originalBudget.setAmount(0.00);
                                  }
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FirstBudgetScreen(
                                        budget: budget,
                                        isNewBudget: isNewBudget,
                                        uneditedBudget: uneditedBudget,
                                        init: fbsInit,
                                        originalAmount:
                                            originalBudget.getAmount(),
                                      ),
                                    )).then((arguments) {
                                  fbsInit = false;
                                  uneditedBudget = arguments;
                                  //receive the original categories and amounts
                                  // will be passed back to FirstBudgetScreen if they decide to go back again
                                  // needed or else won't discard changes if they go to FBS and make changes, back to IS, again to FBS, back to IS then discard
                                });
                              }
                            },
                            // Prevents users from entering budgets >= $1billion
                            maxLength: 14,
                            onSaved: (val) => budget.setAmount(
                                double.parse(val.replaceAll(",", ""))),
                            validator: (val) {
                              if (val.contains(
                                  new RegExp(r'^-?\d+(\.\d{1,2})?$'))) {
                                //  accept any number of digits followed by 0 or 1 decimals followed by 1 or 2 numbers
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) <=
                                    0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                                  return 'Please enter an amount greater than 0.';
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) >
                                    999999999.99)
                                  return 'Max amount is \$999,999,999.99'; // no budget >= $1billion
                                return null;
                              } else {
                                return 'Please enter a valid number.';
                              }
                            },
                          ),
                        ),
                      ],
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
