// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Plutus/widgets/update_email_form.dart';
import 'package:Plutus/widgets/update_password_form.dart';

// Imported Plutus files
import '../providers/auth.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  Stream<DocumentSnapshot> getUserInfo(BuildContext context) {
    var userInfo = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .snapshots();
    return userInfo;
  }

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
        // TODO Do we need this commented?
        // IconButton(
        //icon:
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 25,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              Provider.of<Auth>(context, listen: false).logout(context);
            },
          ),
        ],
        // ),
      ),
      // TODO Find out why this is commented out
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
        child: StreamBuilder<DocumentSnapshot>(
            stream: getUserInfo(context),
            builder: (context, userAccount) {
              var connectionState = userAccount.connectionState;
              switch (connectionState) {
                case ConnectionState.none:
                  {
                    return Text(
                        "There was an error loading your account information.");
                  }
                case ConnectionState.waiting:
                  {
                    return CircularProgressIndicator();
                  }

                default:
                  {
                    String email = userAccount.data.get('email');
                    return Column(
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
                              '$email',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            // commented out because no longer editing emails
                            // SizedBox(
                            //   width: 10,
                            // ),
                            // IconButton(
                            //   icon: Icon(
                            //     Icons.create_sharp,
                            //     size: 25,
                            //     color: Theme.of(context).primaryColor,
                            //   ),
                            //   onPressed: () {
                            //     pullChangeEmailForm(context);
                            //   },
                            // ),
                          ],
                        ),
                        Icon(
                          Icons.account_circle,
                          size: 200,
                          color: Theme.of(context).primaryColor,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                                bottom: Radius.circular(20),
                              ),
                            ),
                            primary: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                          onPressed: () {
                            pullChangePasswordForm(context)
                                .then((value) => setState(() {}));
                          },
                        ),
                      ],
                    );
                  }
              }
            }),
      ),
    );
  }
}
// this function no longer used
// Future<Widget> pullChangeEmailForm(BuildContext context) async {
//   return showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (_) => UpdateEmailForm());
// }

Future<Widget> pullChangePasswordForm(BuildContext context) async {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => UpdatePasswordForm());
}
