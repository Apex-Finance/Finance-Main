// Imported Flutter packages
import 'package:Plutus/widgets/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Imported Plutus files
import './auth_screen.dart';

// First screens the user sees upon installing the app. Offers a concise overview of what Plutus has to offer
class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  // Builds a vector image displayed in each page
  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset(
        'images/$assetName',
        height: 300,
        width: 350,
        fit: BoxFit.cover,
      ),
      alignment: Alignment.bottomCenter,
    );
  }

  void setSharedPrefAndStartSignUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.routeName, (Route<dynamic> route) => false,
        arguments: AuthMode.Signup);
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
      // Default app theme is white, hence white background in intro screen
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Welcome to Plutus",
          body: "Plutus helps you take control of your finances with ease.",
          image: _buildImage('Welcome 2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Create a Budget",
          body:
              "Whether you're planning out next month's expenses or thinking about your next vacation, Plutus helps you with all your budgeting needs.",
          image: _buildImage('Budget 2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Manage Transactions",
          body:
              "Stay on top of your expenses with Plutus. Know exactly what you spent your money on and when you spent it.",
          image: _buildImage('Transaction.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Set Goals",
          body:
              "Saving up for that shiny new car? Plutus can help you set aside funds for that item and keep track of how close you are to achieving that goal.",
          image: _buildImage('Goal 2.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Utilize the Quick Add Button",
          body: "Use the + button to quickly add transactions.",
          image: _buildImage('Quick Add Button.jpg'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ready to start your journey to financial freedom?",
          bodyWidget: ElevatedButton(
            child: Text(
              'Sign me up!',
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            onPressed: setSharedPrefAndStartSignUp,
            style: ElevatedButton.styleFrom(
              primary: Colors.amber,
              textStyle: TextStyle(color: Theme.of(context).canvasColor),
            ),
          ),
          image: _buildImage('Freedom.jpg'),
          decoration: pageDecoration,
        ),
      ],
      onDone: setSharedPrefAndStartSignUp,
      onSkip: () => introKey.currentState
          ?.animateScroll(5), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 1,
      nextFlex: 1,
      skip: const Text(
        'Skip',
        style: TextStyle(color: Colors.amber),
      ),
      next: const Icon(
        Icons.arrow_forward,
        color: Colors.amber,
      ),
      done: const Text('Done',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          )),
      dotsFlex: 2,
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
