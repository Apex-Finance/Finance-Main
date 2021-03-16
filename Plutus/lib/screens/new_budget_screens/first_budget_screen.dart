import 'package:Plutus/models/budget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/category_list_tile.dart';
import '../../models/budget.dart';
import '../../models/category.dart';

// Form to budget out monthly income into categories
class FirstBudgetScreen extends StatefulWidget {
  static const routeName = '/first_budget';
  final Budget budget;
  FirstBudgetScreen({this.budget});
  @override
  _FirstBudgetScreenState createState() => _FirstBudgetScreenState();
}

var categoryList = new List<Category>();
List<FocusNode> catAmountFocusNodes = List<FocusNode>();

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  double activeAmount = 0;

  // Sets the category and amount for the current ListTile being built
  void calculateAmountLeft(int index) {
    double amount = 0.00;
    categoryList.forEach((category) {
      amount += category.getAmount();
    });
    setState(() {
      widget.budget.categoryAmount = amount;
    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);
    var category = Category();

    // final Budget budget = Budget
    //     .empty(); // budget contains the amounts; rest are null on first run of build

    return Scaffold(
      appBar: AppBar(
        title:
            Text('First Budget', style: Theme.of(context).textTheme.bodyText1),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          child: Form(
            child: Column(
              children: [
                // Title
                Text(
                  "New Monthly Budget",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: 30,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total budget
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Budget:',
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                          ),
                          AutoSizeText(
                            '\$${widget.budget.getAmount()}', // .toStringAsFixed(2)
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      // Remaining budget
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remaining Budget:',
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                          ),
                          AutoSizeText(
                            '\$${widget.budget.getRemainingAmountNew().toStringAsFixed(2)}',
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Scrollable category list with text fields
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: categoryDataProvider.getCategories(context),
                      builder: (context, snapshot) {
                        var tempList = List<Category>();
                        snapshot.data.docs.forEach((doc) {
                          tempList.add(
                              categoryDataProvider.initializeCategory(doc));
                        });
                        categoryList = tempList;
                        catAmountFocusNodes = List<FocusNode>.generate(
                            categoryList.length, (index) => FocusNode());
                        if (widget.budget.getID() != null) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: BudgetDataProvider().getBudgetCategories(
                                context, widget.budget.getID()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data.docs.isNotEmpty) {
                                snapshot.data.docs.forEach((doc) {
                                  categoryList.forEach((category) {
                                    if (doc.id == category.getID()) {
                                      var amount = doc.data()['amount'] != null
                                          ? doc.data()['amount']
                                          : 0;
                                      category.setAmount(amount);
                                    }
                                  });
                                });
                              }
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: categoryList.length,
                                itemBuilder: (context, index) =>
                                    CategoryListTile(
                                  categoryList,
                                  calculateAmountLeft,
                                  catAmountFocusNodes,
                                  index,
                                  widget.budget,
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) => CategoryListTile(
                              categoryList,
                              calculateAmountLeft,
                              catAmountFocusNodes,
                              index,
                              widget.budget,
                            ),
                          );
                        }
                      }),
                ),
                // Add budget button
                Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 50),
                  alignment: Alignment.bottomRight,
                  child: Builder(
                    builder: (context) => FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        Provider.of<CategoryDataProvider>(context,
                                listen:
                                    false) //TODO ALEX no setcategoryamount() for budget yet
                            .uploadCategory(
                                widget.budget.getID(), category, context);
                        setState(
                          () {
                            if (widget.budget.getRemainingAmountNew() < -0.001)
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      'You have budgeted more money than is available this month.',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              );
                            else if (widget.budget.getRemainingAmountNew() >
                                0.001) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      'You have some money that still needs to be budgeted.',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ),
                              );
                              // removes all screens besides tab (useful after intro or just normal budget creation)
                            } else {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/tab', (Route<dynamic> route) => false);
                            }
                          },
                        );
                      },
                      label: Text('Add Budget'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
