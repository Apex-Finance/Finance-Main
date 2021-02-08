import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../providers/auth.dart';

class Goal {
  String _id; // (db will generate primary key; just need to obtain it from db)
  String _title; // Goal title
  double _amountSaved; // Amount currently saved up
  double _goalAmount; // Total amount of goal
  DateTime _dateOfGoal; // Date goal was set

  // Call this function to set the data when you have gathered all the value for creating a goal

  // will need to add databse code to obtain id from document
  void setID(String idValue) {
    _id = idValue;
  }

  String getID() {
    return _id;
  }

  void setTitle(String titleValue) {
    _title = titleValue;
  }

  String getTitle() {
    return _title;
  }

  void setAmountSaved(double amountValue) {
    _amountSaved = amountValue;
  }

  double getAmountSaved() {
    return _amountSaved;
  }

  void setGoalAmount(double amountValue) {
    _goalAmount = amountValue;
  }

  double getGoalAmount() {
    return _goalAmount;
  }

  void setDate(DateTime dateValue) {
    _dateOfGoal = dateValue;
  }

  DateTime getDate() {
    return _dateOfGoal;
  }
}

// This class will be handling all database code; it will essentially be acting like the provider we used for budgets
class GoalDataProvider with ChangeNotifier {
  // Initialize a goal with the document data
  Goal initializeGoal(DocumentSnapshot doc) {
    Goal goal;

    goal.setID(doc.id);
    goal.setAmountSaved(doc.data()['amountSaved']);
    goal.setTitle(doc.data()['title']);
    goal.setGoalAmount(doc.data()['goalAmount']);
    goal.setDate(doc.data()['date']);

    return goal;
  }

  void addGoal(Goal goal, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc()
        .set({
      'title': goal.getTitle(),
      'amountSaved': goal.getAmountSaved(),
      'goalAmount': goal.getGoalAmount(),
      'date': goal.getDate(),
    });
  }

  void updateGoal(Goal goal, BuildContext context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .doc(goal.getID())
        .set(
      {
        'title': goal.getTitle(),
        'amount': goal.getAmountSaved(),
        'goalAmount': goal.getGoalAmount(),
      },
      SetOptions(merge: true),
    );
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
