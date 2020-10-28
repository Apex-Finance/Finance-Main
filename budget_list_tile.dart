import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BudgetListTile extends StatelessWidget {
  final Budget budget;

  BudgetListTile(this.budget);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(
            20)), //BorderRadius.vertical(top: Radius.circular(20)),
        child: ListTile(
          tileColor: Colors.grey[850],
          leading: CircleAvatar(child: Icon(Icons.category)),
          title: Text(
            '${budget.title}',
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          ),
          subtitle: Column(
            children: [
              new LinearPercentIndicator(
                width: 280.0,
                lineHeight: 12.0,
                percent: 0.5,
                backgroundColor: Colors.black,
                progressColor: Colors.amber,
              ),
              Text(
                '\$Amount left of \$${budget.amount}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    );
  }
}
