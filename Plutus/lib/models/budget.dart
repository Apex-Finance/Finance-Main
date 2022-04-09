// Imported Flutter packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

// Imported Plutus files
import '../providers/auth.dart';

class Budget {
  String _id;
  String _title;
  double _amount;
  DateTime _date;
  double _remainingMonthlyAmount = 0;
  double _remainingAmountNew;

  double categoryAmount = 0;

  Budget.empty();

  Budget();

  Budget.copy(Budget budgetCopied) {
    _id = budgetCopied.getID();
    _amount = budgetCopied.getAmount();
    _date = budgetCopied.getDate();
  }

  double getRemainingAmountNew() {
    return _remainingAmountNew;
  }

  void setRemainingAmountNew(remainingAmountNew) {
    _remainingAmountNew = remainingAmountNew;
  }

  void calculateRemainingAmountNew() {
    _remainingAmountNew = _amount - categoryAmount;
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
    _remainingMonthlyAmount = amountValue;
  }

  double getAmount() {
    return _amount;
  }

  void calculateRemainingAmount(double budgetExpenses) {
    _remainingMonthlyAmount = _amount;
    _remainingMonthlyAmount -= budgetExpenses;
  }

  double getRemainingAmount() {
    return _remainingMonthlyAmount;
  }

  void setDate(DateTime dateValue) {
    _date = dateValue;
  }

  DateTime getDate() {
    return _date;
  }
}

class BudgetDataProvider with ChangeNotifier {
  Budget initializeBudget(DocumentSnapshot doc) {
    var budget = new Budget.empty();

    budget.setID(doc.id);
    budget.setTitle(doc.get('title'));
    budget.setAmount(doc.get('amount'));
    budget.setDate(doc.get('date').toDate());

    return budget;
  }

  Stream<QuerySnapshot> getmonthlyBudget(BuildContext context, DateTime date) {
    var budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .where(
          'date',
          isEqualTo: DateTime(date.year, date.month),
        )
        .snapshots();
    return budgetRef;
  }

  Stream<QuerySnapshot> getBudgetCategories(
      BuildContext context, String budgetID) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budgetID)
        .collection('categories')
        .orderBy('title')
        .snapshots();
  }

  Future addBudget(Budget budget, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .add({
      'date': budget.getDate(),
      'amount': budget.getAmount(),
    }).then((docRef) => {budget.setID(docRef.id)});
    notifyListeners();
  }

  Future editBudget(Budget budget, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budget.getID())
        .set({
      'date': budget.getDate(),
      'amount': budget.getAmount(),
    }, SetOptions(merge: true));
  }

  void deleteBudget(String budgetID, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .doc(budgetID)
        .delete();
  }
}
