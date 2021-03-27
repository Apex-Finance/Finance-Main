import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import '../models/pie_chart.dart';

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
      new PiePiece('uncategorized', 24.8, Colors.black),
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
    _pieSeriesData = List<charts.Series<PiePiece, String>>();
    _generateData();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Container(
              child: Center(
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
                            outsideJustification:
                                charts.OutsideJustification.endDrawArea,
                            horizontalFirst: false,
                            desiredMaxRows: 2,
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
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Dashboard chart',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Dashboard chart',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Dashboard chart',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Dashboard chart',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Dashboard chart',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                'Dashboard chart',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
