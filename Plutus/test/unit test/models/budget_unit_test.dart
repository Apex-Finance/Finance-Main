import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/models/transaction.dart';

void main() {
  Transaction t1, t2; //, t3, t4;

  t1 = Transaction(
    id: 'a',
    title: 'Coffee',
    date: DateTime.now(),
    categoryId: 'home',
    categoryTitle: 'home',
    categoryCodepoint: 5,
    amount: 3.45,
  );
  t2 = Transaction(
    id: 'b',
    title: 'Shirt',
    date: DateTime.now(),
    categoryId: 'bills_and_utilities',
    categoryTitle: 'bills_and_utilities',
    categoryCodepoint: 5,
    amount: 10.96,
  );
  // t3 = Transaction(
  //   id: 'c',
  //   title: 'Movies',
  //   date: DateTime.now(),
  //   categoryId: 'home',
  //   categoryTitle: 'home',
  //   categoryCodepoint: 5,
  //   amount: 25.35,
  // );
  // t4 = Transaction(
  //   id: 'd',
  //   title: 'Shoes',
  //   date: DateTime.now(),
  //   categoryId: 'food_and_drinks',
  //   categoryTitle: 'food_and_drinks',
  //   categoryCodepoint: 5,
  //   amount: 35.85,
  //);

  group('getRemainingAmount', () {
    test('Test if remaining amount is accurate', () {
      double budgetAmount = 1000;
      double remainingMonthlyAmount = 400;
      double budgetExpenses = 600;
      Budget testBudget = Budget.empty();

      testBudget.setAmount(budgetAmount);
      testBudget.calculateRemainingAmount(budgetExpenses);

      expect(testBudget.getRemainingAmount(), remainingMonthlyAmount);

      expect(testBudget.getRemainingAmount(), isNot(0));
    });
  });

  group('getCategoryTransactions', () {
    test('List test', () {
      expect(t1.getCategoryId(), t1.getCategoryId());
      expect(t1.getCategoryId(), isNot(t2.getCategoryId()));
    });
  });
}
