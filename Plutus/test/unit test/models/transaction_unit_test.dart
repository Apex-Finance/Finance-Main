import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/transaction.dart';

void main() {
  Transaction ogTransaction = Transaction();
  Transaction newTransaction = Transaction();
  group('initializeTransaction', () {
    test('Test string comparison', () {
      ogTransaction.setID('1');
      ogTransaction.setTitle('Jedi');
      ogTransaction.setCategoryId('entertainment');
      ogTransaction.setAmount(10000.00);
      ogTransaction.setDate(DateTime.now());

      newTransaction.setID('1');
      newTransaction.setTitle('Jedi');
      newTransaction.setCategoryId('entertainment');
      newTransaction.setAmount(10000.00);
      newTransaction.setDate(DateTime.now());

      expect(ogTransaction.getID(), newTransaction.getID());
      expect(ogTransaction.getTitle(), newTransaction.getTitle());
      expect(ogTransaction.getCategoryId(), newTransaction.getCategoryId());
      expect(ogTransaction.getAmount(), newTransaction.getAmount());
      expect(ogTransaction.getDate(), newTransaction.getDate());
    });

    test('Test Transaction for null', () {
      expect(ogTransaction.getID(), isNot(null));
      expect(newTransaction.getID(), isNot(null));
    });
  });
  group('getTransactionExpenses', () {
    Transaction t1 = Transaction();
    Transaction t2 = Transaction();
    Transaction t3 = Transaction();
    Transaction t4 = Transaction();

    test('Test accurate totals', () {
      double testTotalExpenses = 0;

      t1.setAmount(1.00);
      t2.setAmount(5.00);
      t3.setAmount(10.00);
      t4.setAmount(20.00);

      testTotalExpenses =
          t1.getAmount() + t2.getAmount() + t3.getAmount() + t4.getAmount();

      expect(testTotalExpenses, 36.00);
      expect(testTotalExpenses, isNot(0.00));
    });
    
    test('Test double type convert', () {
      double testDouble;
      int value;

      value = 4;
      value.toDouble();

      t1.setAmount(1);
      t2.setAmount(3);

      testDouble = t1.getAmount() + t2.getAmount();

      expect(testDouble, 4.00);
      expect(testDouble, value);
    });
  });
}
