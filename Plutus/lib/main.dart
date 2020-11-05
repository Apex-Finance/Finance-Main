import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import './screens/intro_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/budget_screen.dart';
import './screens/transaction_screen.dart';
import './screens/goal_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Plutus',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: Colors.amber,
          primaryColorLight: Colors.amberAccent,
          accentColor: Colors.white,
          canvasColor: Colors.black,
          textTheme: GoogleFonts.latoTextTheme(
            TextTheme(
              bodyText1: TextStyle(
                color: Colors.amber,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => OnBoardingPage(),
          AuthScreen.routeName: (context) => AuthScreen(),
          DashboardScreen.routeName: (context) => DashboardScreen(),
          BudgetScreen.routeName: (context) => BudgetScreen(
                budgets: [],
              ),
          TransactionScreen.routeName: (context) => TransactionScreen(
                transactions: [],
              ),
          GoalScreen.routeName: (context) => GoalScreen(),
        },
      ),
    );
  }
}
