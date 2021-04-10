import 'dart:ui';
import 'package:Plutus/widgets/goals_form.dart';
import 'package:flutter/material.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../widgets/tappable_fab_circular_menu.dart';
import 'new_budget_screens/income_screen.dart';

bool _isOpen = false; // Determines if Fab_Circular_Menu is open

// Our Main Screen that controls the other screens; necessary to implement this way because of the FAB managing transaction
class TabScreen extends StatefulWidget {
  static const routeName = '/tab';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final GlobalKey<TappableFabCircularMenuState> fabKey = GlobalKey();
  @override
  void initState() {
    super.initState();
  }

  List<Widget> _pages = []; // List of screens for the BottomNavigationBar
  int _selectedPageIndex = 0; // Defaults to Dashboard screen

  // Select a screen from the list of screens; manages tabs
  void _selectPage(int index) {
    if (index == 2)
      return; // if blank "tab" is selected, ignore it; a workaround to give FAB more space
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Pull up budget form when FAB is tapped; add the returned budget to the list of budgets
  // doesn't work anymore but will get removed anyways because only doing transactions
  // void _enterBudget(BuildContext context) {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (_) => IncomeScreen(),
  //   ).then(
  //     (newBudget) {
  //       if (newBudget == null) return;
  //     },
  //   );
  // }

  // Pull up transaction form when FAB is tapped; add the returned transaction to the list of transactions
  void _enterTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(),
    ).then((newTransaction) {
      if (newTransaction == null) return;
    });
    fabKey.currentState.close();
  }

  // Pull up goal form when FAB is tapped; add the returned goal to the list of goals
  void _enterGoal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(),
    ).then((newGoal) {
      if (newGoal == null) return;
    });
    fabKey.currentState.close();
  }

  // Manages tabs
  @override
  Widget build(BuildContext context) {
    _pages = [
      DashboardScreen(),
      BudgetScreen(),
      null, // workaround for spacing
      TransactionScreen(),
      GoalScreen(),
    ];

    // GestureDetector wraps entire widget to ensure that users can close the Fab_Circular_Menu from
    // anywhere in the app. Absorb Pointer prevents accidental touches to interactable widgets
    // (i.e. buttons, arrows) on other screens when Fab_Circular_Menu is open
    return GestureDetector(
      onTap: () {
        if (_isOpen) fabKey.currentState.close();
      },
      child: Scaffold(
        appBar: CustomAppBar(),
        // Custom Fab_Circular_Menu used here to utilize BackdropFilter widget
        floatingActionButton: TappableFabCircularMenu(
          alignment: Alignment.bottomCenter,
          animationDuration: Duration(milliseconds: 500),
          children: <Widget>[
            // Budget form
            Ink(
              decoration: const ShapeDecoration(
                color: Color(0xFF212121), // basically Colors.grey[900]
                shape: CircleBorder(),
              ),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.account_balance),
                onPressed: () => {}, //_enterBudget(context),
                splashRadius: 23,
              ),
            ),

            // Transaction form
            Ink(
              decoration: const ShapeDecoration(
                color: Color(0xFF212121),
                shape: CircleBorder(),
              ),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.shopping_cart),
                onPressed: () => _enterTransaction(context),
                splashRadius: 23,
              ),
            ),
            // Goal Form
            Ink(
              decoration: const ShapeDecoration(
                color: Color(0xFF212121),
                shape: CircleBorder(),
              ),
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.star),
                onPressed: () => _enterGoal(context),
                splashRadius: 23,
              ),
            ),
          ],
          onDisplayChange: (isOpen) {
            setState(() {
              _isOpen = !_isOpen;
            });
          },
          key: fabKey,
          ringDiameter: 300,
          fabMargin: EdgeInsets.fromLTRB(0, 0, 40, 30),
          fabOpenIcon: Icon(Icons.add),
          ringColor: Colors.amber.withOpacity(0),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: AbsorbPointer(
            absorbing: _isOpen == true ? true : false,
            child: _pages[_selectedPageIndex]),
        bottomNavigationBar: AbsorbPointer(
            absorbing: _isOpen == true ? true : false,
            child: buildTabBar(context)),
      ),
    );
  }

  // Builds a BottomNavigationBar that includes tabs for Dashboard, Budget,
  // Transaction, and Goals screens
  BottomNavigationBar buildTabBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectPage,
      backgroundColor: Colors.grey[900],
      unselectedItemColor: Colors.white,
      selectedItemColor: Theme.of(context).primaryColor,
      showUnselectedLabels: true,
      unselectedFontSize: 14.0,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedPageIndex,
      items: [
        buildTab(context, Icons.category, 'Dashboard'),
        buildTab(context, Icons.account_balance, 'Budget'),
        BottomNavigationBarItem(
          backgroundColor: Theme.of(context).primaryColor,
          icon: Icon(
            Icons.tab,
            color: Colors.grey[900],
            size: 0, // needed to hide icon when a snackbar pops up
          ),
          label: '',
        ), // blank "tab" for spacing around FAB
        buildTab(context, Icons.shopping_cart, 'Transaction'),
        buildTab(context, Icons.star, 'Goal'),
      ],
    );
  }

  // Builds each individual tab for BottomNavigationBar
  BottomNavigationBarItem buildTab(
      BuildContext context, IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(icon),
      label: label,
    );
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isOpen == true ? true : false,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushNamed('/account');
            },
          ),
        ],
      ),
    );
  }
}
