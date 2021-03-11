import 'package:flutter/material.dart';
import 'package:Plutus/models/charts.dart';

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
                child: NormalTimeChart.withSampleData(),
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
