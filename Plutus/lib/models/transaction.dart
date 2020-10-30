import 'package:flutter/foundation.dart';
import 'category.dart';

class Transaction {
  String id;
  String title;
  MainCategory category;
  /* this will be treated like an id to 
     compare to the actual category id and
     a budget with the same category id */
  double amount;
  DateTime date;

  Transaction({
    @required this.id,
    @required this.title,
    @required this.amount,
    this.date,
    @required this.category,
  });
}
