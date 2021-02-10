import 'dart:ui';

import 'package:Plutus/models/categories.dart';
import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../models/transaction.dart';

import 'package:provider/provider.dart';

// Our Main Screen that controls the other screens; necessary to implement this way because of the FAB managing transaction
class TabScreen extends StatefulWidget {
  static const routeName = '/tab';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  List<Transaction> transactions = [];
  List<Widget> _pages = [];
  List<Category> categories = [];
  List<Budget> budgets = [];

  int _selectedPageIndex = 0;
  bool isOpen = false;

  // Select a screen from the list of screens; manages tabs
  void _selectPage(int index) {
    if (index == 2)
      return; // if blank "tab" is selected, ignore it; a workaround to give FAB more space
    setState(() {
      _selectedPageIndex = index;
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
      Provider.of<Transactions>(context, listen: false)
          .addTransaction(newTransaction, context);
    });
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
      // TODO Toggle blur effect when button is pressed
      floatingActionButton: BackdropFilter(
        filter: isOpen
            ? ImageFilter.blur(
                sigmaX: 3,
                sigmaY: 3,
              )
            : ImageFilter.blur(
                sigmaX: 0,
                sigmaY: 0,
              ),
        child: GestureDetector(
          // TODO onTap changes the value if you tap ANYWHERE BUT the + button
          onTap: () => {
            setState(() {
              isOpen = !isOpen;
              print(isOpen);
            })
          },
          child: FabCircularMenu(
            // key: fabKey,
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
                  onPressed: () {},
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
                  onPressed: () {},
                ),
              ),
            ],
            ringDiameter: 300,
            fabMargin: EdgeInsets.fromLTRB(0, 0, 40, 30),
            fabOpenIcon: Icon(Icons.add),
            ringColor: Colors.amber.withOpacity(0),
            // child: Icon(Icons.add),
            // backgroundColor: Theme.of(context).primaryColor,
            // onPressed: () => _enterTransaction(context),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: buildTabBar(context),
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
