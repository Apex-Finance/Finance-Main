// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/budget.dart';
import '../models/month_changer.dart';
import '../widgets/budget_list_tile.dart';
import '../providers/auth.dart';

class BudgetScreen extends StatefulWidget {
  static const routeName = '/budget';

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  void _enterBudget(BuildContext context, Budget budget) {
    Navigator.of(context).pushReplacementNamed('/income', arguments: budget);
    // replacement stops the function on budget screen from running in the background to see if the budget was made properly
    // works properly now and won't throw error if adding a budget
  }

  @override
  Widget build(BuildContext context) {
    final budgetDataProvider = Provider.of<BudgetDataProvider>(context);
    var monthData = Provider.of<MonthChanger>(context);
    var transactionDataProvider =
        Provider.of<Transactions>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
        stream: budgetDataProvider.getmonthlyBudget(
            context, DateTime(monthData.selectedYear, monthData.selectedMonth)),
        builder: (context, budgetSnapshot) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Container(
                  width: 250,
                  child: monthData.buildMonthChanger(context),
                ),
              ),
              Expanded(
                child:
                    // removed this part of the condition fixed the screen from showing "no budget..." for a split second before showing budget
                    // !budgetSnapshot.hasData ||
                    budgetSnapshot.data.docs.isEmpty
                        ? NoBudgetYetText(_enterBudget)
                        : BudgetCard(
                            budgetDataProvider: budgetDataProvider,
                            budgetSnapshot: budgetSnapshot,
                            transactionDataProvider: transactionDataProvider,
                            monthData: monthData,
                            enterBudgetHandler: _enterBudget),
              ),
            ],
          );
        });
  }
}

class BudgetCard extends StatelessWidget {
  const BudgetCard({
    Key key,
    @required this.budgetDataProvider,
    @required this.budgetSnapshot,
    @required this.transactionDataProvider,
    @required this.monthData,
    @required this.enterBudgetHandler,
  }) : super(key: key);

  final BudgetDataProvider budgetDataProvider;
  final AsyncSnapshot<QuerySnapshot> budgetSnapshot;
  final Transactions transactionDataProvider;
  final MonthChanger monthData;
  final enterBudgetHandler;

  double _getRemainingAmountPerDay(
      MonthChanger monthData, double remainingAmount) {
    var daysInMonth = monthData.selectedMonth == 12
        ? DateTime(monthData.selectedYear + 1, monthData.selectedMonth + 1, 0)
        : DateTime(monthData.selectedYear, monthData.selectedMonth + 1, 0);

    int daysLeft;
    double remainingAmountPerDay;
    if (monthData.selectedMonth == DateTime.now().month &&
        monthData.selectedYear == DateTime.now().year) {
      //current month (currently spending)
      daysLeft = daysInMonth.day - DateTime.now().day + 1;
      remainingAmountPerDay = remainingAmount / daysLeft;
    } else if (monthData.selectedYear > DateTime.now().year ||
        (monthData.selectedMonth > DateTime.now().month &&
            monthData.selectedYear == DateTime.now().year)) {
      // in future (full month left)
      daysLeft = daysInMonth.day;
      remainingAmountPerDay = remainingAmount / daysLeft;
    } else {
      // in past (can't spend)
      daysLeft = 0;
      remainingAmountPerDay = 0;
    }
    if (remainingAmountPerDay < 0) remainingAmountPerDay = 0;

    return remainingAmountPerDay;
  }

  @override
  Widget build(BuildContext context) {
    var budget =
        budgetDataProvider.initializeBudget(budgetSnapshot.data.docs.first);

    // Get the transactions for the budget
    var budgetTransactions = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .where(
          'date',
          isGreaterThanOrEqualTo: DateTime(
            budget.getDate().year,
            budget.getDate().month,
            1,
          ),
          isLessThan: DateTime(
            budget.getDate().year,
            budget.getDate().month + 1,
            1,
          ),
        );
    // Get the categories selected by the user for this budget
    var budgetCategories =
        BudgetDataProvider().getBudgetCategories(context, budget.getID());

    double budgetedCategoriesAmount =
        0.0; // gets the amount the user actually budgeted into all his categories

    // if budget was not made/edited properly, make the user fix it
    // NOTE: remainingAmount will initially be wrong (minor bug)
    FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budget.getID())
        .collection('categories')
        .get()
        .then((budgetCategories) => budgetCategories.docs.forEach((doc) {
              budgetedCategoriesAmount += doc.data()['amount'];
            }))
        .then((_) {
      if (budget.getAmount() != budgetedCategoriesAmount) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text('Uh oh.'),
              content: Text('There was an issue making your budget.'),
              actions: [
                TextButton(
                    onPressed: () {
                      enterBudgetHandler(context, budget);
                    },
                    child: Text('Fix Budget',
                        style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
          ),
        );
      }
    });
    // TODO: Alex, please check below code; specifically add error handling if mine is insufficient (like if db doesn't respond) and check that my async/await and .then() are all used properly and nothing will break if db is slow (this was an issue when programming it, I think I got it now though); additionally check for efficiency of db calls
    // Gets unbudgeted categories where transactions were made

    List<String> categoryIds = [];
    List<String> unbudgetedCategoriesIdsWithoutTransactions = [];

    // Gets budgeted categories and adds those to a list
    FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budget.getID())
        .collection('categories')
        .get()
        .then((catSnapshot) {
      //.then is necessary to make sure db completes before moving on, otherwise budget gets messed up
      if (catSnapshot.docs.isNotEmpty) {
        catSnapshot.docs.forEach((doc) {
          categoryIds.add(doc
              .id); //categoryIds will hold all categories currently in budget (only budgeted ones on first run; both budgeted, and those added to the budget because transactions were made, on future runs)

          if (doc.data()['amount'] ==
              0.00) //gets categories that were unbudgeted but transactions were made
            unbudgetedCategoriesIdsWithoutTransactions.add(doc.id);
        });
      }
    }).then((catSnap) {
      // gets transactions made for that month and adds those categories if they were unbudgeted for
      budgetTransactions.get().then((transSnapshot) {
        if (transSnapshot.docs.isNotEmpty) {
          transSnapshot.docs.forEach((doc) async {
            if (!categoryIds.contains(doc.data()['categoryID'])) {
              // if a transaction is found whose category is not budgeted for, add that category to the budget
              // initialize category with relevant data from transaction
              var category = Category();
              category.setID(doc.data()['categoryID']);
              category.setTitle(doc.data()['categoryTitle']);
              category.setCodepoint(doc.data()['categoryCodepoint']);
              category.setAmount(0.00); // 0 because unbudgeted

              await Provider.of<CategoryDataProvider>(context, listen: false)
                  .uploadCategory(budget.getID(), category, context);

              categoryIds.add(doc.data()['categoryID']);
            }
            // else will remove categories that were unbudgeted, a transaction was made in that category,
            // thus it becomes part of the budget with 0.00 amount, but then that transaction(s) was deleted
            else {
              // transaction's category is in categoryIds
              if (unbudgetedCategoriesIdsWithoutTransactions.contains(doc
                      .data()[
                  'categoryID'])) // if a budget category has 0.00 amount, but there is a transaction with that category, remove it
                unbudgetedCategoriesIdsWithoutTransactions
                    .remove(doc.data()['categoryID']);
            }
          });
          // unbudgetedCat... only contains categories where amount is 0 and no transactions were made for it; remove those from budget
          unbudgetedCategoriesIdsWithoutTransactions.forEach((catID) async {
            await Provider.of<CategoryDataProvider>(context, listen: false)
                .removeCategory(budget.getID(), catID, context);
          });
        }
      });
    });

    return Container(
      margin: EdgeInsets.only(top: 25),
      child: StreamBuilder<QuerySnapshot>(
        stream: budgetTransactions.snapshots(),
        builder: (context, transactionSnapshots) {
          // commenting this out fixed the screen shifting when month changed from month with a budget to month without a budget and vice versa
          // relies on error widget in main to catch
          // if (!transactionSnapshots.hasData) {
          //   return new Container(width: 0.0, height: 0.0);
          // }

          var transactionExpenses = transactionDataProvider
              .getTransactionExpenses(transactionSnapshots.data);
          budget.calculateRemainingAmount(transactionExpenses);
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            )),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: ListTile(
                      onTap: () => enterBudgetHandler(context, budget),
                      tileColor: Theme.of(context).backgroundColor,
                      title: Column(
                        children: [
                          Text(
                            'Total Budget',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Remaining',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                  AutoSizeText(
                                    '\$${budget.getAmount() < transactionExpenses ? 0.00.toStringAsFixed(2) : budget.getRemainingAmount().toStringAsFixed(2)}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Available per day',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                  AutoSizeText(
                                    '\$${_getRemainingAmountPerDay(monthData, budget.getRemainingAmount()).toStringAsFixed(2)}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new LinearPercentIndicator(
                                alignment: MainAxisAlignment.center,
                                width: MediaQuery.of(context).size.width * .8,
                                lineHeight: 14.0,
                                percent: transactionExpenses >
                                        budget.getAmount()
                                    ? 1
                                    : transactionExpenses / budget.getAmount(),
                                progressColor: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                '\$${transactionExpenses.toStringAsFixed(2)} of \$${budget.getAmount().toStringAsFixed(2)}',
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Divider(height: 10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: budgetCategories,
                      builder: (context, categorySnapshot) {
                        if (categorySnapshot.hasData &&
                            categorySnapshot.data.docs.isNotEmpty) {
                          return ListView.builder(
                              itemCount: categorySnapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return BudgetListTile(
                                  Provider.of<CategoryDataProvider>(context,
                                          listen: false)
                                      .initializeCategory(
                                          categorySnapshot.data.docs[index]),
                                  budgetTransactions,
                                  ValueKey({
                                    'monthData.selectedMonth': index
                                  }), // gives a unique key to each category; necessary to stop open listtiles from one month make another month's open
                                );
                              });
                        } else {
                          if (!categorySnapshot.hasData) {
                            return Container();
                          } else {
                            return Container(
                              margin: EdgeInsets.all(16),
                              child: Text(
                                  'There are no categories selected for this budget.',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 18)),
                            );
                          }
                        }
                      }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NoBudgetYetText extends StatelessWidget {
  final enterBudgetHandler;
  NoBudgetYetText(this.enterBudgetHandler);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250),
          child: Column(
            children: [
              Text(
                'No budget has been added this month.',
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                child: Text(
                  'Add Budget',
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                onPressed: () =>
                    enterBudgetHandler(context, new Budget.empty()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
