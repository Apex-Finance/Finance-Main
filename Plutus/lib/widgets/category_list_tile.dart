import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../models/categories.dart';
import '../models/category.dart' as Category;
import '../models/category_icon.dart';
import '../models/budget.dart';

// ignore: must_be_immutable
class CategoryListTile extends StatefulWidget {
  final Category.Category category;
  Function categoryHandler;
  List<FocusNode> focusNode;
  int index;

  CategoryListTile(
    this.category,
    this.categoryHandler,
    this.focusNode,
    this.index,
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
        text: widget.category.getAmount() != null
            ? widget.category.getAmount().toStringAsFixed(2)
            : '');
    return ListTile(
      tileColor: Colors.grey[850],
      // leading: CircleAvatar(child: Icon(IcondData(categoryIcon[widget.category.getCodepoint()]))),
      title: AutoSizeText(
        (widget.category.getTitle()),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      ),
      trailing: Container(
        width: 52,
        child: Row(
          children: [
            Text('\$', style: Theme.of(context).textTheme.bodyText1),
            Expanded(
              child: Focus(
                key: ValueKey(widget.category.getAmount()),
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    if (_controller.text
                        .contains(new RegExp(r'-?[0-9]\d*(\.\d+)?$'))) {
                      if (double.parse(double.parse(_controller.text)
                              .toStringAsFixed(2)) <
                          0.00) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                'Amount must be greater than 0',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        );
                      }
                      widget.category.setAmount(double.parse(_controller.text));
                    } // validates for numbers < 0
                    else if (_controller.text.isNotEmpty) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Please enter a number',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      );
                      _controller.text = '';
                    } // valides for text that is copy/pasted in
                    // TODO find a way to make this less redundant
                    else if (_controller.text.isEmpty) {
                      _controller.text = '0.00';
                      widget.category.setAmount(double.parse(_controller.text));
                    } // if amount is cleared, set to 0 so that remainingBudget can update
                  }
                },
                child: TextFormField(
                  focusNode: widget.focusNode[widget.index],
                  onFieldSubmitted: (value) {
                    //widget.focusNode[widget.index].unfocus();
                    if (widget.index < MainCategory.values.length) {
                      widget.focusNode[widget.index + 1].requestFocus();
                    }
                  }, // go to next textfield
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.amber.withOpacity(0.6)),
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  onChanged: (_) => widget.categoryHandler(
                      widget.category, double.tryParse(_controller.text)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
