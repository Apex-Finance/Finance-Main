import 'package:flutter/foundation.dart';

import './transaction.dart';

class Budget {
  final String id;
  final String title;
  final String category;
  final double amount;
  final List<Transaction> transactions;

  const Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
    this.transactions,
  });
}
