import 'package:Plutus/models/categories.dart';

import './categories.dart';

class Category {
  String id;
  MainCategory categoryName;
  double amount;
  double remainingAmount;

  Category({this.id, this.categoryName, this.amount});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'amount': amount,
      'remainingAmount': remainingAmount,
    };
  }
}
