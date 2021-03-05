import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:percent_indicator/percent_indicator.dart';
import '../models/goals.dart';
import '../widgets/goals_form.dart';

// List Tile that displayes each individual goal
class GoalsListTile extends StatefulWidget {
  final Goal goal;
  @override
  _GoalsListTileState createState() => _GoalsListTileState();
  GoalsListTile(this.goal);
}

class _GoalsListTileState extends State<GoalsListTile> {
  void _updateGoal(BuildContext context, Goal goal) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(goal: goal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
          child: ListTile(
            onTap: () => _updateGoal(context, widget.goal),
            contentPadding: EdgeInsets.all(10),
            tileColor: Colors.grey[850],
            leading: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://2p2bboli8d61fqhjiqzb8p1a-wpengine.netdna-ssl.com/wp-content/uploads/2018/07/1.jpg',
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  '${widget.goal.getTitle()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  '${DateFormat.MMMd().format(widget.goal.getDate())}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new LinearPercentIndicator(
                  leading: AutoSizeText(
                    '\$ ${widget.goal.getAmount()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  ),
                  trailing: AutoSizeText(
                    '\$ ${widget.goal.getGoalAmount()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  ),
                  alignment: MainAxisAlignment.start,
                  width: MediaQuery.of(context).size.width * .25,
                  lineHeight: 8.0,
                  backgroundColor: Colors.black,
                  progressColor: Colors.amber,
                ),

                //Text(
                //"Due Date: ${DateFormat.MMMd().format(widget.goal.getDate())}",
                //style: Theme.of(context).textTheme.bodyText2,
                //),
              ],
            ),
            trailing: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.edit),
              // TODO add money screen
              onPressed: () {},
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}
