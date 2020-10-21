import 'package:flutter/foundation.dart';

class Budget {
  String id;
  String title;
  String category;
  double amount;

  Budget({
    @required this.id,
    @required this.title,
    @required this.category,
    @required this.amount,
  });
}
