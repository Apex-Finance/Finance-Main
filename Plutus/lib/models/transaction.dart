import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class Transaction {
  String _id;
  String _title;
  double _amount;
  DateTime _date;
  String _categoryId;
  /* this will be treated like an id to 
     compare to the actual category id and
     a budget with the same category id */
  String _categoryTitle; // retrieve from corresponding category in db
  int _categoryCodePoint; // Int value to display icon for category
  
  Transaction.empty();

  Transaction(String id, String title, DateTime date, String categoryId, this._amount, {categoryTitle = ""}) {
    _id = id;
    _title = title;
    _date = date;
    _categoryId = categoryId;
    _categoryTitle = categoryTitle;
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

  void setCategoryId(String categoryIdValue) {
    _categoryId = categoryIdValue;
  }

  String getCategoryId() {
    return _categoryId;
  }

  void setCategoryTitle(String categoryTitleValue) async {
    _categoryTitle = categoryTitleValue;
  }

  String getCategoryTitle() {
    return _categoryTitle;
  }

  void setCategoryCodePoint(int codepoint) {
    _categoryCodePoint = codepoint;
  }

  int getCategoryCodePoint() {
    return _categoryCodePoint;
  }

  void setAmount(double amountValue) {
    _amount = amountValue;
  }

  double getAmount() {
    return _amount;
  }

  void setDate(DateTime dateValue) {
    _date = dateValue;
  }

  DateTime getDate() {
    return _date;
  }
}

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];
  MonthChanger monthChanger;

  Transactions(this.monthChanger, this._transactions);

  List<Transaction> get transactions => [..._transactions];

  Transaction initializeTransaction(DocumentSnapshot doc) {
    // Initialize a transaction with document data
    return new Transaction(doc.id, doc.data()['title'], doc.data()['date'].toDate(), doc.data()['category id'], doc.data()['amount'], categoryTitle: doc.data()['category title']);
  }

  void addTransaction(Transaction transaction, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .doc()
        .set({
      'title': transaction.getTitle(),
      'amount': transaction.getAmount(),
      'date': transaction.getDate(),
      'category id': transaction.getCategoryId(),
      'category title': transaction.getCategoryTitle(),
    });
  }

  void editTransaction(Transaction transaction, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .doc(transaction.getID())
        .set(
      {
        'title': transaction.getTitle(),
        'amount': transaction.getAmount(),
        'date': transaction.getDate(),
        'category id': transaction.getCategoryId(),
        'category title': transaction.getCategoryTitle(),
      },
      SetOptions(merge: true),
    );

    final transactionIndex = _transactions.indexWhere(
        (transaction) => transaction.getID() == transaction.getID());
    if (transactionIndex >= 0) {
      _transactions[transactionIndex] = transaction;
      notifyListeners();
    }
  }

  double getTransactionExpenses(AsyncSnapshot<QuerySnapshot> snapshot) {
    double totalExpenses = 0;

    snapshot.data.docs.forEach((doc) {
      totalExpenses += doc.data()['amount'].toDouble();
    });

    return totalExpenses;
  }

  void deleteTransaction(Transaction transaction, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .doc(transaction.getID())
        .delete();
    // final transactionIndex =
    //     _transactions.indexWhere((transaction) => transaction.id == id);
    // _transactions.removeAt(transactionIndex);
    notifyListeners();
  }

  // Take all transactions, filter out only the ones from the selected month, and reverse the order from newest to oldest
  List<Transaction> getMonthlyTransactions () {
    var unsorted = _transactions
        .where((transaction) =>
            transaction.getDate().month == monthChanger.selectedMonth &&
            transaction.getDate().year == monthChanger.selectedYear)
        .toList();
    unsorted.sort((a, b) => (b.getDate()).compareTo(a.getDate()));
    return unsorted;
  }
  void getCategoryTransactions(String categoryID) {
    var snapshot = FirebaseFirestore.instance
  }
  // Sum the expenses for the month
  double get monthlyExpenses {
    var sum = 0.00;
    for (var transaction in monthlyTransactions) {
      sum += transaction.getAmount();
    }
    return sum;
  }
}
