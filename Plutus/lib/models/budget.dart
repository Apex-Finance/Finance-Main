import 'package:flutter/foundation.dart';

import './transaction.dart';


class Budget {
  String id;
  String title;
  String category;
  double amount;
  List<Transaction> transactions;
}
