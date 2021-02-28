import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import './transaction.dart' as Transaction;
import './categories.dart';
import './month_changer.dart';
import '../providers/auth.dart';

class Budget {
  String _id;
  String _title;
  double _amount;
  DateTime _date;
  Map<MainCategory, double> categoryAmount;
  double _remainingMonthlyAmount;

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

  void setRemainingAmount(double budgetTransactionExpenses) {
    _remainingMonthlyAmount = getAmount() - budgetTransactionExpenses;
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

  List<Transaction.Transaction> getCategoryTransactions(
      Budget budget, MainCategory category) {
    return budget.transactions == null
        ? null
        : budget.transactions
            .where((transaction) => transaction.getCategoryId() == category)
            .toList();
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

  List<MainCategory> get budgetedCategory {
    return MainCategory.values
        .where((category) => categoryAmount[category] != null)
        .toList();
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

  List<MainCategory> get budgetedAndUnbudgetedCategories {
    return budgetedCategory;
  }
}

class BudgetDataProvider with ChangeNotifier {
  // List<Budget> _budgets = [];
  MonthChanger monthChanger;
  Transaction.Transactions transactions;

  Budget get monthlyBudget {
    var budgetWithTransactions = budgets.firstWhere(
      (budget) =>
          DateTime.parse(budget.title).month == monthChanger.selectedMonth &&
          DateTime.parse(budget.title).year == monthChanger.selectedYear,
      orElse: () => Budget(
          id: null,
          title: null,
          amount: null,
          transactions: null,
          categoryAmount: null),
    );
    if (budgetWithTransactions.amount != null) {
      //b/c of the way data is set up, initializing properties here, but should eventually be getters in Budget Provider
      budgetWithTransactions.transactions = monthlyTransactions;
      budgetWithTransactions.remainingMonthlyAmount =
          budgetWithTransactions.amount - transactions.monthlyExpenses;
    }
    return budgetWithTransactions;
  }

  void setCategoryAmount(
      MainCategory category, double amount, BuildContext context) async {
    String categoryId = category.toString().split('.').last;
    if (amount > 0) {
      setCategoryToDB(categoryId, amount, context);
      monthlyBudget.categoryAmount[category] = amount;
    }
    if (amount == 0) {
      monthlyBudget.categoryAmount.remove(category);
      removeCategoryFromDB(categoryId, amount, context);
    }
    notifyListeners();
  }

  void addBudget(Budget budget, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('budgets')
        .doc(budget.getID())
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
