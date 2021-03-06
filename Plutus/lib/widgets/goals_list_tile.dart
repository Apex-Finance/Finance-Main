// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
import 'package:percent_indicator/percent_indicator.dart';
import '../models/goals.dart';
import '../widgets/goals_form.dart';
import './add_goal_money_form.dart';
import '../providers/color.dart';
import '../models/transaction.dart' as Transaction;

// List Tile that displays each individual goal
class GoalsListTile extends StatefulWidget {
  final Goal goal;
  @override
  _GoalsListTileState createState() => _GoalsListTileState();
  GoalsListTile(this.goal);
}

class _GoalsListTileState extends State<GoalsListTile> {
  // Displays the goal form if editing
  void _updateGoal(BuildContext context, Goal goal) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(goal: goal),
    );
  }

  // Displays a dialog box where amounts can be entered in to progress a goal
  void _addGoalMoney(BuildContext context, Goal goal) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => AddGoalMoneyForm(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorProvider = Provider.of<ColorProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        // Deletes a goal if list tile is swiped from right to left
        child: Dismissible(
          key: ValueKey(widget.goal.getID()),
          background: Container(
            color: Theme.of(context).errorColor,
            child: Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            // Displays a dialog box confirming the deletion of a goal
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor:
                    colorProvider.colorOptions[colorProvider.selectedColorIndex]
                        [colorProvider.isDark ? 'dark' : 'light']['cardColor'],
                title: const Text(
                  'Do you want to remove this goal?',
                ),
                content: const Text(
                  'This cannot be undone later.',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Yes',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            Provider.of<GoalDataProvider>(context, listen: false)
                .removeGoal(widget.goal, context);
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: const Text('Goal deleted.'),
                ),
              );
          },
          child: Column(children: [
            ListTile(
              onTap: () => _updateGoal(context, widget.goal),
              contentPadding: EdgeInsets.all(4),
              tileColor: Theme.of(context).backgroundColor,
              leading: Container(
                width: 80,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24),
                  ),
                ),
                // Goal icon
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 35,
                  child: Icon(
                    Icons.star,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Goal title
                  AutoSizeText(
                    '${widget.goal.getTitle()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date the goal is due
                  Text(
                    '${DateFormat.yMMMd().format(widget.goal.getDate())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12,
                        color: colorProvider.isDark
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).canvasColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                    // Visual bar graph that displays amount currently saved
                    // and the goal amount
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Provider.of<Transaction.Transactions>(context,
                                listen: false)
                            .getGoalTransactions(context, widget.goal.getID()),
                        builder: (context, snapshot) {
                          var amountSaved =
                              !snapshot.hasData || snapshot.data.docs.isEmpty
                                  ? 0
                                  : widget.goal
                                      .getAmountSaved(context, snapshot.data);
                          return LinearPercentIndicator(
                            center: amountSaved >= widget.goal.getGoalAmount()
                                ? AutoSizeText(
                                    'Completed!',
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : AutoSizeText(
                                    '\$ ${amountSaved.toStringAsFixed(2)} of \$ ${widget.goal.getGoalAmount().toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context).canvasColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            percent: amountSaved == null
                                ? 0.0
                                : amountSaved > widget.goal.getGoalAmount()
                                    ? 1
                                    : amountSaved / widget.goal.getGoalAmount(),
                            alignment: MainAxisAlignment.start,
                            lineHeight: 20,
                            progressColor: Theme.of(context).primaryColor,
                          );
                        }),
                  ),
                ],
              ),
              // Add money button
              trailing: Container(
                // Needed to keep the same size border as CircleAvatar border
                height: 100,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.0,
                      color: Colors.white24,
                    ),
                  ),
                ),
                child: IconButton(
                  color: Theme.of(context).primaryColor,
                  icon: Icon(Icons.add),
                  onPressed: () => _addGoalMoney(context, widget.goal),
                ),
              ),
              isThreeLine: true,
            ),
          ]),
        ),
      ),
    );
  }
}
