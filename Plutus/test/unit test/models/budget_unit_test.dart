import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:Plutus/models/categories.dart';

void main() {
  Transaction t1 = Transaction();
  Transaction t2 = Transaction();
  Transaction t3 = Transaction();
  Transaction t4 = Transaction();

  t1.setTitle('Coffee');
  t1.setAmount(3.45);
  t1.setDate(DateTime.now());
  t1.setCategoryId('home');

  t2.setTitle('Shirt');
  t2.setAmount(10.96);
  t2.setDate(DateTime.now());
  t2.setCategoryId('bills_and_utilities');

  t3.setTitle('Movies');
  t3.setAmount(25.35);
  t3.setDate(DateTime.now());
  t3.setCategoryId('home');

  t4.setTitle('Shoes');
  t4.setAmount(35.85);
  t4.setDate(DateTime.now());
  t4.setCategoryId('food_and_drinks');

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
      expect(t1.getCategoryId(), t1.getCategoryId());
      expect(t1.getCategoryId(), isNot(t2.getCategoryId()));
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
