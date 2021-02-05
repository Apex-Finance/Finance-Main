// Import the test package and Counter class
import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/models/transaction.dart';

void main() {
  group('Budget', () {
    test('Test if remaining amount is accurate', () {
      double value = 1000;
      double tempAmount = 500;
      Budget().remainingMonthlyAmount = value - tempAmount;

      expect(Budget().remainingAmount, Budget().remainingMonthlyAmount);
    });
  });
  group('getCategoryTransactionsAmount', () {
    test('Test for null', () {
      var sum = 0.0;
      for (var transaction in categoryTransactions) {
        sum += transaction.amount;
      expect(Budget().getCategoryTransactionsAmount(null, null), 0.00);
      expect(Budget().getCategoryTransactionsAmount(), sum);
    });

  });
}
