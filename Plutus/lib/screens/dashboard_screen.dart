import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard Screen',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
