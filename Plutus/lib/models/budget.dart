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

  double remainingMonthlyAmount;

  double get remainingAmount {
    double tempAmount = amount;
    if (categoryAmount != null)
      categoryAmount.forEach((key, value) {
        tempAmount -= value;
      });
    // tempAmount = num.parse(tempAmount.toStringAsFixed(2));
    // if (tempAmount.isNegative) tempAmount *= -1; //temp fix for -0.00
    return tempAmount;
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

  List<MainCategory> get budgetedCategory {
    return MainCategory.values
        .where((category) => categoryAmount[category] != null)
        .toList();
  }

  void setUnbudgetedCategory() {
    // adds categories that were not budgeted but expenses were made
    for (var transaction in transactions)
      if (categoryAmount[transaction.category] == null)
        categoryAmount[transaction.category] = 0.00;
    notifyListeners();
  }

  List<MainCategory> get budgetedAndUnbudgetedCategories {
    setUnbudgetedCategory();
    return budgetedCategory;
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
  Transactions transactions;
  List<Transaction> get monthlyTransactions => transactions.monthlyTransactions;

  Budgets(this.monthChanger, this.transactions, this._budgets);
  List<Budget> get budgets => [..._budgets];

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

  void setCategoryAmount(MainCategory category, double amount) {
    if (amount > 0) {
      monthlyBudget.categoryAmount[category] = amount;
    }
    if (amount == 0) {
      monthlyBudget.categoryAmount.remove(category);
    }
    notifyListeners();
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
