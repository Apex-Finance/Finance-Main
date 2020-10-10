import 'package:flutter/material.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';

//Move from tabscreen to parent widget to make it persist
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Widget> _pages = [
    DashboardScreen(),
    BudgetScreen(),
    TransactionScreen(),
    GoalScreen(),
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(title: Text('Settings', style: TextTheme().bodyText1)),
            ListTile(title: Text('Account', style: TextTheme().bodyText1)),
          ],
        ),
      ),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).canvasColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
        showUnselectedLabels: true,
        unselectedFontSize: 14.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.account_balance),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.shopping_cart),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Goals',
          ),
        ],
      ),
    );
  }
}
