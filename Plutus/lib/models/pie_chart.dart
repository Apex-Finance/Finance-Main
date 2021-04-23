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
  // converts a color to format that is readable for our stupid pie chart package
  static String toHexString(Color input) {
    return '#' +
        input.red.toRadixString(16).padLeft(2, '0') +
        input.green.toRadixString(16).padLeft(2, '0') +
        input.blue.toRadixString(16).padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    var transactionDataProvider =
        Provider.of<Transaction.Transactions>(context);
    var categoryDataProvider = Provider.of<CategoryDataProvider>(context);
    var transactionStream =
        transactionDataProvider.getMonthlyTransactions(context, DateTime.now());

    return StreamBuilder<QuerySnapshot>(
      stream: transactionStream.snapshots(),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Dashboard chart',
                        style: Theme.of(context).textTheme.headline1,
                      ),
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
              bool fewCategories = pieData.length <= 6;
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Dashboard chart',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: charts.PieChart(
                          pieSeriesData,
                          animate: true,
                          animationDuration: Duration(seconds: 2),
                          behaviors: [
                            new charts.DatumLegend(
                              horizontalFirst: true,
                              desiredMaxColumns: fewCategories
                                  ? 2
                                  : 3, // approx take up same space either way but allows larger fonts with fewer categories
                              cellPadding: EdgeInsets.only(
                                  right: fewCategories ? 64 : 16, bottom: 6),
                              entryTextStyle: charts.TextStyleSpec(
                                  color: charts.Color.fromHex(
                                      code: toHexString(
                                          Theme.of(context).primaryColor)),
                                  fontFamily: 'Lato',
                                  fontSize: (MediaQuery.of(context).size.width /
                                          (fewCategories ? 24 : 32))
                                      .floor()), // ~17 or 12 on modern phones, will scale up/down to match phone
                              // largest size that works when our 2 or 3 longest categories are in legend in their own columns
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
    // only display categories with transactions
    if (catAmount > 0)
      data.add(new PiePiece(category['title'].toString(), catAmount,
          Color(category['pieColor'].toInt())));
  }
  return data;
}
