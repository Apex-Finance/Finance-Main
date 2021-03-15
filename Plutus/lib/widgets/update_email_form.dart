import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class UpdateEmailForm extends StatefulWidget {
  @override
  _UpdateEmailFormState createState() => _UpdateEmailFormState();
}

class _UpdateEmailFormState extends State<UpdateEmailForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final User authInfo = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore userInfo = FirebaseFirestore.instance;
  String newEmail;
  final _emailController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  updateEmail() async {
    authInfo.updateEmail(newEmail);
    userInfo
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .set({'email': newEmail}, SetOptions(merge: true)).catchError((error) {
      print(error);
    });
    Provider.of<Auth>(context, listen: false).setEmail(newEmail);
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid
      return;
    }
    _formKey.currentState.save();

    try {
      await authInfo.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: authInfo.email,
          password: Provider.of<Auth>(context, listen: false).getPassword(),
        ),
      );
      updateEmail();
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed.';
      if (error.code == 'user-mismatch') {
        errorMessage = 'Credentials do not match.';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'This user does not exist.';
      } else if (error.code == 'invalid-credential') {
        errorMessage = 'Invalid credentials.';
      } else if (error.code == 'invalid-email') {
        errorMessage = 'Invalid email.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (error.code == 'email-already-in-use') {
        errorMessage = 'This email is already use.';
      } else if (error.code == 'requires-recent-login') {
        errorMessage = 'Submit your credentials before updating them.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'Please create a stronger password';
      }
      _showErrorDialog(errorMessage);
    }
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return KeyboardAvoider(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 8.0,
        child: Container(
            height: 320,
            constraints: BoxConstraints(minHeight: 320),
            width: deviceSize.width * 0.75,
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () => FocusScope.of(context).unfocus(),
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        newEmail = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text('Change Email'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
