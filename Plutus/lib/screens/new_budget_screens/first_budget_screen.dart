import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

import '../../widgets/category_list_tile.dart';
import '../../models/category.dart';

class FirstPage extends StatefulWidget {
  static const routeName = '/first_budget';
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
        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
        child: KeyboardAvoider(
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
                  SizedBox(
                    height: 50,
                  ),
                  //TODO Implement categories instead of hardcoding in category names
                  //TODO Create a CategoryListTile
                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 5, // # of main categories; change later
                      itemBuilder: (context, index) =>
                          CategoryListTile(MainCategory.values[index]),
                    ),
                  ),

                  // Taken from transaction_screen.dart
                  // ...MainCategory.values
                  //     .map((category) => ListTile(
                  //         title: Text(
                  //             '${stringToUserString(enumValueToString(category))}'),
                  //         onTap: () {
                  //           Navigator.of(context).pop(category);
                  //         }))
                  //     .toList(),
                  //TODO look into this method of making a ListTile
                  //     //     //TODO create CategoryListTile widget

                  // remember to pull from transaction_form(); those 4 functions that convert the enum into a
                  // string and back to an enum
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
