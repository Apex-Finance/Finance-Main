import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';

class Goal {
  String id; // (db will generate primary key; just need to obtain it from db)
  String title;
  double amount;
  double goalAmount;

  // Call this function to set the data when you have gathered all the value for creating a goal
  Goal({
    this.title,
    this.amount,
    this.goalAmount,
  });

  // will need to add databse code to obtain id from document
  void setID(String Id) {
    id = Id;
  }

  String getID() {
    return id;
  }

  String getTitle() {
    return title;
  }

  double getAmount() {
    return amount;
  }

  double getGoalAmount() {
    return goalAmount;
  }
}

// This class will be handling all database code; it will essentially be acting like the provider we used for budgets
class GoalDataProvider with ChangeNotifier {
  void addGoal(Goal goal, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc()
        .set({
      'title': goal.getTitle(),
      'amount': goal.getAmount(),
      'goalAmount': goal.getGoalAmount(),
    });
  }

  void updateGoal(Goal goal, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc(goal.getID())
        .set({
      'title': goal.getTitle(),
      'amount': goal.getAmount(),
      'goalAmount': goal.getGoalAmount(),
    }, SetOptions(merge: true));
  }

  void removeGoal(Goal goal, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc(goal.getID())
        .delete();
  }
}
