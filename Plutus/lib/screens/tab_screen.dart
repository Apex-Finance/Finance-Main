import 'dart:ui';
import 'package:Plutus/models/categories.dart';
import 'package:Plutus/models/budget.dart';
import 'package:Plutus/widgets/goals_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../models/transaction.dart';
import '../widgets/tappable_fab_circular_menu.dart';
import 'new_budget_screens/income_screen.dart';

// Our Main Screen that controls the other screens; necessary to implement this way because of the FAB managing transaction
class TabScreen extends StatefulWidget {
  static const routeName = '/tab';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Transaction> transactions = [];
  List<Widget> _pages = [];
  List<Category> categories = [];
  List<Budget> budgets = [];

  int _selectedPageIndex = 0;
  bool _isOpen = false;

  // Select a screen from the list of screens; manages tabs
  void _selectPage(int index) {
    if (index == 2)
      return; // if blank "tab" is selected, ignore it; a workaround to give FAB more space
    setState(() {
      _selectedPageIndex = index;
    });
  }

  // Pull up budget form when FAB is tapped; add the returned budget to the list of budgets (?)
  void _enterBudget(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => IncomeScreen(),
    ).then((newBudget) {
      if (newBudget == null) return;
      Provider.of<BudgetDataProvider>(context, listen: false)
          .addBudget(newBudget, context); //TODO check if needed
    });
  }

  // Pull up transaction form when FAB is tapped; add the returned transaction to the list of transactions
  void _enterTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(),
    ).then((newTransaction) {
      if (newTransaction == null) return;
    });
  }

  void _enterGoal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => GoalsForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      // manages tabs
      DashboardScreen(),
      BudgetScreen(),
      null, // workaround for spacing
      TransactionScreen(),
      GoalScreen(),
    ];

    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            // settings
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/settings');
              },
              leading: Icon(
                Icons.settings,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            ),
            // acount
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed('/account');
              },
              leading: Icon(
                Icons.account_circle,
                size: 30,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                'Account',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: TappableFabCircularMenu(
        alignment: Alignment.bottomCenter,
        animationDuration: Duration(milliseconds: 500),
        children: <Widget>[
          Ink(
            decoration: const ShapeDecoration(
              color: Color(0xFF212121), // basically Colors.grey[900]
              shape: CircleBorder(),
            ),
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.account_balance),
              onPressed: () => _enterBudget(context),
            ),
          ),
          Ink(
            decoration: const ShapeDecoration(
              color: Color(0xFF212121), // basically Colors.grey[900]
              shape: CircleBorder(),
            ),
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.shopping_cart),
              onPressed: () => _enterTransaction(context),
            ),
          ),
          Ink(
            decoration: const ShapeDecoration(
              color: Color(0xFF212121), // basically Colors.grey[900]
              shape: CircleBorder(),
            ),
            child: IconButton(
              color: Theme.of(context).primaryColor,
              icon: Icon(Icons.star),
              onPressed: () => _enterGoal(context),
            ),
          ),
        ],
        onDisplayChange: (isOpen) {
          setState(() {
            _isOpen = !_isOpen;
          });
        },
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
    );
  }

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

  BottomNavigationBarItem buildTab(
      BuildContext context, IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(icon),
      label: label,
    );
  }
}
