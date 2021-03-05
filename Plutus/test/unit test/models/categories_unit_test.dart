import 'package:Plutus/models/category.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Plutus/models/transaction.dart';

void main() {
  Transaction cat1 = Transaction();
  Transaction cat2 = Transaction();

  cat1.setCategoryId('HoMe');
  cat2.setCategoryId('BiLLs aNd UtIlities');

  test('If it returns lowercase with underscore', () {
    expect('home', cat1.getCategoryId().toLowerCase().replaceAll(' ', '_'));
    expect('Bills and Utilities',
        isNot(cat2.getCategoryId().toLowerCase().replaceAll(' ', '_')));
  });
}
