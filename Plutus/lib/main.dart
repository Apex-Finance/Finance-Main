import 'package:Plutus/screens/new_budget_screens/income_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import './screens/tab_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/budget_screen.dart';
import './screens/transaction_screen.dart';
import './screens/goal_screen.dart';
import './screens/new_budget_screens/first_budget_screen.dart';
import 'package:provider/provider.dart';
import './models/transaction.dart';
import './models/budget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Transactions()),
        ChangeNotifierProvider(create: (context) => Budgets()),
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
        PageViewModel(
          title: "Manage Transactions",
          body: "Stay on top of your expenses with Plutus...",
          //image: _buildImage(
          //'pos-terminal-financial-transactions-operation-payment-credit-card-hands-hold-phone-attachment-cash-money-100337825'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Set a goal",
          body: "Saving up for that shiny new car? Plutus can help...",
          image: _buildImage('financial-goals-icons-600w-1118707967'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Want to manually create a budget?",
          body: "Let's get started",
          image: _buildImage('lets get started'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Create a Budget',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        // ***This page could be the login page***
        PageViewModel(
          title: "Login Page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Insert Login Page", style: bodyStyle),
            ],
          ),
          image: _buildImage('financial-goals-icons-600w-1118707967'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
