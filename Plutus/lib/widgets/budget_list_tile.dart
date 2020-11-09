import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetListTile extends StatefulWidget {
  final Budget budget;

  BudgetListTile(this.budget);

  @override
  _BudgetListTileState createState() => _BudgetListTileState();
}

class _BudgetListTileState extends State<BudgetListTile> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(
            20)), //BorderRadius.vertical(top: Radius.circular(20)),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              tileColor: Colors.grey[850],
              title: AutoSizeText(
                '${widget.budget.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
              subtitle: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  new LinearPercentIndicator(
                    width: 350.0,
                    lineHeight: 12.0,
                    percent: 0.5,
                    backgroundColor: Colors.black,
                    progressColor: Colors.amber,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '\$Amount left of \$${widget.budget.amount}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ],
              ),
            ),
            if (_expanded)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                color: Colors.blue,
                height: 30,
                child: Text(
                  'list of transactions',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
