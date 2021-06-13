// Imported Flutter packages
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Map<String, dynamic> userData;
  bool isFirstTime;
  Map<String, dynamic> colorData;
  bool validUser = false;

  Future<void> tryAutoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userData') != null) {
      userData = jsonDecode(prefs.getString('userData'));
      try {
        // if the user's password has changed, it will currently log the user out
        // across all devices if the app is closed out on each device (except the device it was changed on)
        // can update later to check more frequently and not require canceling the app
        // this would probably be either a recurring reauthentication check,
        // or better yet, check on every db request
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: userData['email'],
              password: userData['password'],
            )
            .then((value) => validUser = true);
      } on FirebaseAuthException catch (error) {
        print(error.message);
      }
    }
  }

  Future<void> checkIfNewUser() async {
    var prefs = await SharedPreferences.getInstance();
    isFirstTime = prefs.getBool('isFirstTime') ?? true;
  }

  Future<void> getColorScheme() async {
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getString('colorData') != null)
      colorData = jsonDecode(prefs.getString('colorData'));
  }

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold();

    await checkIfNewUser();
    await tryAutoLogin();
    await getColorScheme();

    runApp(MultiProvider(
      providers: [
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
      ],
      child: MyApp(isFirstTime, userData, colorData, validUser),
    ));
  });
}

class MyApp extends StatefulWidget {
  MyApp(this.isFirstTime, this.userData, this.colorData, this.validUser);

  final isFirstTime;
  final userData;
  final colorData;
  final validUser;

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var init;
  Widget getHomeScreen() {
    if (widget.isFirstTime) return OnBoardingPage();
    if (widget.userData != null && widget.validUser) // logged in
    {
      Provider.of<Auth>(context, listen: false)
          .setEmail(widget.userData['email']);
      Provider.of<Auth>(context, listen: false)
          .setUserId(widget.userData['userId']);
      Provider.of<Auth>(context, listen: false)
          .setPassword(widget.userData['password']);

      return TabScreen();
    } else // returning, logged-out user or changed password
      return AuthScreen();
  }

  @override
  void initState() {
    init = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = false; // default to light mode
    var selectedColorIndex = 0; // default to amber
    var colors = Provider.of<ColorProvider>(context);

    isDark = colors.isDark;
    selectedColorIndex = colors.selectedColorIndex;

    if (widget.colorData != null && init) {
      isDark = widget.colorData['colorMode'];
      colors.setIsDark(widget.colorData['colorMode']);
      selectedColorIndex = widget.colorData['selectedColorIndex'];
      colors.setSelectedColorIndex(widget.colorData['selectedColorIndex']);
      init = false;
    }

    var colorMode = isDark ? 'dark' : 'light';
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

    return Builder(builder: (context) {
      return MaterialApp(
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
        home: getHomeScreen(),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: MyApp.analytics),
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
      );
    });
  }
}
