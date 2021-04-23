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
  final bool isNewBudget;
  final bool init;
  final double originalAmount;
  final List<Category>
      uneditedBudget; // receive the uneditedBudget (starts out as empty List on first time to FBS, then as the originalBudget)
  FirstBudgetScreen(
      {this.budget,
      this.isNewBudget,
      this.uneditedBudget,
      this.init,
      this.originalAmount});

  @override
  _FirstBudgetScreenState createState() => _FirstBudgetScreenState();
}

List<Category> categoryList = [];
List<FocusNode> catAmountFocusNodes = [];

class _FirstBudgetScreenState extends State<FirstBudgetScreen> {
  double activeAmount = 0;
  Category activeCategory = Category();
  List<Category> originalList = [];
  bool init = true;
  bool fbsInit = true;

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
    if (mounted)
      setState(() {
        widget.budget.categoryAmount = amount;
      });
    else
      widget.budget.categoryAmount = amount;

    // on the very first time FBS is reached, set the remainingAmount to be the difference b/w the previous remainingAmount and whatever they changed it to this time
    // will not be called if the user goes back to IS and then again to FBS
    // this assumes that the budget was created appropriately the first time (i.e., no anomaly took place like quitting the app); otherwise remainingAmount will be wrong initially but correct itself
    if (widget.init && fbsInit) {
      // note: init and widget.init are different values for different things
      widget.budget.setRemainingAmountNew(
          widget.budget.getAmount() - widget.originalAmount);
      fbsInit =
          false; // make sure remaining amount is calculated normally while on FBS
      // used new variable because setting widget.init to false causes a warning
    } else if (mounted)
      // every time except the first time FBS is reached, do normal calculations to get remainingAmount
      // cannot be done every time since setstate cannot be called this early and/or categoryList is not fully updated
      setState(() {
        widget.budget.calculateRemainingAmountNew();
      });
    else
      widget.budget.calculateRemainingAmountNew();

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

    // if they hit back button on phone or appbar, pass the originalList back
    // will be assigned to uneditedBudget in IS
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(originalList);
        return true;
      },
      child: Scaffold(
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
                      color: Theme.of(context).primaryColor,
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
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
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
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 15),
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
                                tempList.add(categoryDataProvider
                                    .initializeCategory(doc));
                              });
                              categoryList = tempList;
                              // This is needed since the length of the focus nodes is changing in the loop
                              var tempCount = categoryList.length -
                                  catAmountFocusNodes.length;
                              // Append focus nodes rather than create entire new list to keep from having multiple focuses
                              if (categoryList.length !=
                                  catAmountFocusNodes.length) {
                                for (var index = 0;
                                    index < tempCount;
                                    index++) {
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
                                                if (doc.id ==
                                                    category.getID()) {
                                                  var amount =
                                                      doc.data()['amount'] !=
                                                              null
                                                          ? doc.data()['amount']
                                                          : 0;
                                                  category.setAmount(amount);
                                                }
                                              });
                                            });
                                            // if this is the first time they visited the FBS, run this once
                                            if (widget.uneditedBudget != null) {
                                              // need this check for adding new budget
                                              if (widget
                                                      .uneditedBudget.isEmpty &&
                                                  init) {
                                                //init is needed or this branch is executed twice

                                                //do a deep copy of each attribute of category, but only on first initialization
                                                categoryList
                                                    .forEach((category) {
                                                  originalList.add(
                                                      Category.deepCopy(
                                                          category));
                                                });
                                                init = false;
                                              } else if (widget.uneditedBudget
                                                  .isNotEmpty) // on revisit of FBS, reset the original list to the uneditedBudget
                                                //which was originally set to the original list...
                                                originalList =
                                                    widget.uneditedBudget;
                                            }
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
                          if (widget.budget.getRemainingAmountNew() < -0.001)
                            ScaffoldMessenger.of(context).showSnackBar(
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
                            ScaffoldMessenger.of(context).showSnackBar(
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
                        label: widget.isNewBudget
                            ? AutoSizeText('Add Budget')
                            : AutoSizeText('Edit Budget'),
                      ),
                    ),
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
