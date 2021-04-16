// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class GroupedBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  GroupedBarChart(this.seriesList, {this.animate});

  factory GroupedBarChart.withSampleData() {
    return new GroupedBarChart(
      ChartDataProvider.getBarChartData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      barRendererDecorator: new charts.BarLabelDecorator<String>(
        insideLabelStyleSpec: new charts.TextStyleSpec(
          color: charts.ColorUtil.fromDartColor(Colors.black),
        ),
      ),
      vertical: false,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
    );
  }
}

class NormalBarChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  NormalBarChart(this.seriesList, {this.animate});

  factory NormalBarChart.withSampleData() {
    return new NormalBarChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      domainAxis: new charts.OrdinalAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('2014', 5),
      new OrdinalSales('2015', 25),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Desktop',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
    ];
  }
}

class NormalTimeChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  NormalTimeChart(this.seriesList, {this.animate});

  factory NormalTimeChart.withSampleData() {
    return new NormalTimeChart(
      ChartDataProvider.getTimeData(),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      domainAxis: new charts.DateTimeAxisSpec(
        renderSpec: new charts.SmallTickRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
      primaryMeasureAxis: new charts.NumericAxisSpec(
        renderSpec: new charts.GridlineRendererSpec(
          labelStyle: new charts.TextStyleSpec(
            color: charts.MaterialPalette.white,
          ),
        ),
      ),
    );
  }
}

class ChartDataProvider with ChangeNotifier {
  static List<charts.Series<OrdinalSales, String>> getBarChartData() {
    final transactionsReported = [
      new OrdinalSales('January', 400),
      new OrdinalSales('February', 700),
      new OrdinalSales('March', 600),
    ];

    final budgetGiven = [
      new OrdinalSales('January', 500),
      new OrdinalSales('February', 600),
      new OrdinalSales('March', 800),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Transactions',
        colorFn: (OrdinalSales sales, int index) =>
            sales.sales <= budgetGiven[index].sales
                ? charts.ColorUtil.fromDartColor(Colors.greenAccent)
                : charts.ColorUtil.fromDartColor(Colors.redAccent),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: transactionsReported,
        labelAccessorFn: (OrdinalSales sales, _) =>
            'Total Transactions: \$${sales.sales}',
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Budget',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blueAccent),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: budgetGiven,
        // fillPatternFn: (OrdinalSales sales, _) =>
        //     charts.FillPatternType.forwardHatch,
        labelAccessorFn: (OrdinalSales sales, _) => 'Budget: \$${sales.sales}',
      ),
    ];
  }

  /// Create series list with multiple series
  static List<charts.Series<TimeSeriesSales, DateTime>> getTimeData() {
    final transactionsReported = [
      new TimeSeriesSales(DateTime(2021, 1, 1), 400),
      new TimeSeriesSales(DateTime(2021, 2, 1), 700),
      new TimeSeriesSales(DateTime(2021, 3, 1), 600),
    ];

    final budgetGiven = [
      new TimeSeriesSales(DateTime(2021, 1, 1), 500),
      new TimeSeriesSales(DateTime(2021, 2, 1), 600),
      new TimeSeriesSales(DateTime(2021, 3, 1), 800),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Transactions',
        colorFn: (TimeSeriesSales sales, int index) =>
            charts.ColorUtil.fromDartColor(Colors.yellowAccent),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: transactionsReported,
      ),
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Budget',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.blueAccent),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: budgetGiven,
      ),
    ];
  }
}
