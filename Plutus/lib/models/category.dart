// Imported Flutter packages
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imported Plutus files
import '../providers/auth.dart';

class Category {
  Category(
      [this._codepoint,
      this._id,
      this._title,
      this._amount,
      this._remainingAmount]);

  Category.deepCopy(Category category)
      : this(category._codepoint, category._id, category._title,
            category._amount);

  int _codepoint; // Codepoint to store the icon info
  String _id;
  String _title;
  double _amount;
  double _remainingAmount; // this will be calculated when streaming

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
  Category initializeCategory(DocumentSnapshot doc) {
    Category category = Category();

    category.setID(doc.id);
    if (doc.data()['amount'].toDouble() == null) {
      category.setAmount(0.00);
    } else {
      category.setAmount(doc.data()['amount'].toDouble());
    }

    category.setTitle(doc.data()['title']);
    category.setCodepoint(doc.data()['codepoint'].toInt());

    return category;
  }

  Future uploadCategory(
      String budgetID, Category category, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
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

  Future setCategoryAmount(String budgetId, Category category, double amount,
      BuildContext context) async {
    category.setAmount(amount);
    if (amount > 0) {
      await uploadCategory(budgetId, category, context);
    }
    if (amount == 0) {
      await removeCategory(budgetId, category.getID(), context);
    }
    notifyListeners();
  }

  Future removeCategory(
      String budgetID, String categoryID, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budgetID)
        .collection('categories')
        .doc(categoryID)
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

  Stream<QuerySnapshot> streamCategories(BuildContext context) {
    var categoryQuery = FirebaseFirestore.instance
        .collection('DefaultCategories')
        .where(
          'userID',
          whereIn: [
            'default',
            Provider.of<Auth>(context).getUserId(),
          ],
        )
        .orderBy('title')
        .snapshots();
    return categoryQuery;
  }

  Stream<QuerySnapshot> streamCategoriesWithoutGoal(BuildContext context) {
    var categoryQuery = FirebaseFirestore.instance
        .collection('DefaultCategories')
        .where(
          'userID',
          whereIn: [
            'default',
            Provider.of<Auth>(context).getUserId(),
          ],
        )
        .where('title', isNotEqualTo: 'Goal')
        .orderBy('title')
        .snapshots();
    return categoryQuery;
  }
}
