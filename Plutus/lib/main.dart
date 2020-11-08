import 'package:Plutus/models/month_changer.dart';
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
import 'package:provider/provider.dart';
import './models/transaction.dart';
import './models/budget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProvider(create: (context) => MonthChanger()),
        ChangeNotifierProxyProvider<MonthChanger, Transactions>(
          update: (buildContext, monthChanger, previousTransactions) =>
              Transactions(
                  monthChanger,
                  previousTransactions == null
                      ? []
                      : previousTransactions.transactions),
          create: null,
        ),
        ChangeNotifierProxyProvider<MonthChanger, Budgets>(
          update: (buildContext, monthChanger, previousBudgets) => Budgets(
              monthChanger,
              previousBudgets == null ? [] : previousBudgets.budgets),
          create: null,
        ),
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
                bodyText1: TextStyle(
                  color: Colors.amber,
                ),
              ),
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => OnBoardingPage(),
            DashboardScreen.routeName: (context) => DashboardScreen(),
            BudgetScreen.routeName: (context) => BudgetScreen(),
            TransactionScreen.routeName: (context) => TransactionScreen(),
            GoalScreen.routeName: (context) => GoalScreen(),
          },
        ),
      ),
    );
  }
}

// Maybe put this into a separate file?
class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TabScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('images/$assetName.jpg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Plutus",
          body: "Plutus helps you take control of your finances with ease.",
          image: _buildImage('83667a8005313ca195808d9262b91586'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create a Budget",
          body: "Creating a budget...",
          image: _buildImage('budget-image'),
          decoration: pageDecoration,
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
