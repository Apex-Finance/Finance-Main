import 'package:flutter/foundation.dart';

import './transaction.dart';
import './categories.dart';

class Budget {
  String id;
  String title;
  String category; // TODO Needs to be deleted later
  double amount;
  List<Transaction> transactions;
  Map<MainCategory, double> categoryAmount;

  Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
    @required this.transactions,
    @required this.categoryAmount,
  });
}
