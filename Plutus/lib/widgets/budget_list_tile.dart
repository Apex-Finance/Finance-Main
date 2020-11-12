import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../models/budget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../screens/budget_info_screen.dart';

class BudgetListTile extends StatelessWidget {
  final Budget budget;

  BudgetListTile(this.budget);

  void selectBudget(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return BudgetInfoScreen(
              budget.title, ''); //TODO update to the right maincategory
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(
            20)), //BorderRadius.vertical(top: Radius.circular(20)),
        child: ListTile(
          onTap: () => selectBudget(context),
          tileColor: Colors.grey[850],
          title: AutoSizeText(
            '${budget.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
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
                '\$Amount left of \$${budget.amount}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
