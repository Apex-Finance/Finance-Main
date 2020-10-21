import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final String category;
  /* this will be treated like an id to 
     compare to the actual category id and
     a budget with the same category id */
  final double amount;
  final DateTime date;

  const Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    this.date,
    @required this.category,
  });
}
