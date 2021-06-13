// Imported Flutter packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Imported Plutus files
import '../screens/tab_screen.dart';
import '../providers/auth.dart';

// Form to login a user
class AuthForm extends StatefulWidget {
  final authMode;
  AuthForm(this.authMode);

  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthMode { Signup, Login }

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  var _passwordResetLoading = false;
  var _isLoading = false;
  var _isWaitingForVerification = false;
  var _stillNotVerified = false;
  var _forgotPassword = false;
  var _passwordResetEmailSent = false;
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  var _iserror = false;
  UserCredential credentialResult;

  // Displays a popup informing the user that an issue occurred
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }

  void forgotPassword() {
    setState(() {
      _forgotPassword = true;
    });
  }

  Future<void> setUserInfo(UserCredential credentialResult) async {
    Provider.of<Auth>(context, listen: false).setEmail(email);
    Provider.of<Auth>(context, listen: false)
        .setUserId(credentialResult.user.uid);
    Provider.of<Auth>(context, listen: false).setPassword(password);
    if (credentialResult != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = {
        'email': email,
        'userId': credentialResult.user.uid,
        'password': password
      };
      await prefs.setString('userData', jsonEncode(userData));
      Navigator.pushNamed(context, TabScreen.routeName);
    }
  }

  // Submits the entered credentials and awaits for authentication
  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      setState(() {
        _iserror = true;
      });
      // Invalid!
      return;
    }
    setState(() {
      _iserror = false;
    });
    _formKey.currentState.save();
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_forgotPassword) {
        setState(() {
          _passwordResetLoading = true;
        });
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        setState(() {
          _passwordResetEmailSent = true;
          _passwordResetLoading = false;
        });
      } else {
        if (_authMode == AuthMode.Login) {
          // Log user in
          credentialResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          if (credentialResult.user.emailVerified) {
            setState(() {
              _isWaitingForVerification = false;
            });
            await setUserInfo(credentialResult);
          } else
            setState(() {
              _stillNotVerified = true;
            });
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
          await credentialResult.user.sendEmailVerification();
          // TODO: figure out why this won't work..should open the app from the email
          // ActionCodeSettings(
          //   url: 'https://apex-finance.firebaseapp.com/',
          //   androidInstallApp: true,
          //   androidPackageName: 'com.example.Plutus',
          //   androidMinimumVersion: '0.0.0',
          //   handleCodeInApp: true));
          setState(() {
            _stillNotVerified = false;
            _isLoading = false;
            _isWaitingForVerification = true;
          });
        }
      }
      // Error messages
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.code == 'invalid-email') {
        errorMessage = 'This is not a valid email address.';
      } else if (error.code == 'user-not-found') {
        errorMessage = 'This user is not found.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (error.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (error.code == 'weak-password') {
        errorMessage = 'This password is too weak.';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Switches between Login and Signup modes
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

  Widget getContent() {
    if (_isWaitingForVerification)
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  'An email has been sent to ${credentialResult.user.email}. Please follow the link to verify authentication.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            if (_stillNotVerified)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AutoSizeText(
                    'Please verify the email before logging in.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ElevatedButton(
              child: Text(
                'LOGIN',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              onPressed: () {
                _authMode = AuthMode.Login;
                _submit();
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                    color: Theme.of(context).primaryTextTheme.button.color),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            TextButton(
              child: Text('Resend verification email'),
              onPressed: credentialResult.user.sendEmailVerification,
              style: TextButton.styleFrom(
                textStyle: TextStyle(decoration: TextDecoration.underline),
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                primary: Theme.of(context).primaryColor,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ]);
    else if (_forgotPassword)
      return Column(children: <Widget>[
        if (!_passwordResetEmailSent)
          TextFormField(
            decoration: InputDecoration(
                labelText: 'E-Mail',
                // if user is signing up, show an icon indicating whether their email is valid
                suffixIcon: Icon(_emailController.text.isEmpty ||
                        _authMode == AuthMode.Login
                    ? null
                    : (_emailController.text.trim().contains(RegExp(
                            r'^[a-zA-Z0-9]+([.]?[a-zA-Z0-9]+){0,2}@[a-zA-Z0-9]+([.][a-zA-Z0-9]{2,}){1,2}$'))
                        ? Icons.check
                        : Icons.error))),
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (val) => setState(() {}),
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return 'Please enter an email address.';
              if (!value.trim().contains(RegExp(
                  r'^[a-zA-Z0-9]+([.]?[a-zA-Z0-9]+){0,2}@[a-zA-Z0-9]+([.][a-zA-Z0-9]{2,}){1,2}$')))
              // after removing leading/trailing whitespace, regex checks for:
              // one or more characters followed by
              // 0-2 (.(1+characters) followed by
              // @ followed by
              // one or more characters followed by
              // 1-2 (.(2+ characters))
              {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              email = value.trim();
            },
            style: Theme.of(context).textTheme.bodyText2,
          ),
        if (!_passwordResetEmailSent && !_passwordResetLoading)
          TextButton(
            child: Text(
              'Send password reset email',
            ),
            onPressed: _submit,
            style: TextButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              textStyle: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryTextTheme.button.color),
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            ),
          ),
        if (_passwordResetLoading)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        if (_passwordResetEmailSent)
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                'An email has been sent to ${_emailController.text}. Please follow the link to reset your password.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        Spacer(),
        ElevatedButton(
          child: Text(
            'LOGIN',
            style: Theme.of(context).textTheme.subtitle2,
          ),
          onPressed: () {
            setState(() {
              _authMode = AuthMode.Login;
              _passwordResetEmailSent = false;
              _forgotPassword = false;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            textStyle: TextStyle(
                color: Theme.of(context).primaryTextTheme.button.color),
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ]);
    else // logging in or signing up
      return Column(
        children: <Widget>[
          // Title
          Text(
            'Plutus',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
            ),
          ),
          // E-mail
          TextFormField(
            decoration: InputDecoration(
                labelText: 'E-Mail',
                // if user is signing up, show an icon indicating whether their email is valid
                suffixIcon: Icon(_emailController.text.isEmpty ||
                        _authMode == AuthMode.Login
                    ? null
                    : (_emailController.text.trim().contains(RegExp(
                            r'^[a-zA-Z0-9]+([.]?[a-zA-Z0-9]+){0,2}@[a-zA-Z0-9]+([.][a-zA-Z0-9]{2,}){1,2}$'))
                        ? Icons.check
                        : Icons.error))),
            keyboardType: TextInputType.emailAddress,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
            onChanged: (val) => setState(() {}),
            controller: _emailController,
            validator: (value) {
              if (value.isEmpty) return 'Please enter an email address.';
              if (!value.trim().contains(RegExp(
                  r'^[a-zA-Z0-9]+([.]?[a-zA-Z0-9]+){0,2}@[a-zA-Z0-9]+([.][a-zA-Z0-9]{2,}){1,2}$')))
              // after removing leading/trailing whitespace, regex checks for:
              // one or more characters followed by
              // 0-2 (.(1+characters) followed by
              // @ followed by
              // one or more characters followed by
              // 1-2 (.(2+ characters))
              {
                return 'Invalid email!';
              }
              return null;
            },
            onSaved: (value) {
              email = value.trim();
            },
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // Password
          TextFormField(
            decoration: InputDecoration(
                // if user is signing up, show an icon indicating whether their password is long enough
                suffixIcon: Icon(_passwordController.text.isEmpty ||
                        _authMode == AuthMode.Login
                    ? null
                    : (_passwordController.text.trim().length < 6
                        ? Icons.error
                        : Icons.check)),
                labelText: 'Password',
                helperText: _authMode == AuthMode.Signup
                    ? 'At least 6 characters'
                    : ''),
            onEditingComplete: () => {
              if (_authMode == AuthMode.Signup)
                {FocusScope.of(context).nextFocus()}
              else
                {FocusScope.of(context).unfocus()}
            },
            onChanged: (val) => setState(() {}), //update the suffix icon
            obscureText: true,
            controller: _passwordController,
            // ignore: missing_return
            validator: (value) {
              if (value.isEmpty || value.trim().length < 6) {
                return 'Password must be at least 6 characters!';
              }
            },
            onSaved: (value) {
              password = value.trim();
            },
            style: Theme.of(context).textTheme.bodyText2,
          ),
          if (_authMode == AuthMode.Login)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: Text('Forgot password?'),
                onPressed: forgotPassword,
                style: TextButton.styleFrom(
                  textStyle: TextStyle(decoration: TextDecoration.underline),
                  primary: Theme.of(context).primaryColor,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          // Default is Login
          if (_authMode == AuthMode.Signup)
            // Confirm Password
            TextFormField(
              enabled: _authMode == AuthMode.Signup,
              decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: Icon(_confirmPasswordController.text.isEmpty
                      ? null
                      : (_confirmPasswordController.text.trim() ==
                              _passwordController.text.trim()
                          ? Icons.check
                          : Icons.error))),
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              obscureText: true,
              onChanged: (val) => setState(() {}),
              controller: _confirmPasswordController,
              validator: _authMode == AuthMode.Signup
                  // ignore: missing_return
                  ? (value) {
                      if (value != _passwordController.text.trim()) {
                        return 'Passwords do not match!';
                      }
                    }
                  : null,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          const SizedBox(
            height: 20,
          ),
          if (_isLoading)
            CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            )
          else
            Column(children: [
              // LOGIN/SIGNUP UP button
              ElevatedButton(
                child: Text(
                  _authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: TextStyle(
                      color: Theme.of(context).primaryTextTheme.button.color),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              // Button to switch AuthModes
              TextButton(
                child: Text(
                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                onPressed: _switchAuthMode,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  primary: Theme.of(context).primaryColor,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ])
        ],
      );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _authMode = widget.authMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Adjusts based on the size of the device
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      color: Colors
          .white, // Needs to be white; will be otherwise black if Light mode is on
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: SingleChildScrollView(
        child: Container(
          // Signup card is bigger due to extra textfield
          height: _isWaitingForVerification || _forgotPassword
              ? 300
              : (_iserror
                  ? (_authMode == AuthMode.Signup ? 460 : 425)
                  : (_authMode == AuthMode.Signup ? 390 : 375)),

          width: deviceSize.width * 0.75,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: getContent(),
          ),
        ),
      ),
    );
  }
}
