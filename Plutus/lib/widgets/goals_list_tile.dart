import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:percent_indicator/percent_indicator.dart';
import '../models/goals.dart';
import '../widgets/goals_form.dart';

class GoalsListTile extends StatefulWidget {
  final Goal goal;

  GoalsListTile(this.goal);

  @override
  _GoalsListTileState createState() => _GoalsListTileState();
}

class _GoalsListTileState extends State<GoalsListTile> {
  void _updateGoal(BuildContext context, Goal goal) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(),
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
            tileColor: Colors.grey[850],
            leading: Image.network(
              'https://2p2bboli8d61fqhjiqzb8p1a-wpengine.netdna-ssl.com/wp-content/uploads/2018/07/1.jpg',
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  '${widget.goal.getTitle()}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      '02/22/2021',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    AutoSizeText(
                      '\$20 left',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),

                new LinearPercentIndicator(
                  alignment: MainAxisAlignment.center,
                  width: MediaQuery.of(context).size.width * .57,
                  lineHeight: 12.0,
                  backgroundColor: Colors.black,
                  progressColor: Colors.amber,
                ),

                //Text(
                //"Due Date: ${DateFormat.MMMd().format(widget.goal.getDate())}",
                //style: Theme.of(context).textTheme.bodyText2,
                //),
                Center(
                  child: AutoSizeText(
                    '\$20 of \$${widget.goal.getGoalAmount()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              ],
            ),
            isThreeLine: true,
          ),
        ),
      ),
    );
  }
}
