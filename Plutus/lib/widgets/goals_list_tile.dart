import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:percent_indicator/percent_indicator.dart';
import '../models/goals.dart';
import '../widgets/goals_form.dart';
import '../screens/add_goal_money_screen.dart';

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
      builder: (_) => AddGoalMoneyScreen(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
            padding: EdgeInsets.only(right: 20),
            margin: EdgeInsets.symmetric(
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
                title: Text('Do you want to remove this goal?'),
                content: Text(
                  'This cannot be undone later.',
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
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
            Scaffold.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text('Goal deleted.'),
                ),
              );
          },
          child: Column(children: [
            ListTile(
              onTap: () => _updateGoal(context, widget.goal),
              contentPadding: EdgeInsets.all(4),
              tileColor: Colors.grey[850],
              leading: Container(
                width: 80,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24),
                  ),
                ),
                // Goal image preview
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    'https://2p2bboli8d61fqhjiqzb8p1a-wpengine.netdna-ssl.com/wp-content/uploads/2018/07/1.jpg',
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
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 12,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 5),
                    // Visual bar graph that displays amount currently saved
                    // and the goal amount
                    child: new LinearPercentIndicator(
                      center: AutoSizeText(
                        '\$ ${widget.goal.getAmountSaved(context).toStringAsFixed(0)} of \$ ${widget.goal.getGoalAmount()}',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      percent: widget.goal.getAmountSaved(context) == null
                          ? 0.0
                          : widget.goal.getAmountSaved(context) >
                                  widget.goal.getGoalAmount()
                              ? 1
                              : widget.goal.getAmountSaved(context) /
                                  widget.goal.getGoalAmount(),
                      alignment: MainAxisAlignment.start,
                      width: MediaQuery.of(context).size.width * .46,
                      lineHeight: 20,
                      backgroundColor: Colors.black,
                      progressColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              // Add money button
              trailing: Container(
                // Needed to keep the same size border as CircleAvatar border
                height: 100,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.0,
                      color: Colors.white24,
                    ),
                  ),
                ),
                // TODO May want to change this to a gesture detector with child container with child icon.
                // TODO This enables you to click on the entire container and not just the icon.
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
