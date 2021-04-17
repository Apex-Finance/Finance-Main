// Imported Flutter packages
import 'package:flutter/foundation.dart';
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

  double categoryAmount = 0;

  Budget.empty();

  Budget();

  double getRemainingAmountNew() {
    return _amount - categoryAmount;
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

  // TODO Find out why this is commented out
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
    budget.setDate(doc.data()['date'].toDate());

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
        .snapshots();
  }

  void addBudget(Budget budget, BuildContext context) async {
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

  void editBudget(Budget budget, BuildContext context) async {
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

  Future<String> getBudgetID(DateTime date, BuildContext context) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Budgets')
        .where(
          'date',
          isEqualTo: DateTime(date.year, date.month),
        )
        .get()
        .then((querySnapshot) => querySnapshot.docs.first.id);
  }
  // TODO Find out why this is commented out
  // String getBudgetID(DateTime date, BuildContext context) {
  //   var something = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(Provider.of<Auth>(context, listen: false).getUserId())
  //       .collection('budgets')
  //       .where('date', isEqualTo: date)
  //       .snapshots()
  //       .first;

  //   something.whenComplete((item) => return item)
  // }
}
