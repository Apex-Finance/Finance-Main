import 'package:Plutus/models/category.dart';
import 'package:Plutus/models/budget.dart';
import 'package:flutter/material.dart';

import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../models/transaction.dart';

// Our Main Screen that controls the other screens; necessary to implement this way because of the FAB managing transaction
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Transaction> transactions = [];
  List<Widget> _pages = [];
  List<Category> categories = [];
  List<Budget> budgets = [];

  // Add a new transaction to the list of transactions
  void addTransaction(Transaction transaction) {
    setState(() {
      transactions.add(transaction);
    });
  }

  int _selectedPageIndex = 0;

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
      addTransaction(newTransaction);
    });
  }

  @override
  Widget build(BuildContext context) {
    _pages = [
      // manages tabs
      DashboardScreen(),
      BudgetScreen(
        budgets: budgets,
      ),
      null, // workaround for spacing
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
            color: Colors.black,
          ),
          label: '',
        ), // blank "tab" for spacing around FAB
        buildTab(context, Icons.shopping_cart, 'Transaction'),
        buildTab(context, Icons.star, 'Goal'),
      ],
    );
  }

  BottomNavigationBarItem buildTab(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).primaryColor,
      icon: Icon(
        icon,
      ),
      label: label,
    );
  }
}
