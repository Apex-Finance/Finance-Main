import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatelessWidget {
  static const routeName = '/account';

  // String returnEmail(BuildContext context) async {
  //   var dbRef = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Provider.of<Auth>(context, listen: false).getUserId())
  //       .get();
  //   var email = await dbRef.data()['email'];
  //   return email;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account Screen',
          style: TextStyle(
            color: Theme.of(context).canvasColor,
          ),
        ),
        // IconButton(
        //icon:
        actions: [
          Icon(
            Icons.logout,
            size: 25,
            color: Theme.of(context).accentColor,
            //onPressed: () {},
          ),
        ],
        // ),
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
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  //'$email',
                  'name',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(
                  width: 10,
                ),
                // IconButton(
                //icon:
                Icon(
                  Icons.create_sharp,
                  size: 25,
                  color: Theme.of(context).primaryColor,
                  //onPressed: () {},
                ),
                // ),
              ],
            ),
            Icon(
              Icons.account_circle,
              size: 200,
              color: Theme.of(context).primaryColor,
            ),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                  bottom: Radius.circular(20),
                ),
              ),
              color: Theme.of(context).primaryColor,
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Theme.of(context).canvasColor,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
