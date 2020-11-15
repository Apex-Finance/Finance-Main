import 'package:Plutus/screens/tab_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../screens/new_budget_screens/income_screen.dart';

// TODO Need to finish Auth screen
// Commented out until it is working
//import './auth_screen.dart';
import './tab_screen.dart';
import './auth_screen.dart';

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
      child: Image.asset(
        'images/$assetName',
        height: 300,
        width: 350.0,
        fit: BoxFit.cover,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(
      fontSize: 19.0,
      color: Colors.amber,
    );
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w700, color: Colors.amber),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Plutus",
          body: "Plutus helps you take control of your finances with ease.",
          image: _buildImage('83667a8005313ca195808d9262b91586.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create a Budget",
          body:
              "Whether you're planning out next month's expenses or thinking about your next vacation, Plutus helps all your budgeting needs.",
          image: _buildImage('budget-image.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manage Transactions",
          body:
              "Stay on top of your expenses with Plutus. Know exactly what and where you spent your money.",
          image: _buildImage(
              'Keep-Track-of-the-Financial-Transactions-Within-Komet_1080x.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Set a goal",
          body:
              "Saving up for that shiny new car? Plutus can help you set aside funds for that item and keep track of how close you are to achieving that goal.",
          image: _buildImage('financial-goals-icons-600w-1118707967.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ready to start your journey to financial freedom?",
          bodyWidget: RaisedButton(
            child: Text('Sign me up!'),
            onPressed: () =>
                Navigator.of(context).pushNamed(AuthScreen.routeName),
            color: Colors.amber,
          ),
          image: _buildImage('lets get started.jpg'),
          decoration: pageDecoration,
        ),
        // NOT NEEDED IN INITIAL WALKTHROUGH
        // PageViewModel(
        //   title: "Want to manually create a budget?",
        //   bodyWidget: RaisedButton(
        //     onPressed: () {
        //       Navigator.of(context).popAndPushNamed(IncomeScreen.routeName);
        //     },
        //     child: const Text(
        //       'Create a Budget',
        //       style: TextStyle(color: Colors.black),
        //     ),
        //     color: Colors.amber,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //   ),
        //   image: _buildImage('Budgeting Methods_Banner.png'),
        //   decoration: pageDecoration,
        // ),
      ],
      onDone: () => Navigator.of(context).pushNamed(AuthScreen.routeName),
      onSkip: () => introKey.currentState?.animateScroll(
          4), //_onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.amber),
      ),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          )),
      dotsDecorator: const DotsDecorator(
        activeColor: Colors.amber,
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
