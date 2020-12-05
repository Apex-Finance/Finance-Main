import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final Map<String, Object> currentUser = {
    'id': null,
    'email': null,
  };

  void getUser() {
    try {
      final userChanges = _auth.userChanges();
      userChanges.listen(
        (User user) {
          if (user != null) {
            currentUser['email'] = user.email;
            currentUser['id'] = user.tenantId;
          } else {
            print('User is currently signed in!');
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

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
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }

  void _autoLogout() async {}
}
