import 'package:flutter/foundation.dart';

import './transaction.dart';
import './categories.dart';

class Budget {
  String id;
  String title;
  String category; // TODO Needs to be deleted later
  double amount;
  List<Transaction> transactions;
  Map<MainCategory, double> categoryAmount;

  Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
    @required this.transactions,
    @required this.categoryAmount,
  });
}

//TODO add transactionsbyBudgetandCategory, totalBudgetExpensesByCategory, totalBudgetExpenses
class Budgets with ChangeNotifier {
  List<Budget> _budgets = [];

  List<Budget> get budgets => [..._budgets];

  // double get remainingAmount(Budget budget) {
  //   for (var categoryItem in budget.categoryAmount) {
  //     amount -=categoryItem
  //   }
  // };

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
