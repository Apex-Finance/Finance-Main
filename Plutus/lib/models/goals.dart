// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Imported Plutus files
import '../providers/auth.dart';

class Goal {
  String id; // (db will generate primary key; just need to obtain it from db)
  String title; // Goal title
  double amountSaved; // Amount currently saved up
  double goalAmount; // Total amount of goal
  DateTime dateOfGoal; // Date goal was set

  Goal.empty();

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

  double getAmountSaved(BuildContext context, QuerySnapshot snapshot) {
    amountSaved = 0;
    for (var doc in snapshot.docs) {
      amountSaved += doc.data()['amount'];
    }
    // TODO Find out why this is commented out
    // goalTransactions.listen((snapshot) {
    //   if (snapshot.docs.isNotEmpty) {
    //     print(snapshot.docs.length);
    //     snapshot.docs.forEach((doc) {
    //       var amount = doc.data()['amount'];
    //       print("amount  $amount");
    //       amountSaved += amount;
    //       count += 1;
    //       print("$count count");
    //     });
    //   }
    // });
    return amountSaved;
  }

  void setGoalAmount(double amountValue) {
    amountSaved = 0;
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
    goal.setTitle(doc.data()['title']);
    goal.setGoalAmount(doc.data()['goalAmount']);
    goal.setDate(doc.data()['dateOfGoal'].toDate());

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
      'goalAmount': goal.getGoalAmount(),
      'dateOfGoal': goal.getDate(),
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
        'goalAmount': goal.getGoalAmount(),
        'dateOfGoal': goal.getDate(),
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

  Stream<QuerySnapshot> getUpcomingGoals(BuildContext context, int count) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Auth>(context, listen: false).getUserId())
        .collection('Goals')
        .orderBy('dateOfGoal', descending: true)
        .limit(count)
        .snapshots();
  }
}
