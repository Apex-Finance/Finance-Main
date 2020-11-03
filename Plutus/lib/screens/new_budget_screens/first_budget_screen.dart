import 'package:flutter/material.dart';

import '../../widgets/category_list_tile.dart';
import '../../models/category.dart';
import '../../models/budget.dart';

class FirstPage extends StatefulWidget {
  static const routeName = '/first_budget';
  Budget amount;

  FirstPage(this.amount);
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                    'Total Budget: \$0.00',
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
              // Taken from transaction_screen.dart
              // ...MainCategory.values
              //     .map((category) => ListTile(
              //         title: Text(
              //             '${stringToUserString(enumValueToString(category))}'),
              //         onTap: () {
              //           Navigator.of(context).pop(category);
              //         }))
              //     .toList(),

              // remember to pull from transaction_form(); those 4 functions that convert the enum into a
              // string and back to an enum
            ),
          ),
        ),
      ),
    );
  }
}
