import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Plutus/models/charts.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Expanded(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: GroupedBarChart.withSampleData(),
              ),
            ),
            Divider(
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(Provider.of<Auth>(context, listen: false)
                            .getUserId())
                        .collection('budgets')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                        return Text("No Data Available");
                      }

                      // Budget data for a user
                      List<QueryDocumentSnapshot> budgets = snapshot.data.docs;

                      // Data for the chart to use.
                      List<charts.Series<TimeChartData, DateTime>> chartData =
                          List<charts.Series<TimeChartData, DateTime>>();

                      // Format the budget data for the chart
                      List<TimeChartData> budgetsGiven = List<TimeChartData>();
                      for (QueryDocumentSnapshot budget in budgets) {
                        budgetsGiven.add(TimeChartData(
                            DateTime.parse(budget["title"]),
                            budget["amount"].round()));
                      }

                      // Add the budget data with line formatting
                      chartData.add(
                        charts.Series<TimeChartData, DateTime>(
                          id: 'Budget',
                          colorFn: (_, __) =>
                              charts.ColorUtil.fromDartColor(Colors.blueAccent),
                          domainFn: (TimeChartData x, _) => x.date,
                          measureFn: (TimeChartData x, _) => x.value,
                          data: budgetsGiven,
                        ),
                      );

                      // return NormalTimeChart.withSampleData();
                      return StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(Provider.of<Auth>(context, listen: false)
                                  .getUserId())
                              .collection('Transactions')
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Transaction data for a user
                            List<QueryDocumentSnapshot> transactions =
                                snapshot.data.docs;

                            Map<String, TimeChartData> totalTrans =
                                Map<String, TimeChartData>();

                            // Pre-populate the dict so that months without trans are shown on the chart
                            for (TimeChartData budget in budgetsGiven) {
                              totalTrans[
                                  DateFormat("LLLL")
                                      .format(budget.date)] = TimeChartData(
                                  DateTime(budget.date.year, budget.date.month),
                                  0);
                              ;
                            }

                            for (QueryDocumentSnapshot tran in transactions) {
                              DateTime date = tran["date"].toDate();
                              String key = DateFormat("LLLL").format(date);

                              // Add the item to the map if it doesn't exist
                              if (!totalTrans.containsKey(key)) {
                                // Give a date of the first of the month
                                totalTrans[key] = TimeChartData(
                                    DateTime(date.year, date.month), 0);
                              }

                              // Update the amount for that month
                              totalTrans[key].value += tran["amount"].toInt();
                            }

                            // Add the transaction data with line formatting
                            chartData.add(
                              charts.Series<TimeChartData, DateTime>(
                                id: 'Transaction',
                                colorFn: (_, __) =>
                                    charts.ColorUtil.fromDartColor(
                                        Colors.yellowAccent),
                                domainFn: (TimeChartData x, _) => x.date,
                                measureFn: (TimeChartData x, _) => x.value,
                                data: totalTrans.values.toList(),
                              ),
                            );

                            return NormalTimeChart(chartData, animate: false);
                          });
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// child: Text(
//   'Dashboard Screen',
//   style: Theme.of(context).textTheme.bodyText1,
// ),
