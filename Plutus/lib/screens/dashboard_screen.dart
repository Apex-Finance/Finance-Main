import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:Plutus/models/category.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/budget.dart';
import 'new_budget_screens/income_screen.dart';
import '../widgets/budget_list_tile.dart';
import '../providers/auth.dart';
import '../models/transaction.dart' as Transaction;
import 'package:provider/provider.dart';
import '../models/month_changer.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<charts.Series<PiePiece, String>> _pieSeriesData;
  _generateData() {
    var pieData = [
      new PiePiece('home', 35.8, Colors.blue),
      new PiePiece('food_and_drinks', 8.3, Colors.red),
      new PiePiece('bills', 10.8, Colors.green),
      new PiePiece('eduction', 15.6, Colors.yellow),
      new PiePiece('shopping', 19.2, Colors.orange),
      new PiePiece('travel', 10.3, Colors.pink),
      new PiePiece('entertainment', 12.4, Colors.purple),
      new PiePiece('investments', 15.7, Colors.brown),
      new PiePiece('uncategorized', 24.8, Colors.indigo),
    ];

    _pieSeriesData.add(
      charts.Series(
        domainFn: (PiePiece piePiece, _) => piePiece.category,
        measureFn: (PiePiece piePiece, _) => piePiece.amount,
        colorFn: (PiePiece piePiece, _) =>
            charts.ColorUtil.fromDartColor(piePiece.colorVal),
        id: 'How you spent',
        data: pieData,
        labelAccessorFn: (PiePiece row, _) => '${row.category}',
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _pieSeriesData = <charts.Series<PiePiece, String>>[];
    _generateData();
  }

  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(15.0),
      children: [
        Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
              ),
              child: Container(
                width: 400,
                height: 500,
                child: Column(
                  children: [
                    Text(
                      'Dashboard chart',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: charts.PieChart(
                        _pieSeriesData,
                        animate: true,
                        animationDuration: Duration(seconds: 2),
                        behaviors: [
                          new charts.DatumLegend(
                            horizontalFirst: false,
                            desiredMaxRows: 4,
                            cellPadding:
                                new EdgeInsets.only(right: 4, bottom: 4),
                            entryTextStyle: charts.TextStyleSpec(
                                color:
                                    charts.MaterialPalette.purple.shadeDefault,
                                fontFamily: 'Georgia',
                                fontSize: 11),
                          )
                        ],
                        defaultRenderer: new charts.ArcRendererConfig(
                          arcWidth: 100,
                          arcRendererDecorators: [
                            new charts.ArcLabelDecorator(
                                labelPosition: charts.ArcLabelPosition.inside)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
              ),
              child: ListTile(
                title: Column(
                  children: [
                    Text(
                      'Total Budget this month',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: new LinearPercentIndicator(
                        width: MediaQuery.of(context).size.width * .80, //.82
                        animation: true,
                        lineHeight: 20.0,
                        animationDuration: 2500,
                        percent: 0.8,
                        center: Text("80.0%"),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /*new LinearPercentIndicator(
                      alignment: MainAxisAlignment.center,
                      width: 310.0,
                      lineHeight: 14.0,
                      percent: transactionExpenses > budget.getAmount()
                          ? 1
                          : transactionExpenses / budget.getAmount(),
                      backgroundColor: Colors.black,
                      progressColor: Colors.amber,
                    ),*/
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    height: 90,
                    width: 180,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Total Spent',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$500',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    height: 90,
                    width: 134, // 180
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Total Saved',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '\$500',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Card(
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
                        child: Text(
                          'Recent Transactions',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
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
                        child: Text(
                          'Upcoming Goals',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
