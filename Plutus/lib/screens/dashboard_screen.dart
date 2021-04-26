// Imported Flutter packages
import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
import '../widgets/transaction_list_tile.dart';
import '../models/pie_chart.dart';
import '../widgets/goals_list_tile.dart';
import '../models/transaction.dart';
import '../models/goals.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: [
        Column(
          children: [
            //PieChart(),
            BudgetLinearIndicatorCard(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TotalSpentCard(),
                TotalSavedCard(),
              ],
            ),
            RecentTransactionsCard(3),
            UpcomingGoalCard(2),
          ],
        ),
      ],
    );
  }
}

class BudgetLinearIndicatorCard extends StatelessWidget {
  const BudgetLinearIndicatorCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var budgetDataProvider = Provider.of<BudgetDataProvider>(context);
    var transactionDataProvider = Provider.of<Transactions>(context);
    var budgetAmount = 0.00;
    double transactionExpenses = 0.00;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        width: deviceSize.width * 0.85,
        child: ListTile(
          title: Column(
            children: [
              Text(
                'Total Budget Used',
                style: TextStyle(
                    fontSize: 22, color: Theme.of(context).primaryColor),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: budgetDataProvider.getmonthlyBudget(
                      context, DateTime.now()),
                  builder: (context, budgetSnapshot) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: transactionDataProvider
                          .getMonthlyTransactions(context, DateTime.now())
                          .snapshots(),
                      builder: (context, transactionSnapshot) {
                        if (!budgetSnapshot.hasData ||
                            !transactionSnapshot.hasData) {
                          // loading data... show empty percent indicator to prevent screen shifting
                          return LinearPercentIndicator(
                            width:
                                MediaQuery.of(context).size.width * .75, // 82
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration: 2500,
                            percent: 0,
                            center: Text(''),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Theme.of(context).primaryColor,
                          );
                        } else if (budgetSnapshot.data.docs.isEmpty) {
                          // no budget created yet... don't show LPI
                          return Text(
                            'No budget created yet.',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          );
                        } else {
                          budgetAmount = budgetDataProvider
                              .initializeBudget(budgetSnapshot.data.docs.first)
                              .getAmount();
                          transactionExpenses = transactionDataProvider
                              .getTransactionExpenses(transactionSnapshot.data);

                          return LinearPercentIndicator(
                            width:
                                MediaQuery.of(context).size.width * .75, // 82
                            animation: true,
                            lineHeight: 20.0,
                            animationDuration:
                                1750, // slightly longer than pieChart animationDuration b/c needs a delay to let the pieChart get more data from db
                            // if budget is 0 (somehow) show empty; if expenses > budget, show full; otherwise show correct % spent
                            percent: budgetAmount > 0
                                ? (transactionExpenses > budgetAmount
                                    ? 1
                                    : transactionExpenses / budgetAmount)
                                : 0,
                            center: AutoSizeText(
                              budgetAmount > 0
                                  ? '${(transactionExpenses / budgetAmount * 100).toStringAsFixed(1)}%'
                                  : '',
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Theme.of(context).primaryColor,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalSavedCard extends StatelessWidget {
  const TotalSavedCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var transactionDataProvider = Provider.of<Transactions>(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: 90,
        width: deviceSize.width * 0.4, // 180
        child: Center(
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Total Saved',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: transactionDataProvider.getCategoryTransactions(
                      'GYHEkJeJsFG09HUw14p3',
                      DateTime.now(),
                      context), // gets goal transactions for this month
                  builder: (context, snapshot) {
                    double amountSaved;
                    if (!snapshot.hasData)
                      return Container();
                    else {
                      amountSaved = transactionDataProvider
                          .getTransactionExpenses(snapshot
                              .data); // sums the goal transaction amounts
                      return FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          '\$${amountSaved.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TotalSpentCard extends StatelessWidget {
  const TotalSpentCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    var transactionDataProvider = Provider.of<Transactions>(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(4.0),
        height: 90,
        width: deviceSize.width * 0.4,
        child: Center(
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  'Total Spent',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: transactionDataProvider
                      .getMonthlyTransactions(context, DateTime.now())
                      .snapshots(),
                  builder: (context, tranSnap) {
                    return StreamBuilder<QuerySnapshot>(
                      stream: transactionDataProvider.getCategoryTransactions(
                          'GYHEkJeJsFG09HUw14p3',
                          DateTime.now(),
                          context), // gets goal transactions for this month
                      builder: (context, goalSnap) {
                        if (!goalSnap.hasData ||
                            !tranSnap.hasData) // loading data
                          // don't need to check if snapshots are empty b/c it will just calculate 0 for that if so
                          return Container();
                        else {
                          double amountSaved = transactionDataProvider
                              .getTransactionExpenses(goalSnap
                                  .data); // sums the goal transaction amounts

                          double transactionExpenses = transactionDataProvider
                              .getTransactionExpenses(tranSnap.data);
                          return FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              '\$${(transactionExpenses - amountSaved).toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          );
                        }
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class RecentTransactionsCard extends StatelessWidget {
  final int tileCount;
  RecentTransactionsCard(this.tileCount);
  @override
  Widget build(BuildContext context) {
    var transactionDataProvider = Provider.of<Transactions>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: transactionDataProvider
            .getMonthlyTransactions(context, DateTime.now(), tileCount)
            .snapshots(),
        builder: (context, snapshot) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              ),
            ),
            child: Container(
              width: 400,
              height: 300,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    width: 400,
                    child: Center(
                      child: Text('Recent Transactions',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor)),
                    ),
                  ),
                  if (!snapshot.hasData)
                    //loading data (shouldn't matter b/c below the fold but just in case)
                    Container()
                  else if (snapshot.data.docs.isEmpty)
                    // no transactions this month
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 250),
                            child: Text(
                              'No transactions have been added this month.',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ),
                    )
                  else // load transactions
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // initialize the transaction document into a transaction object
                            return TransactionListTile(
                                transactionDataProvider.initializeTransaction(
                                    snapshot.data.docs[index]));
                          }),
                    ),
                ],
              ),
            ),
          );
        });
  }
}

class UpcomingGoalCard extends StatelessWidget {
  final int tileCount;

  UpcomingGoalCard(this.tileCount);

  @override
  Widget build(BuildContext context) {
    var goalDataProvider =
        Provider.of<GoalDataProvider>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: goalDataProvider.getUpcomingGoals(context, tileCount),
        builder: (context, snapshot) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(20),
              ),
            ),
            child: Container(
              width: 400,
              height: 260,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    width: 400,
                    child: Center(
                      child: Text(
                        'Upcoming Goals',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).canvasColor),
                      ),
                    ),
                  ),
                  if (!snapshot.hasData)
                    //loading data (shouldn't matter b/c below the fold but just in case)
                    Container()
                  else if (snapshot.data.docs.isEmpty)
                    // no goals
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 250),
                            child: Text(
                              'No goals have been created.',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            )),
                      ),
                    )
                  else // load goals
                    Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // initialize the transaction document into a transaction object
                            return GoalsListTile(goalDataProvider
                                .initializeGoal(snapshot.data.docs[index]));
                          }),
                    ),
                ],
              ),
            ),
          );
        });
  }
}
