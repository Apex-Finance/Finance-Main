import 'package:Plutus/models/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './categories.dart';

class Category {
  int codepoint;
  String id;
  String title;
  MainCategory categoryName;
  double amount;
  double remainingAmount;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
      'amount': amount,
      'remainingAmount': remainingAmount,
    };
  }
}

class CategoryDataProvider {
  Category initializeCategory(DocumentSnapshot doc) {
    Category category;

    return category;
  }
}
