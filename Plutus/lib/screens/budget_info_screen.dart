import 'package:flutter/material.dart';

class BudgetInfoScreen extends StatelessWidget {
  final String budgetTitle;
  final String budgetCategory;

  BudgetInfoScreen(this.budgetTitle, this.budgetCategory);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(budgetTitle),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(
                  20)), //BorderRadius.vertical(top: Radius.circular(20)),
              child: ListTile(
                tileColor: Colors.grey[850],
                title: Column(
                  children: [
                    Text(
                      'budget summary',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                    Row(
                      children: [
                        Text(
                          '$budgetTitle',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18),
                        ),
                        //SizedBox(height: 150)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(
                  20)), //BorderRadius.vertical(top: Radius.circular(20)),
              child: ListTile(
                tileColor: Colors.grey[850],
                title: Text(
                  'list of transactions',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
