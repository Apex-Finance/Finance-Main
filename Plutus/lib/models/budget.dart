import 'package:flutter/foundation.dart';

import './transaction.dart';
import './categories.dart';
import './month_changer.dart';

class Budget with ChangeNotifier {
  String id;
  String title;
  double amount;
  List<Transaction> transactions;
  Map<MainCategory, double> categoryAmount;

  double get remainingAmount {
    double tempAmount = amount;
    if (categoryAmount != null)
      categoryAmount.forEach((key, value) {
        tempAmount -= value;
      });
    return tempAmount;
  }

  void setCategoryAmount(MainCategory category, double amount) {
    if (amount > 0) {
      categoryAmount[category] = amount;
      notifyListeners();
    }
  }

  List<Transaction> getCategoryTransactions(
      Budget budget, MainCategory category) {
    return budget.transactions == null
        ? null
        : budget.transactions
            .where((transaction) => transaction.category == category)
            .toList();
  }

  double getCategoryTransactionsAmount(Budget budget, MainCategory category) {
    List<Transaction> categoryTransactions =
        getCategoryTransactions(budget, category);
    if (categoryTransactions == null)
      return 0.00;
    else {
      var sum = 0.0;
      for (var transaction in categoryTransactions) {
        sum += transaction.amount;
      }
      return sum;
    }
  }

  Budget({
    this.id,
    this.title,
    this.amount,
    this.transactions,
    this.categoryAmount,
  });
}

class Budgets with ChangeNotifier {
  List<Budget> _budgets = [];
  MonthChanger monthChanger;
  List<Transaction> monthlyTransactions;

  Budgets(this.monthChanger, this.monthlyTransactions, this._budgets);
  List<Budget> get budgets => [..._budgets];

  Budget get monthlyBudget {
    var budgetWithTransactions = budgets.firstWhere(
      (budget) =>
          DateTime.parse(budget.title).month == monthChanger.selectedMonth &&
          DateTime.parse(budget.title).year == monthChanger.selectedYear,
      orElse: () => null,
    );
    if (budgetWithTransactions != null)
      budgetWithTransactions.transactions = monthlyTransactions;
    return budgetWithTransactions;
  }

  void addBudget(Budget budget) {
    _budgets.add(budget);
    notifyListeners();
  }

  void editBudget(String id, Budget updatedBudget) {
    final budgetIndex = _budgets.indexWhere((budget) => budget.id == id);
    if (budgetIndex >= 0) {
      _budgets[budgetIndex] = updatedBudget;
      notifyListeners();
    }
  }

  void deleteBudget(String id) {
    final budgetIndex = _budgets.indexWhere((budget) => budget.id == id);
    _budgets.removeAt(budgetIndex);
    notifyListeners();
  }
}
