import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Plutus/models/charts.dart';

import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
                      List<QueryDocumentSnapshot> data = snapshot.data.docs;
                      List<TimeSeriesSales> budgetGiven =
                          List<TimeSeriesSales>();
                      List<charts.Series<TimeSeriesSales, DateTime>> chartData =
                          List<charts.Series<TimeSeriesSales, DateTime>>();
                      for (QueryDocumentSnapshot doc in data) {
                        budgetGiven.add(TimeSeriesSales(
                            DateTime.parse(doc["title"]),
                            doc["amount"].round()));
                      }
                      chartData.add(
                        charts.Series<TimeSeriesSales, DateTime>(
                          id: 'Budget',
                          colorFn: (_, __) =>
                              charts.ColorUtil.fromDartColor(Colors.blueAccent),
                          domainFn: (TimeSeriesSales sales, _) => sales.time,
                          measureFn: (TimeSeriesSales sales, _) => sales.sales,
                          data: budgetGiven,
                        ),
                      );
                      return NormalTimeChart(chartData, animate: false);
                      // return NormalTimeChart(chartData, animate: false);
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
