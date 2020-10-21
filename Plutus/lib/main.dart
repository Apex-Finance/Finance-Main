import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

import './screens/tab_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/budget_screen.dart';
import './screens/transaction_screen.dart';
import './screens/goal_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // '/': (context) => TabScreen(),
        DashboardScreen.routeName: (context) => DashboardScreen(),
        BudgetScreen.routeName: (context) => BudgetScreen(),
        TransactionScreen.routeName: (context) => TransactionScreen(
              transactions: [],
            ),
        GoalScreen.routeName: (context) => GoalScreen(),
      },
    );
  }
}

// change this to its own widget (maybe?)
class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (_) => TabScreen()), // redirect to Plutus homepage on master
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.jpg',
          width: 350.0), // filler images for testing
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
          body: "Plutus helps you...",
          image: _buildImage('83667a8005313ca195808d9262b91586'), // test image
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create a Budget",
          body: "Manage your budgets with ease...",
          image: _buildImage('budget-image'), // use different image
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manage Transactions",
          body: "Managing your transactions has never been easier...",
          image: _buildImage(
              // this image size may be closer to what we may want the final size to be
              'pos-terminal-financial-transactions-operation-payment-credit-card-hands-hold-phone-attachment-cash-money-100337825'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Set Goals",
          body: "Saving up for something special? Plutus helps you...",
          image: _buildImage('financial-goals-icons-600w-1118707967'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Want to create a budget manually?",
          body: "Let's get you started",
          image: _buildImage('img3'), // use different image
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
        PageViewModel(
          title: "Title of last page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      // we may not need this arrow icon
      // next: const Icon(Icons.arrow_forward),
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
