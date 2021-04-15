import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart' as Transaction;
import '../models/category.dart';

class PiePiece {
  String category;
  double amount;
  Color colorVal;

  PiePiece(this.category, this.amount, this.colorVal);
}

class PieChartCard extends StatelessWidget {
  // List<charts.Series<PiePiece, String>> _pieSeriesData;
  // _generateData() {
  //   var pieData = [
  //     new PiePiece('home', 35.8, Colors.blue),
  //     new PiePiece('food_and_drinks', 8.3, Colors.red),
  //     new PiePiece('bills', 10.8, Colors.green),
  //     new PiePiece('eduction', 15.6, Colors.yellow),
  //     new PiePiece('shopping', 19.2, Colors.orange),
  //     new PiePiece('travel', 10.3, Colors.pink),
  //     new PiePiece('entertainment', 12.4, Colors.purple),
  //     new PiePiece('investments', 15.7, Colors.brown),
  //     new PiePiece('uncategorized', 24.8, Colors.indigo),
  //   ];

  //   _pieSeriesData.add(
  //     charts.Series(
  //       domainFn: (PiePiece piePiece, _) => piePiece.category,
  //       measureFn: (PiePiece piePiece, _) => piePiece.amount,
  //       colorFn: (PiePiece piePiece, _) =>
  //           charts.ColorUtil.fromDartColor(piePiece.colorVal),
  //       id: 'How you spent',
  //       data: pieData,
  //       labelAccessorFn: (PiePiece row, _) => '${row.category}',
  //     ),
  //   );
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _pieSeriesData = <charts.Series<PiePiece, String>>[];
  //   _generateData();
  // }
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
            var data =
                getPieData(tranSnapshot.data.docs, catSnapshot.data.docs);
            print(data.length);
            return Text('something');
            // return Card(
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.vertical(
            //               top: Radius.circular(20),
            //               bottom: Radius.circular(20),
            //             ),
            //           ),
            //           child: Container(
            //             width: 400,
            //             height: 500,
            //             child: Column(
            //               children: [
            //                 Text(
            //                   'Dashboard chart',
            //                   style: Theme.of(context).textTheme.bodyText1,
            //                 ),
            //                 SizedBox(height: 10),
            //                 Expanded(
            //                   child: charts.PieChart(
            //                     _pieSeriesData,
            //                     animate: true,
            //                     animationDuration: Duration(seconds: 2),
            //                     behaviors: [
            //                       new charts.DatumLegend(
            //                         horizontalFirst: false,
            //                         desiredMaxRows: 4,
            //                         cellPadding:
            //                             new EdgeInsets.only(right: 4, bottom: 4),
            //                         entryTextStyle: charts.TextStyleSpec(
            //                             color:
            //                                 charts.MaterialPalette.purple.shadeDefault,
            //                             fontFamily: 'Georgia',
            //                             fontSize: 11),
            //                       )
            //                     ],
            //                     defaultRenderer: new charts.ArcRendererConfig(
            //                       arcWidth: 100,
            //                       arcRendererDecorators: [
            //                         new charts.ArcLabelDecorator(
            //                             labelPosition: charts.ArcLabelPosition.inside)
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
          },
        );
      },
    );
  }
}

List<dynamic> getPieData(List<QueryDocumentSnapshot> tranSnapshot,
    List<QueryDocumentSnapshot> catSnapshot) {
  var data = [];

  for (var category in catSnapshot) {
    var catAmount = tranSnapshot
        .where((i) =>
            i['categoryTitle'].toString() == category['title'].toString())
        .toList()
        .fold(0.0, (a, b) => a + b['amount']);
    data.add(
        new PiePiece(category['title'].toString(), catAmount, Colors.blue));
  }
  return data;
}
