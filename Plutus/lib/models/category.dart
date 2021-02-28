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

class CategoryDataProvider with ChangeNotifier {
  // initialize a category document from database into category object
  Category initializeCategory(DocumentSnapshot doc) {
    Category category = Category();
    category.setID(doc.id);
    if (doc.data()['amount'].toDouble() == null) {
      category.setAmount(0.00);
    } else {
      category.setAmount(doc.data()['amount'].toDouble());
    }
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

  // get the list of transaction from the db matching the category
  Stream<QuerySnapshot> getCategoryTransactions(
      BuildContext context, String categoryID) {
    var db = FirebaseFirestore.instance;
    var categoryTransactions = db
        .collection('users')
        .doc(Provider.of<Auth>(context).getUserId())
        .collection('Transactions')
        .where('category id', isEqualTo: categoryID)
        .snapshots();

    return categoryTransactions;
  }

  double getCategoryTransactionsAmount(Budget budget, MainCategory category) {
    List<Transaction.Transaction> categoryTransactions =
        getCategoryTransactions(budget, category);
    if (categoryTransactions == null)
      return 0.00;
    else {
      var sum = 0.0;
      for (var transaction in categoryTransactions) {
        sum += transaction.getAmount();
      }
      return sum;
    }
  }
}
