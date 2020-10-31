import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class FirstPage extends StatefulWidget {
  static const routeName = '/first_budget';
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final _formKey = GlobalKey<FormState>();
  double number;

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
                  ListTile(
                    tileColor: Colors.grey[850],
                    leading: CircleAvatar(child: Icon(Icons.category)),
                    title: AutoSizeText(
                      'Food and Drinks',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                    trailing: Container(child: TextField()),
                  ),
                  ListTile(
                    tileColor: Colors.grey[850],
                    leading: CircleAvatar(child: Icon(Icons.category)),
                    title: AutoSizeText(
                      'Education',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                    trailing: Text(
                      '\$0.00',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                  ),
                  ListTile(
                    tileColor: Colors.grey[850],
                    leading: CircleAvatar(child: Icon(Icons.category)),
                    title: AutoSizeText(
                      'Home',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
                    ),
                    trailing: Text(
                      '\$0.00',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18),
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

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: widget
                  //         .category // grab category for somewhere
                  //         .length, // how many categories will we have listed?
                  //     itemBuilder: (context, index) =>
                  //         CategoryListTile(widget.category[index]),
                  //     //     //TODO create CategoryListTile widget
                  //   ),
                  // ),
                  // Possibly need to wrap a ListTile() inside a Form() widget
                  // Keep the TextFormField()
                  // remember to pull from transaction_form(); those 4 functions that convert the enum into a
                  // string and back to an enum
                  Row(
                    children: [
                      Text('\$', style: Theme.of(context).textTheme.bodyText1),
                      Expanded(
                        child: TextFormField(
                            style: Theme.of(context).textTheme.bodyText1,
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            initialValue: '0.00',
                            onEditingComplete: () {},
                            onSaved: (val) => number = double.parse(val),
                            validator: (val) {
                              if (val.contains(new RegExp(r'^\d*(\.\d+)?$'))) {
                                // only accept any number of digits followed by 0 or 1 decimals followed by any number of digits
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) <=
                                    0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                                  return 'Please enter an amount greater than 0.';
                                if (double.parse(
                                        double.parse(val).toStringAsFixed(2)) >
                                    999999999.99)
                                  return 'Max amount is \$999,999,999.99'; // no transactions >= $1billion
                                return null;
                              } else {
                                return 'Please enter a number.';
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
