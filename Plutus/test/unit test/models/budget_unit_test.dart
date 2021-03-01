import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:Plutus/models/categories.dart';

void main() {
  Transaction t1, t2, t3, t4;

  t1 = Transaction(
    'a',
    'Coffee',
    DateTime.now(),
    'home',
    3.45,
  );
  t2 = Transaction(
    'b',
    'Shirt',
    DateTime.now(),
    'bills_and_utilities',
    10.96,
  );
  t3 = Transaction(
    'c',
    'Movies',
    DateTime.now(),
    'home',
    25.35,
  );
  t4 = Transaction(
    'd',
    'Shoes',
    DateTime.now(),
    'food_and_drinks',
    35.85,
  );

  group('getRemainingAmount', () {
    test('Test if remaining amount is accurate', () {
      double value = 1000;
      double tempAmount = 500;
      Budget().setremainingMonthlyAmount = value - tempAmount;

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
