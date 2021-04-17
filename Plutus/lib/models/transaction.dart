// Imported Flutter packages
import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../providers/auth.dart';
import '../models/goals.dart';

class Transaction {
  String _id;
  String _title;
  String _categoryId;
  /* this will be treated like an id to 
     compare to the actual category id and
     a budget with the same category id */
  String _categoryTitle; // retrieve from corresponding category in db
  int _categoryCodePoint; // Int value to display icon for category
  double _amount;
  DateTime _date;

  Transaction.empty();

  Transaction({
    @required String id,
    @required String title,
    @required DateTime date,
    @required String categoryId,
    @required double amount,
    @required String categoryTitle,
    @required int categoryCodepoint,
  }) {
    _id = id;
    _title = title;
    _date = date;
    _amount = amount;
    _categoryId = categoryId;
    _categoryTitle = categoryTitle;
    _categoryCodePoint = categoryCodepoint;
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
    return new Transaction(
      id: doc.id,
      title: doc.data()['title'],
      date: doc.data()['date'].toDate(),
      categoryId: doc.data()['categoryID'],
      categoryTitle: doc.data()['categoryTitle'],
      categoryCodepoint: doc.data()['categoryCodepoint'],
      amount: doc.data()['amount'],
    );
  }

  void addTransaction(
      {@required Transaction transaction,
      @required BuildContext context,
      String goalID}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .doc()
        .set({
      'title': transaction.getTitle(),
      'amount': transaction.getAmount(),
      'date': transaction.getDate(),
      'categoryID': transaction.getCategoryId(),
      'categoryTitle': transaction.getCategoryTitle(),
      'categoryCodepoint': transaction.getCategoryCodePoint(),
      'goalID': goalID,
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
        'categoryID': transaction.getCategoryId(),
        'categoryTitle': transaction.getCategoryTitle(),
        'categoryCodepoint': transaction.getCategoryCodePoint(),
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

  double getTransactionExpenses(QuerySnapshot snapshot) {
    double totalExpenses = 0;

    snapshot.docs.forEach((doc) {
      if (doc.data()['amount'] == null)
        totalExpenses += 0;
      else
        totalExpenses += doc.data()['amount'];
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
    // TODO Find out why this is commented out
    // final transactionIndex =
    //     _transactions.indexWhere((transaction) => transaction.id == id);
    // _transactions.removeAt(transactionIndex);
    notifyListeners();
  }

  // TODO Find out why this is commented out
  // // Take all transactions, filter out only the ones from the selected month, and reverse the order from newest to oldest
  // List<Transaction> getMonthlyTransactions() {
  //   var unsorted = _transactions
  //       .where((transaction) =>
  //           transaction.getDate().month == monthChanger.selectedMonth &&
  //           transaction.getDate().year == monthChanger.selectedYear)
  //       .toList();
  //   unsorted.sort((a, b) => (b.getDate()).compareTo(a.getDate()));
  //   return unsorted;
  // }

  Query getMonthlyTransactions(BuildContext context, DateTime date) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .where(
          'date',
          isGreaterThanOrEqualTo: DateTime(
            date.year,
            date.month,
            1,
          ),
          isLessThan: DateTime(
            date.year,
            date.month + 1,
            1,
          ),
        )
        .orderBy('date',
            descending: true); // sorts transactions from newest to oldest
  }

  Stream<QuerySnapshot> getCategoryTransactions(
      String categoryID, DateTime budgetDate, BuildContext context) {
    var snapshot = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .where('categoryID', isEqualTo: categoryID)
        .where(
          'date',
          isGreaterThanOrEqualTo: DateTime(
            budgetDate.year,
            budgetDate.month,
            1,
          ),
          isLessThan: DateTime(
            budgetDate.year,
            budgetDate.month + 1,
            1,
          ),
        )
        .snapshots();
    return snapshot;
  }

  Stream<QuerySnapshot> getGoalTransactions(
      BuildContext context, String goalID) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .where('goalID', isEqualTo: goalID)
        .snapshots();
  }

  void updateGoalTransactions(Goal goal, BuildContext context) async {
    var goalTransactions = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .where('goalID', isEqualTo: goal.getID())
        .get();
    try {
      for (var doc in goalTransactions.docs) {
        await doc.reference.set(
          {'title': goal.getTitle()},
          SetOptions(merge: true),
        );
      }
    } catch (e) {
      print(e.toString());
    }
    // TODO Find out why this is commented out
    // goalTransactions.forEach((transactionSnapshot) {
    //   var transactions = transactionSnapshot.docs;
    //   transactions.forEach((transaction) {
    //     transaction.reference.set(
    //       {'title': goal.getTitle()},
    //       SetOptions(merge: true),
    //     );
    //   });
    // });
  }

  Stream<QuerySnapshot> getRecentTransactions(BuildContext context, int count) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Transactions')
        .orderBy("date", descending: true)
        .limit(count)
        .snapshots();
  }
  // TODO Find out why this is commented out
  // Sum the expenses for the month
  // double get monthlyExpenses {
  //   var sum = 0.00;
  //   for (var transaction in monthlyTransactions) {
  //     sum += transaction.getAmount();
  //   }
  //   return sum;
  // }
}
