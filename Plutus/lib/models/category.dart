import 'package:Plutus/models/categories.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../providers/auth.dart';
import './categories.dart';

class Category {
  int _codepoint; // Codepoint to store the icon info
  String _id;
  String _title;
  MainCategory _categoryName;
  double _amount;
  double _remainingAmount; // this will be calculated when streaming

  Map<String, dynamic> toMap() {
    return {
      'id': getID(),
      'categoryName': _categoryName,
      'amount': getAmount(),
      'remainingAmount': getRemainingAmount(),
    };
  }

  void setCodepoint(int codepointValue) {
    _codepoint = codepointValue;
  }

  int getCodepoint() {
    return _codepoint;
  }

  void setID(String idValue) {
    _id = idValue;
  }

  String getID() {
    return _id;
  }

  void setTitle(String titleValue) {
    _title = titleValue;
  }

  String getTitle() {
    return _title;
  }

  void setAmount(double amountValue) {
    _amount = amountValue;
  }

  double getAmount() {
    return _amount;
  }

  void calculateRemainingAmount(double categoryTransactionsAmount) {
    _remainingAmount = getAmount() - categoryTransactionsAmount;
  }

  double getRemainingAmount() {
    return _remainingAmount;
  }
}

class CategoryDataProvider {
  Category initializeCategory(DocumentSnapshot doc) {
    Category category = Category();

    category.setID(doc.id);
    category.setAmount(doc.data()['amount'].toDouble());
    category.setTitle(doc.data()['title']);
    category.setCodepoint(doc.data()['codepoint'].toInt());

    return category;
  }

  void addCategory(
      String budgetID, Category category, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budgetID)
        .collection('categories')
        .doc()
        .set({
      'title': category.getTitle(),
      'amount': category.getAmount(),
      'codepoint': category.getCodepoint(),
    });
  }

  void editCategory(
      String budgetID, Category category, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budgetID)
        .collection('categories')
        .doc(category.getID())
        .set(
      {
        'title': category.getTitle(),
        'amount': category.getAmount(),
        'codepoint': category.getCodepoint(),
      },
      SetOptions(merge: true),
    );
  }

  void removeCategory(
      String budgetID, Category category, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budgetID)
        .collection('categories')
        .doc(category.getID())
        .delete();
  }
}
