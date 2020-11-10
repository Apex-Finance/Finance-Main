import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../models/categories.dart';
import '../models/budget.dart';

// ignore: must_be_immutable
class CategoryListTile extends StatefulWidget {
  MainCategory category;
  Map<MainCategory, double> categoryAmount;

  CategoryListTile(this.category, this.categoryAmount);

  @override
  _CategoryListTileState createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  final _formKey = GlobalKey<FormState>();

  // Saves the current inputed category amount
  void setCategoryAmount() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Navigator.of(context)
      //     .pushNamed(FirstBudgetScreen.routeName, arguments: categoryAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[850],
      leading: CircleAvatar(child: Icon(Icons.category)),
      title: AutoSizeText(
        stringToUserString(enumValueToString(widget.category)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
      ),
      trailing: Container(
        width: 50,
        child: Row(
          children: [
            Text('\$', style: Theme.of(context).textTheme.bodyText1),
            Expanded(
              child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  // autofocus: true, (probably not needed)
                  keyboardType: TextInputType.number,
                  initialValue: '0.00',
                  // TODO May have to call setState here to change values
                  // Also allow the user to edit the textfield as much as he wants
                  onEditingComplete: () {
                    setCategoryAmount();
                  },
                  onSaved: (val) {
                    widget.categoryAmount[widget.category] = double.parse(val);
                    print(Provider.of<Budget>(context)
                        .categoryAmount[widget.category]);
                  },
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