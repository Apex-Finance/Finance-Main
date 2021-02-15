import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/auth.dart';

class Goal {
  String id; // (db will generate primary key; just need to obtain it from db)
  String title; // Goal title
  double amountSaved; // Amount currently saved up
  double goalAmount; // Total amount of goal
  DateTime dateOfGoal; // Date goal was set

  // Call this function to set the data when you have gathered all the value for creating a goal
  Goal({
    this.title,
    this.amountSaved,
    this.goalAmount,
    this.dateOfGoal,
  });

  // will need to add databse code to obtain id from document
  void setID(String idValue) {
    id = idValue;
  }

  String getID() {
    return id;
  }

  void setDate(DateTime dateValue) {
    dateOfGoal = dateValue;
  }

  DateTime getDate() {
    return dateOfGoal;
  }

  void setTitle(String titleValue) {
    title = titleValue;
  }

  String getTitle() {
    return title;
  }

  void setAmountSaved(double amountValue) {
    amountSaved = amountValue;
  }

  double getAmount() {
    return amountSaved;
  }

  void setGoalAmount(double amountValue) {
    goalAmount = amountValue;
  }

  double getGoalAmount() {
    return goalAmount;
  }
}

// This class will be handling all database code; it will essentially be acting like the provider we used for budgets
class GoalDataProvider with ChangeNotifier {
  // Initialize a goal with the document data
  Goal initializeGoal(DocumentSnapshot doc) {
    Goal goal = Goal();

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
        .set(
      {
        'title': goal.getTitle(),
        'amount': goal.getAmount(),
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
