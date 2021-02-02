import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class Goal {
  int id; // will be random (how? figure this out)
  String title;
  double amount;
  double goalAmount;

  // Call this function to set the data when you have gathered all the value for creating a goal
  Goal({
    this.title,
    this.amount,
    this.goalAmount,
  });

  String getTitle() {
    return title;
  }

  double getAmount() {
    return amount;
  }

  double getGoalAmount() {
    return goalAmount;
  }

  void addGoalToDB(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc()
        .set({
      'title': getTitle(),
      'amount': getAmount(),
      'goalAmount': getGoalAmount(),
    });
  }
}
