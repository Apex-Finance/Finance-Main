import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/transaction.dart';
import 'package:Plutus/models/categories.dart';

void main() {
  group('initializeTransaction', () {
    test('Test string comparison', () {
      Transaction ogTransaction{
        ogTransaction.id = '',
        ogTransaction.title = 'title', 
        ogTransaction.date = getDate();
      }
    })
  });

}