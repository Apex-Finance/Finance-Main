import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/foundation.dart';
import 'category.dart';

class Transaction {
  String id;
  String title;
  MainCategory category;
  /* this will be treated like an id to 
     compare to the actual category id and
     a budget with the same category id */
  double amount;
  DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    this.date,
    @required this.category,
  });
}

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [];
  MonthChanger monthChanger;

  Transactions(this.monthChanger, this._transactions);

  List<Transaction> get transactions => [..._transactions];

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  void editTransaction(Transaction updatedTransaction) {
    final transactionIndex = _transactions
        .indexWhere((transaction) => transaction.id == updatedTransaction.id);
    if (transactionIndex >= 0) {
      _transactions[transactionIndex] = updatedTransaction;
      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    final transactionIndex =
        _transactions.indexWhere((transaction) => transaction.id == id);
    _transactions.removeAt(transactionIndex);
    notifyListeners();
  }

  // Take all transactions, filter out only the ones from the selected month, and reverse the order from newest to oldest
  List<Transaction> get monthlyTransactions {
    var unsorted = _transactions
        .where((transaction) =>
            transaction.date.month == monthChanger.selectedMonth &&
            transaction.date.year == monthChanger.selectedYear)
        .toList();
    unsorted.sort((a, b) => (b.date).compareTo(a.date));
    return unsorted;
  }

  // Sum the expenses for the month
  double get monthlyExpenses {
    var sum = 0.00;
    for (var transaction in monthlyTransactions) {
      sum += transaction.amount;
    }
    return sum;
  }
}
