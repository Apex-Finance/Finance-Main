import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';

import '../../widgets/category_list_tile.dart';
import '../../models/category.dart';

class FirstBudgetScreen extends StatefulWidget {
  static const routeName = '/first_budget';

  @override
  _FirstBudgetScreenState createState() => _FirstBudgetScreenState();
}

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //TODO currently, budgetAmount is null (pulling from budget.dart); figure out how to pass data from
    //TODO income.dart to this screen
    final Budget budget = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title:
            Text('First Budget', style: Theme.of(context).textTheme.bodyText1),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          height: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "New Monthly Budget",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Total Budget: \$${budget.amount}',
                    style: TextStyle(color: Colors.amber, fontSize: 15),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: MainCategory.values.length,
                    itemBuilder: (context, index) =>
                        CategoryListTile(MainCategory.values[index]),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
