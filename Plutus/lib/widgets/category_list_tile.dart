import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../models/categories.dart';
import '../models/category_icon.dart';
import '../models/budget.dart';

// ignore: must_be_immutable
class CategoryListTile extends StatefulWidget {
  MainCategory category;

  CategoryListTile(
    this.category,
  );

  @override
  _CategoryListTileState createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  @override
  Widget build(BuildContext context) {
    Budgets budgets = Provider.of<Budgets>(
        context); // contains the amount; each change to a category's amount will update Provider (and then remaining amount)
    final _controller = TextEditingController(
        text: budgets.monthlyBudget.categoryAmount[widget.category] != null
            ? budgets.monthlyBudget.categoryAmount[widget.category]
                .toStringAsFixed(2)
            : '0.00');
    return ListTile(
      tileColor: Colors.grey[850],
      leading: CircleAvatar(child: Icon(categoryIcon[widget.category])),
      title: AutoSizeText(
        stringToUserString(enumValueToString(widget.category)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      ),
      trailing: Container(
        width: 52,
        child: Row(
          children: [
            // This somehow has to change to red if it's wrong
            Text('\$', style: Theme.of(context).textTheme.bodyText1),
            Expanded(
              child: Focus(
                key: ValueKey(widget.category),
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    // TODO have error text for individual fields ? or at least change underline to red
                    // if just lost focus, update remaining amount (workaround for tapping out of field instead of hitting next)
                    if (_controller.text ==
                        '') // if field left empty, set it to 0.00
                      _controller.text =
                          '0.00'; // Only works sometimes; is random ¯\_(ツ)_/¯
                    if (_controller.text
                        .contains(new RegExp(r'-?[0-9]\d*(\.\d+)?$'))) {
                      if (double.parse(double.parse(_controller.text)
                              .toStringAsFixed(2)) <
                          0.00) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text('Amount must be greater than 0'),
                            ),
                          ),
                        );
                      }
                      budgets.setCategoryAmount(
                          widget.category, double.parse(_controller.text));
                    }
                  } else if (_controller.text == '0.00') _controller.text = '';
                },
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  onFieldSubmitted: (val) {
                    //TODO GO TO NEXT FIELD
                    // need to outsource function to Provider to notifyListeners
                  },
                  onEditingComplete: () {
                    FocusScope.of(context)
                        .nextFocus(); //TODO NOT WORKING--NEED A LIST OF FOCUSNODES PASSED IN...
                  },

                  // TESTING RN
                  onSaved: (val) =>
                      _controller.text = double.parse(val) as String,
                  validator: (val) {
                    if (double.parse(double.parse(val).toStringAsFixed(2)) <
                        0.00) //seems inefficient but take string price, convert to double so can convert to string and round, convert to double for comparison--prevents transactions of .00499999... or less which would show up as 0.00
                      return 'hi';
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
