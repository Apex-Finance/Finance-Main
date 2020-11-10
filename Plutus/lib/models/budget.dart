import 'package:flutter/foundation.dart';

import './transaction.dart';
import './month_changer.dart';

class Budget {
  String id;
  String title;
  String category; //TODO update to MainCategory
  double amount;
  List<Transaction> transactions;

  Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
    @required this.transactions,
  });
}

//TODO add transactionsbyBudgetandCategory, totalBudgetExpensesByCategory, totalBudgetExpenses
class Budgets with ChangeNotifier {
  List<Budget> _budgets = [];
  MonthChanger monthChanger;

  Budgets(this.monthChanger, this._budgets);
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
