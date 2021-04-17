// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
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

List<Category> categoryList = [];
List<FocusNode> catAmountFocusNodes = [];

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  double activeAmount = 0;
  Category activeCategory = Category();

  void setActiveCategory(Category category, double amount) {
    activeCategory = category;
    activeAmount = amount ?? 0;
    return;
  }

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

  // Updates Remaining Amount to current value; useful when editing
  @override
  void initState() {
    super.initState();
    widget.budget.categoryAmount = 0;
    calculateAmountLeft(0); // index doesn't matter
  }

  @override
  Widget build(BuildContext context) {
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText('First Budget',
            style: Theme.of(context).textTheme.bodyText1),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Container(
          child: Form(
            child: Column(
              children: [
                // Title
                AutoSizeText(
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
                          AutoSizeText(
                            'Total Budget:',
                            style: TextStyle(color: Colors.amber, fontSize: 15),
                          ),
                          AutoSizeText(
                            '\$${widget.budget.getAmount().toStringAsFixed(2)}',
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
                          AutoSizeText(
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
                    stream: categoryDataProvider.streamCategories(context),
                    builder: (context, budgetSnapshot) {
                      switch (budgetSnapshot.connectionState) {
                        case ConnectionState.none:
                          {
                            return AutoSizeText('An issue arose.');
                          }
                        default:
                          {
                            var tempList = <Category>[];
                            budgetSnapshot.data.docs.forEach((doc) {
                              tempList.add(
                                  categoryDataProvider.initializeCategory(doc));
                            });
                            categoryList = tempList;
                            // This is needed since the length of the focus nodes is changing in the loop
                            var tempCount = categoryList.length -
                                catAmountFocusNodes.length;
                            // Append focus nodes rather than create entire new list to keep from having multiple focuses
                            if (categoryList.length !=
                                catAmountFocusNodes.length) {
                              for (var index = 0; index < tempCount; index++) {
                                print(categoryList.length -
                                    catAmountFocusNodes.length);
                                catAmountFocusNodes.add(FocusNode());
                              }
                            }
                            if (widget.budget.getID() != null) {
                              return StreamBuilder<QuerySnapshot>(
                                stream: BudgetDataProvider()
                                    .getBudgetCategories(
                                        context, widget.budget.getID()),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                      {
                                        return AutoSizeText(
                                            'There was an issue loading the categories.');
                                      }
                                    default:
                                      {
                                        if (snapshot.hasData &&
                                            snapshot.data.docs.isNotEmpty) {
                                          snapshot.data.docs.forEach((doc) {
                                            categoryList.forEach((category) {
                                              if (doc.id == category.getID()) {
                                                var amount =
                                                    doc.data()['amount'] != null
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
                                            setActiveCategory,
                                          ),
                                        );
                                      }
                                  }
                                },
                              );
                            } else {
                              print('else');
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
                                  setActiveCategory,
                                ),
                              );
                            }
                          }
                      }
                    },
                  ),
                ),
                // Add budget button
                Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 50),
                  alignment: Alignment.bottomRight,
                  child: Builder(
                    builder: (context) => FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        await categoryDataProvider.setCategoryAmount(
                            widget.budget.getID(),
                            activeCategory,
                            activeAmount,
                            context);
                        calculateAmountLeft(0);
                        setState(
                          () {
                            if (widget.budget.getRemainingAmountNew() < -0.001)
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: AutoSizeText(
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
                                    child: AutoSizeText(
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
                      label: widget.budget.getID() != null
                          ? AutoSizeText('Edit Budget')
                          : AutoSizeText('Add Budget'),
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
