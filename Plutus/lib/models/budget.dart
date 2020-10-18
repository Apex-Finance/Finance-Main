import 'package:flutter/foundation.dart';

import './transaction.dart';

class Budget {
  String id;
  String title;
  String category;
  double amount;
  List<Transaction> transactions;

  Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
    @required this.transactions,
  });
}
