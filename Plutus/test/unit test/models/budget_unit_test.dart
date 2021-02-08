import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:Plutus/models/categories.dart';

void main() {
  Transaction t1, t2, t3, t4;

  t1 = Transaction(
    id: 't1',
    title: 'Coffee',
    amount: 3.45,
    category: MainCategory.home,
  );

  t2 = Transaction(
    id: 't2',
    title: 'Shirt',
    amount: 10.96,
    category: MainCategory.bills_and_utilities,
  );

  t3 = Transaction(
    id: 't4',
    title: 'Movies',
    amount: 25.35,
    category: MainCategory.home,
  );

  t4 = Transaction(
    id: 't5',
    title: 'Shoes',
    amount: 35.85,
    category: MainCategory.food_and_drinks,
  );

  group('getRemainingAmount', () {
    test('Test if remaining amount is accurate', () {
      double value = 1000;
      double tempAmount = 500;
      Budget().remainingMonthlyAmount = value - tempAmount;

      expect(Budget().remainingAmount, Budget().remainingMonthlyAmount);
    });

    test('Amount Comparison Test', () {
      Budget ogAmount = Budget();
      List<Transaction> newAmount = new List<Transaction>();

      ogAmount.transactions = [t2, t4];
      newAmount = [t2, t4];

      expect(ogAmount.transactions, newAmount);

      newAmount = [t1, t3];
      expect(ogAmount.transactions, isNot(newAmount));
    });

    test('Amount Null Test', () {
      Budget ogAmount = Budget();
      List<Transaction> newAmount = new List<Transaction>();

      ogAmount.transactions = [null];
      newAmount = [null];
      expect(ogAmount.transactions, newAmount);

      newAmount = [t1, t3];
      expect(ogAmount.transactions, isNot(newAmount));
    });
  });

  group('getCategoryTransactions', () {
    test('List test', () {
      Budget ogList = Budget();
      List<Transaction> newList = new List<Transaction>();

      ogList.transactions = [t1, t2, t3, t4];
      newList = [t1, t3];

      expect(
          ogList.getCategoryTransactions(ogList, MainCategory.home), newList);
      expect(
          ogList.getCategoryTransactions(ogList, MainCategory.food_and_drinks),
          isNot(newList));
    });
  });

  group('getCategoryTransactionsAmount', () {
    test('Test for null', () {
      Budget transaction = Budget();
      transaction.transactions = null;
      expect(
          transaction.getCategoryTransactionsAmount(transaction, null), 0.00);
    });
  });
}
