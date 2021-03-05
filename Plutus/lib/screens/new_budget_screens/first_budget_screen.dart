import 'package:Plutus/models/budget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/category_list_tile.dart';
import '../../models/categories.dart';
import '../../models/budget.dart';
import '../../models/category.dart' as Category;

// Form to budget out monthly income into categories
class FirstBudgetScreen extends StatefulWidget {
  static const routeName = '/first_budget';
  String budgetID;
  FirstBudgetScreen({this.budgetID});
  @override
  _FirstBudgetScreenState createState() => _FirstBudgetScreenState();
}

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  List<FocusNode> catAmountFocusNodes = List<FocusNode>.generate(
      MainCategory.values.length, (index) => FocusNode());
  MainCategory activeCategory = MainCategory.values[0];
  double activeAmount = 0;

  // Sets the category and amount for the current ListTile being built
  void setActiveCategory(MainCategory category, double amount) {
    activeCategory = category;
    activeAmount = amount ?? 0;
    return;
  }

  @override
  Widget build(BuildContext context) {
    var categoryDataProvider =
        Provider.of<Category.CategoryDataProvider>(context);
    var category = Category.Category();
    var categoryList = new List<Category.Category>();
    double categoryExpenses;
    final Budget budget = Budget
        .empty(); // budget contains the amounts; rest are null on first run of build

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
                            '\$${budget.getAmount()}', // .toStringAsFixed(2)
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
                            '\$${budget.getRemainingAmount().toStringAsFixed(2)}',
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
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        snapshot.data.docs.forEach((doc) {
                          categoryList.add(
                              categoryDataProvider.initializeCategory(doc));
                        });
                        if (widget.budgetID != null) {
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(Provider.of<Auth>(context, listen: false)
                                    .getUserId())
                                .collection('budgets')
                                .doc(widget.budgetID)
                                .collection('categories')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data.docs.isNotEmpty) {
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
                                  categoryList[index],
                                  setActiveCategory,
                                  catAmountFocusNodes,
                                  index,
                                ),
                              );
                            },
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) => CategoryListTile(
                              categoryList[index],
                              setActiveCategory,
                              catAmountFocusNodes,
                              index,
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
                        Provider.of<Category.CategoryDataProvider>(context,
                                listen:
                                    false) //TODO ALEX no setcategoryamount() for budget yet
                            .uploadCategory(widget.budgetID, category, context);
                        setState(() {
                          if (budget.getRemainingAmount() < -0.001)
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
                          else if (budget.getRemainingAmount() > 0.001) {
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
