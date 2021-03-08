import 'package:Plutus/screens/individual_goal_screen.dart';
import 'package:Plutus/screens/new_budget_screens/income_screen.dart';
import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import './screens/tab_screen.dart';
import './screens/intro_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/budget_screen.dart';
import './screens/transaction_screen.dart';
import './screens/goal_screen.dart';
import './screens/new_budget_screens/first_budget_screen.dart';
import './screens/auth_screen.dart';
import './screens/account_screen.dart';
import './screens/settings_screen.dart';
import './models/transaction.dart';
import './models/budget.dart';
import './providers/auth.dart';
import 'models/goals.dart';
import './screens/individual_goal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoalDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BudgetDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => MonthChanger(),
        ),
        ChangeNotifierProxyProvider<MonthChanger, Transactions>(
          update: (buildContext, monthChanger, previousTransactions) =>
              Transactions(
                  monthChanger,
                  previousTransactions == null
                      ? []
                      : previousTransactions.transactions),
          create: null,
        ),
        // ChangeNotifierProxyProvider2<MonthChanger, Transactions, Budgets>(
        //   update: (buildContext, monthChanger, transactions, previousBudgets) =>
        //       Budgets(monthChanger, transactions,
        //           previousBudgets == null ? [] : previousBudgets.budgets),
        //   create: null,
        // ),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Plutus',
          theme: ThemeData(
            primarySwatch: Colors.amber,
            primaryColor: Colors.amber,
            primaryColorLight: Colors.amberAccent,
            accentColor: Colors.white,
            canvasColor: Colors.black,
            textTheme: GoogleFonts.latoTextTheme(
              TextTheme(
                bodyText1: TextStyle(color: Colors.amber, fontSize: 18),
                bodyText2: TextStyle(color: Colors.amber, fontSize: 12),
                subtitle1: TextStyle(color: Colors.amber, fontSize: 17),
                headline1: TextStyle(color: Colors.amber, fontSize: 25),
              ),
            ),
          ),
          initialRoute: '/onboarding',
          routes: {
            '/onboarding': (context) => OnBoardingPage(),
            DashboardScreen.routeName: (context) => DashboardScreen(),
            BudgetScreen.routeName: (context) => BudgetScreen(),
            TransactionScreen.routeName: (context) => TransactionScreen(),
            GoalScreen.routeName: (context) => GoalScreen(),
            IncomeScreen.routeName: (context) => IncomeScreen(),
            FirstBudgetScreen.routeName: (context) => FirstBudgetScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            AccountScreen.routeName: (context) => AccountScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            TabScreen.routeName: (context) => TabScreen(),
          },
        ),
      ),
    );
  }
}
