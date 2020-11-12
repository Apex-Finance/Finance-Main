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

//TODO MAKE SURE FUTURE FUNCTIONS FILTER OUT CATEGORIES WITH AMOUNTS OF 0

  void setCategoryAmount(MainCategory category, double amount) {
    categoryAmount[category] = amount;
    notifyListeners();
  }

  Budget({
    this.id,
    this.title,
    this.amount,
    this.transactions,
    this.categoryAmount,
  });
}

//TODO add transactionsbyBudgetandCategory, totalBudgetExpensesByCategory, totalBudgetExpenses
class Budgets with ChangeNotifier {
  List<Budget> _budgets = [];
  MonthChanger monthChanger;

  Budgets(this.monthChanger, this._budgets);
  List<Budget> get budgets => [..._budgets];

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
