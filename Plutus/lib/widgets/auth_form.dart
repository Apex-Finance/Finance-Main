import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../screens/tab_screen.dart';
import '../providers/auth.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthMode { Signup, Login }

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  var _isLoading = false;
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

  Future<void> _submit() async {
    UserCredential credentialResult;
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        credentialResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        credentialResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(credentialResult.user.uid)
            .set({
          'email': email,
          'password': password,
        });
      }
      Provider.of<Auth>(context, listen: false)
          .setUserId(credentialResult.user.uid);
      Provider.of<Auth>(context, listen: false).setPassword(password);
      if (credentialResult != null) {
        Navigator.pushNamed(context, TabScreen.routeName);
      }
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.code == 'invalid-email') {
        errorMessage = 'This is not a valid email address';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'This user is not found.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Incorrect password';
      } else if (error.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (error.code == 'invalid-email') {
        errorMessage = 'This is not a valid email address';
      } else if (error.code == 'weak-password') {
        errorMessage = 'This password is too weak.';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
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
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    RaisedButton(
                      child: Text('Hunter Login'),
                      onPressed: () {
                        email = 'hunter@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;
                        _submit();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                    RaisedButton(
                      child: Text('Juan Login'),
                      onPressed: () {
                        email = 'juan@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;

                        _submit();
                      },
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
                Row(
                  children: [
                    RaisedButton(
                      child: Text('Tzuriel Login'),
                      onPressed: () {
                        email = 'tzuriel@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;

                        _submit();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                    RaisedButton(
                      child: Text('Adam Login'),
                      onPressed: () {
                        email = 'adam@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;

                        _submit();
                      },
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
                Row(
                  children: [
                    RaisedButton(
                      child: Text('Alex Login'),
                      onPressed: () {
                        email = 'alex@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;

                        _submit();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                    ),
                    RaisedButton(
                      child: Text('Team Login'),
                      onPressed: () {
                        email = 'team@apex.com';
                        password = '123456';
                        _passwordController.text = password;
                        _emailController.text = email;

                        _submit();
                      },
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  controller: _emailController,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value.trim();
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  onEditingComplete: () => {
                    if (_authMode == AuthMode.Signup)
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
                    password = value.trim();
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    onEditingComplete: () => FocusScope.of(context).unfocus(),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        // ignore: missing_return
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
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
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
