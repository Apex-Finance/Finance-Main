import 'package:Plutus/models/category.dart';
import 'package:flutter/material.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../models/transaction.dart';

//Move from tabscreen to parent widget to make it persist
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Transaction> transactions = [];
  List<Widget> _pages = [];
  List<Category> categories = [];

  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    if (index == 2) return; // if blank "tab" is selected, ignore it
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _enterTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(),
    ).then((newTransaction) {
      if (newTransaction == null) return;
      addTransaction(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      DashboardScreen(),
      BudgetScreen(),
      null,
      TransactionScreen(transactions: transactions),
      GoalScreen(),
    ];

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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => _enterTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            // blank "tab" for spacing around FAB
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(
              Icons.tab,
              color: Colors.black,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.shopping_cart),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: 'Goal',
          ),
        ],
      ),
    );
  }
}
