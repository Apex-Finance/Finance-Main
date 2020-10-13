import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/tab_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/budget_screen.dart';
import './screens/transaction_screen.dart';
import './screens/goal_screen.dart';

// TEST FOR PUSH

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plutus',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
        accentColor: Colors.white,
        canvasColor: Colors.black,
        textTheme: GoogleFonts.latoTextTheme(TextTheme(
          bodyText1: TextStyle(
            color: Colors.amber,
          ),
        )),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TabScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        BudgetScreen.routeName: (context) => BudgetScreen(),
        TransactionScreen.routeName: (context) => TransactionScreen(),
        GoalScreen.routeName: (context) => GoalScreen(),
      },
    );
  }
}
