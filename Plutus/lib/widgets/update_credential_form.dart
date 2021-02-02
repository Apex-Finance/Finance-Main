import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class UpdateCredentialsForm extends StatefulWidget {
  @override
  _UpdateCredentialsFormState createState() => _UpdateCredentialsFormState();
}

enum CredentialUpdate { Password, Email }

class _UpdateCredentialsFormState extends State<UpdateCredentialsForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  CredentialUpdate _credentialUpdate = CredentialUpdate.Email;
  final User authInfo = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore userInfo = FirebaseFirestore.instance;
  String newEmail;
  String newPassword;
  final _passwordController = TextEditingController();
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
  }

  updatePassword() async {
    authInfo.updatePassword(newPassword);
    userInfo
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .set({'password': newPassword}, SetOptions(merge: true)).catchError(
            (error) {
      print(error);
    });
    Provider.of<Auth>(context, listen: false).setPassword(newPassword);
  }

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
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
      if (_credentialUpdate == CredentialUpdate.Email) {
        updateEmail();
      } else {
        updatePassword();
      }
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
        errorMessage = 'Submit yur credentials before updating them.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'Please create a stronger password';
      }
      _showErrorDialog(errorMessage);
    }
  }

  void _switchCredentialUpdate() {
    if (_credentialUpdate == CredentialUpdate.Email) {
      _credentialUpdate = CredentialUpdate.Password;
    } else {
      _credentialUpdate = CredentialUpdate.Email;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
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
                  if (_credentialUpdate == CredentialUpdate.Email)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'E-Mail'),
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
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
                  if (_credentialUpdate == CredentialUpdate.Password)
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      onEditingComplete: () => {
                        if (_credentialUpdate == CredentialUpdate.Password)
                          {FocusScope.of(context).nextFocus()}
                        else
                          {FocusScope.of(context).unfocus()}
                      },
                      obscureText: true,
                      controller: _passwordController,
                      // ignore: missing_return
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'Password is too short!';
                        }
                      },
                      onSaved: (value) {
                        newPassword = value.trim();
                      },
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    child: Text(
                        'Change ${_credentialUpdate == CredentialUpdate.Email ? 'Email' : 'Password'}'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                  FlatButton(
                    child: Text(
                        '${_credentialUpdate == CredentialUpdate.Email ? 'CHANGE EMAIL' : 'CHANGE PASSWORD'} INSTEAD'),
                    onPressed: _switchCredentialUpdate,
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
