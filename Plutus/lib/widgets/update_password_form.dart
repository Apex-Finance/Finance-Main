// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Imported Plutus files
import '../providers/auth.dart';
import '../providers/color.dart';

class UpdatePasswordForm extends StatefulWidget {
  @override
  _UpdatePasswordFormState createState() => _UpdatePasswordFormState();
}

class _UpdatePasswordFormState extends State<UpdatePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final User authInfo = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore userInfo = FirebaseFirestore.instance;
  String newPassword;
  final _passwordController = TextEditingController();
  var _isLoading = false;

  void _showErrorDialog(String message) {
    var colorProvider = Provider.of<ColorProvider>(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor:
            colorProvider.colorOptions[colorProvider.selectedColorIndex]
                [colorProvider.isDark ? 'dark' : 'light']['cardColor'],
        title: Text(message),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  updatePassword() async {
    setState(() {
      _isLoading = true;
    });
    await authInfo.updatePassword(newPassword);
    await userInfo
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .set({'password': newPassword}, SetOptions(merge: true)).catchError(
            (error) {});
    await Provider.of<Auth>(context, listen: false).setPassword(newPassword);
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      var userData = jsonDecode(prefs.getString('userData'));
      userData = {
        'email': userData['email'],
        'userId': userData['userId'],
        'password': newPassword,
      };
      await prefs.setString('userData', jsonEncode(userData));
    }
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
      await updatePassword();
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
      setState(() {
        _isLoading = false;
      });
      _formKey.currentState.save();
      Navigator.of(context).pop();
      return;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
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
            constraints: const BoxConstraints(minHeight: 320),
            width: deviceSize.width * 0.75,
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Password'),
                      onEditingComplete: () => {
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
                    const SizedBox(
                      height: 20,
                    ),
                    if (_isLoading) CircularProgressIndicator(),
                    if (!_isLoading)
                      ElevatedButton(
                        child: Text(
                          'Change Password',
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                        ),
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 8.0),
                          primary: Theme.of(context).primaryColor,
                          textStyle: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.button.color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
