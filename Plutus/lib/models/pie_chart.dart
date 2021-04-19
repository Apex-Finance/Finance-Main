// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Imported Plutus files
import '../models/transaction.dart' as Transaction;
import '../models/category.dart';

class PiePiece {
  String category;
  double amount;
  Color colorVal;

  PiePiece(this.category, this.amount, this.colorVal);
}

class PieChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context);
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);

    return StreamBuilder<QuerySnapshot>(
      stream: transactionDataProvider
          .getMonthlyTransactions(context, DateTime.now())
          .snapshots(),
      builder: (context, tranSnapshot) {
        return StreamBuilder<QuerySnapshot>(
          stream: categoryDataProvider.streamCategories(context),
          builder: (context, catSnapshot) {
            if (!tranSnapshot.hasData ||
                !catSnapshot.hasData ||
                tranSnapshot.data.docs.isEmpty ||
                catSnapshot.data.docs.isEmpty) {
              // card with same dimensions as the one when data is present
              // prevents screen from shifting
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Container(
                  width: 400,
                  height: 500,
                  child: Column(children: [
                    Text(
                      'Dashboard chart',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]),
                ),
              );
            } else {
              List<PiePiece> pieData =
                  getPieData(tranSnapshot.data.docs, catSnapshot.data.docs);
              List<charts.Series<PiePiece, String>> pieSeriesData = [];

              pieSeriesData.add(
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

              return Card(
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
                          pieSeriesData,
                          animate: true,
                          animationDuration: Duration(seconds: 2),
                          behaviors: [
                            new charts.DatumLegend(
                              horizontalFirst: false,
                              desiredMaxRows: 4,
                              cellPadding:
                                  new EdgeInsets.only(right: 4, bottom: 4),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts
                                      .MaterialPalette.purple.shadeDefault,
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
              );
            }
          },
        );
      },
    );
  }
}

List<PiePiece> getPieData(List<QueryDocumentSnapshot> tranSnapshot,
    List<QueryDocumentSnapshot> catSnapshot) {
  List<PiePiece> data = [];

  for (var category in catSnapshot) {
    var catAmount = tranSnapshot
        .where((i) =>
            i['categoryTitle'].toString() == category['title'].toString())
        .toList()
        .fold(0.0, (a, b) => a + b['amount']);
    data.add(new PiePiece(category['title'].toString(), catAmount,
        Color(category['pieColor'].toInt())));
  }
  return data;
}
