import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../models/category.dart';
import '../models/budget.dart';

// ignore: must_be_immutable
class CategoryListTile extends StatefulWidget {
  List<Category> categoryList;
  Function categoryHandler;
  List<FocusNode> focusNode;
  int index;
  Budget budget;
  Function activeCategoryHandler;

  CategoryListTile(this.categoryList, this.categoryHandler, this.focusNode,
      this.index, this.budget, this.activeCategoryHandler);

  @override
  _CategoryListTileState createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<CategoryListTile> {
  TextEditingController _controller;

  // only initialize controller once (after previous snapshots resolve);
  // initializing in build will mess up focusnodes
  @override
  void initState() {
    _controller = TextEditingController(
        text: widget.categoryList[widget.index].getAmount() != null
            ? widget.categoryList[widget.index].getAmount().toStringAsFixed(2)
            : '');
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.grey[850],
      // leading: CircleAvatar(child: Icon(IcondData(categoryIcon[widget.category.getCodepoint()]))),
      title: AutoSizeText(
        widget.categoryList[widget.index].getTitle(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
      ),
      trailing: Container(
        width: 80,
        child: Row(
          children: [
            Text('\$', style: Theme.of(context).textTheme.bodyText1),
            Expanded(
              child: Focus(
                key: ValueKey(widget.categoryList[widget.index].getAmount()),
                onFocusChange: (hasFocus) async {
                  if (!hasFocus) {
                    if (_controller.text
                        .contains(new RegExp(r'-?[0-9]\d*(\.\d*)?$'))) {
                      if (double.parse(double.parse(_controller.text)
                              .toStringAsFixed(2)) <
                          0.00) {
                        ScaffoldMessenger.of(context).showSnackBar(
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
                      widget.categoryList[widget.index]
                          .setAmount(double.parse(_controller.text));
                      if (widget.categoryList[widget.index].getAmount() >
                          0.00) {
                        await Provider.of<CategoryDataProvider>(context,
                                listen: false)
                            .uploadCategory(widget.budget.getID(),
                                widget.categoryList[widget.index], context);
                      } else if (widget.categoryList[widget.index]
                              .getAmount() ==
                          0.00) {
                        await Provider.of<CategoryDataProvider>(context,
                                listen: false)
                            .removeCategory(
                          widget.budget.getID(),
                          widget.categoryList[widget.index].getID(),
                          context,
                        );
                      }
                      widget.categoryHandler(widget.index);
                      // make the number they entered, have 2 decimals
                      _controller.text =
                          double.parse(_controller.text).toStringAsFixed(2);
                    } // validates for numbers < 0
                    else if (_controller.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Please enter a valid number',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      );
                      _controller.text = '';
                    } // valides for text that is copy/pasted in
                    // or for a category amount that was deleted, set it to 0, and update remainingAmount
                    else if (_controller.text.isEmpty) {
                      _controller.text = '0.00';
                      widget.categoryList[widget.index]
                          .setAmount(double.parse(_controller.text));
                      if (widget.categoryList[widget.index].getAmount() ==
                          0.00) {
                        await Provider.of<CategoryDataProvider>(context,
                                listen: false)
                            .removeCategory(
                          widget.budget.getID(),
                          widget.categoryList[widget.index].getID(),
                          context,
                        );
                      }
                      widget.categoryHandler(widget.index);
                    } // if amount is cleared, set to 0 so that remainingBudget can update
                  } else {
                    // gaining focus
                    if (_controller.text == '0.00') {
                      _controller.text = '';
                    }
                  }
                },
                child: TextFormField(
                  focusNode: widget.focusNode[widget.index],
                  onFieldSubmitted: (value) {
                    //widget.focusNode[widget.index].unfocus();
                    if (widget.index < widget.categoryList.length) {
                      widget.focusNode[widget.index].unfocus();
                      FocusScope.of(context)
                          .requestFocus(widget.focusNode[widget.index + 1]);
                      // widget.focusNode[widget.index + 1].requestFocus();
                    }
                  }, // go to next textfield
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                        color: Theme.of(context).primaryColor.withOpacity(0.6)),
                  ),
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  controller: _controller,
                  onChanged: (_) => {
                    widget.activeCategoryHandler(
                        widget.categoryList[widget.index],
                        double.tryParse(_controller.text)),
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
