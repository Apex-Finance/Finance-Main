// Imported Flutter packages
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

// Imported Plutus files
import './screens/new_budget_screens/income_screen.dart';
import './screens/account_screen.dart';
import './screens/settings_screen.dart';
import './models/budget.dart';
import './providers/auth.dart';
import './models/goals.dart';
import './models/month_changer.dart';
import './providers/color.dart';
import './models/category.dart';
import './models/transaction.dart';
import './screens/intro_screen.dart';
import './screens/budget_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/transaction_screen.dart';
import './screens/tab_screen.dart';
import './screens/goal_screen.dart';
import './screens/new_budget_screens/first_budget_screen.dart';
import './screens/auth_screen.dart';
import './providers/tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold();
    runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (context) => TabProvider()),
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
              Transactions(monthChanger),
          create: null,
        ),
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
    var selectedColorIndex = colors.selectedColorIndex ?? 0; // default to amber
    var primarySwatch =
        colors.colorOptions[selectedColorIndex][colorMode]['primarySwatch'];
    var primaryColor =
        colors.colorOptions[selectedColorIndex][colorMode]['primaryColor'];
    var canvasColor =
        colors.colorOptions[selectedColorIndex][colorMode]['canvasColor'];
    var cardColor =
        colors.colorOptions[selectedColorIndex][colorMode]['cardColor'];
    var backgroundColor =
        colors.colorOptions[selectedColorIndex][colorMode]['backgroundColor'];
    return Builder(
      builder: (context) => MaterialApp(
        title: 'Plutus',
        theme: ThemeData(
          primarySwatch: primarySwatch, // Colors.amber
          primaryColor: primaryColor,
          backgroundColor: backgroundColor, // ListTile color
          accentColor: Colors.white,
          canvasColor: canvasColor,
          cardColor: cardColor, // Background card color
          iconTheme: IconThemeData(color: canvasColor),
          dialogTheme: DialogTheme(
            backgroundColor: colors.colorOptions[selectedColorIndex]['light'][
                'cardColor'], //fix for datepickers; causes alertdialogs to always show light version as well
            titleTextStyle: TextStyle(color: primaryColor, fontSize: 25),
            contentTextStyle: TextStyle(color: primaryColor, fontSize: 17),
          ),
          textTheme: GoogleFonts.latoTextTheme(
            TextTheme(
              bodyText1: TextStyle(color: primaryColor, fontSize: 17),
              bodyText2: TextStyle(color: Colors.black, fontSize: 17),
              subtitle1: TextStyle(color: Colors.black, fontSize: 17),
              subtitle2: TextStyle(color: Colors.white, fontSize: 17),
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
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
