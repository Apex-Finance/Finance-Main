import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './transaction.dart' as Transaction;
import './categories.dart';
import './month_changer.dart';
import '../providers/auth.dart';
import '../models/category.dart' as Category;

class Budget {
  String _id;
  String _title;
  double _amount;
  DateTime _date;
  double _remainingMonthlyAmount;

  Budget.empty();

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

  void setRemainingAmount(double budgetExpenses) {
    _remainingMonthlyAmount = getAmount() - budgetExpenses;
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

  // void setUnbudgetedCategory() {
  //   // adds categories that were not budgeted but expenses were made
  //   for (var transaction in transactions)
  //     if (categoryAmount[transaction.category] == null)
  //       categoryAmount[transaction.category] = 0.00;
  //   notifyListeners();
  // }

  // static Budget getMonthlyBudget() {
  //   MonthChanger monthChanger;
  //   Transaction.Transactions transactions;
  //   List<Transaction.Transaction> monthlyTransactions =
  //       transactions.monthlyTransactions;
  //   var budgetWithTransactions = budgets.firstWhere(
  //     (budget) =>
  //         DateTime.parse(budget.title).month == monthChanger.selectedMonth &&
  //         DateTime.parse(budget.title).year == monthChanger.selectedYear,
  //     orElse: () => Budget(
  //         id: null,
  //         title: null,
  //         amount: null,
  //         transactions: null,
  //         categoryAmount: null),
  //   );
  //   if (budgetWithTransactions.amount != null) {
  //     //b/c of the way data is set up, initializing properties here, but should eventually be getters in Budget Provider
  //     budgetWithTransactions.transactions = monthlyTransactions;
  //     budgetWithTransactions.remainingMonthlyAmount =
  //         budgetWithTransactions.amount - transactions.monthlyExpenses;
  //   }
  //   return budgetWithTransactions;
  // }

  // List<MainCategory> get budgetedAndUnbudgetedCategories {
  //   return budgetedCategory;
  // }
}

class BudgetDataProvider with ChangeNotifier {
  Budget initializeBudget(DocumentSnapshot doc) {
    var budget = new Budget.empty();

    budget.setID(doc.id);
    budget.setTitle(doc.data()['title']);
    budget.setAmount(doc.data()['amount']);
    budget.setDate(doc.data()['date']);

    return budget;
  }

  Stream<QuerySnapshot> getmonthlyBudget(BuildContext context, DateTime date) {
    var budgetRef = FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budget')
        .where('date', isGreaterThanOrEqualTo: DateTime(date.year, date.month))
        .snapshots();
    return budgetRef;
  }

  void getBudget(BuildContext context, DateTime date) async {
    var budgetRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budget')
        .where('date', isGreaterThanOrEqualTo: DateTime(date.year, date.month))
        .get();
    print("budgets found: ${budgetRef.docs.length}");
  }

  void addBudget(Budget budget, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc()
        .set({
      'title': budget.getTitle(),
      'amount': budget.getAmount(),
    });
    notifyListeners();
  }

  void editBudget(Budget budget, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budget.getID())
        .set({
      'title': budget.getTitle(),
      'amount': budget.getAmount(),
    }, SetOptions(merge: true));
  }

  void deleteBudget(String budgetID, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budgetID)
        .delete();
  }
}
