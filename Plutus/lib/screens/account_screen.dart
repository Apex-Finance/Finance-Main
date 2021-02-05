import 'package:flutter/material.dart';
import '../providers/auth.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Account Screen',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.of(context).pushNamed('/dashboard');
      //   },
      //   child: Icon(
      //     Icons.arrow_back_ios,
      //     size: 30,
      //     color: Theme.of(context).primaryColor,
      //   ),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'User name',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Icon(
              Icons.account_circle,
              size: 200,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'Change Password',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
