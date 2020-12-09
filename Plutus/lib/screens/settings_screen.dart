import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
    );
  }
}
