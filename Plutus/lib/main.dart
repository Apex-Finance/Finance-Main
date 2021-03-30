import 'package:Plutus/models/category.dart';
import 'package:Plutus/screens/new_budget_screens/income_screen.dart';
import 'package:Plutus/models/month_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/account_screen.dart';
import './screens/settings_screen.dart';
import './models/budget.dart';
import './providers/auth.dart';
import 'models/goals.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => ColorProvider()),
        ChangeNotifierProvider(create: (context) => GoalDataProvider()),
        ChangeNotifierProvider(
          create: (context) => BudgetDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CategoryDataProvider(),
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
      ], child: MyApp()),
    );
  });
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    // To Create a crash
    //FirebaseCrashlytics.instance.crash();
    var colors = Provider.of<ColorProvider>(context);
    var isDark = colors.isDark ?? false; // default to light mode
    var colorMode = isDark ? 'dark' : 'light';
    var selectedColorIndex = colors.selectedColorIndex ?? 2; // default to amber
    var primarySwatch =
        colors.colorOptions[selectedColorIndex][colorMode]['primarySwatch'];
    var primaryColor =
        colors.colorOptions[selectedColorIndex][colorMode]['primaryColor'];
    var canvasColor =
        colors.colorOptions[selectedColorIndex][colorMode]['canvasColor'];
    return Builder(
      builder: (context) => MaterialApp(
        title: 'Plutus',
        theme: ThemeData(
          primarySwatch: primarySwatch, //Colors.amber,
          primaryColor: primaryColor, //Colors.amber,
          primaryColorLight: Colors.amberAccent,
          accentColor: Colors.white,
          canvasColor: canvasColor,
          textTheme: GoogleFonts.latoTextTheme(
            TextTheme(
              bodyText1: TextStyle(color: primaryColor, fontSize: 17),
              bodyText2: TextStyle(color: Colors.black, fontSize: 17),
              subtitle1: TextStyle(color: Colors.white, fontSize: 17),
              headline1: TextStyle(color: primaryColor, fontSize: 25),
            ),
          ),
        ),
        initialRoute: '/onboarding',
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
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
    );
  }
}
