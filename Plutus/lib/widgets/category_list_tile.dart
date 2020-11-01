import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/category.dart';

class CategoryListTile extends StatelessWidget {
  MainCategory category;

  CategoryListTile(this.category);

  double number = 0; // Amount the user inputs for that category; PLS change
  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.all(10),
      width: 50,
      child: ListTile(
        tileColor: Colors.grey[850],
        leading: CircleAvatar(child: Icon(Icons.category)),
        title: AutoSizeText(
          'Food and Drinks', // this is where you would implement the category name
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
        ),
        trailing: Row(
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
                      if (double.parse(double.parse(val).toStringAsFixed(2)) <=
                          0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                        return 'Please enter an amount greater than 0.';
                      if (double.parse(double.parse(val).toStringAsFixed(2)) >
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
      ),
    );
  }
}
