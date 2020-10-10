import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  static const routeName = '/budget';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Budget Screen',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
