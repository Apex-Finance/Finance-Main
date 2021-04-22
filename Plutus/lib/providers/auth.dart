// Imported Dart packages
import 'dart:convert';
import 'dart:async';

// Imported Flutter packages
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imported Plutus files
import '../screens/auth_screen.dart';

class Auth with ChangeNotifier {
  User authInfo = FirebaseAuth.instance.currentUser;
  FirebaseFirestore userInfo = FirebaseFirestore.instance;
  String id;
  String email;
  String password;

  void setEmail(String emailValue) {
    email = emailValue;
  }

  String getEmail() {
    return email;
  }

  setPassword(String passwordEntered) {
    password = passwordEntered;
  }

  String getPassword() {
    return password;
  }

  void setUserId(String userId) {
    id = userId;
  }

  String getUserId() {
    return id;
  }

  // unused but keeping for post-expo
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    notifyListeners();
    return true;
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.routeName,
        (Route<dynamic> route) =>
            false); // remove all screens so user can't hit back button and be logged in

    notifyListeners();
  }
}
