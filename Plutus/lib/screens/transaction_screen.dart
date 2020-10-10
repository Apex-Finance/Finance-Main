import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  static const routeName = '/transaction';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Transaction Screen',
        style: Theme.of(context).textTheme.bodyText1,
      ), //TextTheme().bodyText1,
    );
  }
}
