// Imported Flutter packages
import 'package:flutter/material.dart';

// Imported Plutus files
import './budget_screen.dart';
import './transaction_screen.dart';
import './dashboard_screen.dart';
import './goal_screen.dart';
import '../widgets/transaction_form.dart';
import '../providers/tab.dart';
import 'package:provider/provider.dart';
import '../providers/color.dart';

// Our Main Screen that controls the other screens; necessary to implement this way because of the FAB managing transaction
class TabScreen extends StatefulWidget {
  static const routeName = '/tab';
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Widget> _pages = []; // List of screens for the BottomNavigationBar
  int _selectedPageIndex;

  // Select a screen from the list of screens; manages tabs
  void _selectPage(int index) {
    if (index == 2)
      return; // if blank "tab" is selected, ignore it; a workaround to give FAB more space
    if (index == _selectedPageIndex)
      return; // don't rebuild screen if already on it
    setState(() {
      Provider.of<TabProvider>(context, listen: false)
          .setSelectedPageIndex(index);
    });
  }

  // Pull up transaction form when FAB is tapped; add the returned transaction to the list of transactions
  void _enterTransaction(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => TransactionForm(),
    ).then((newTransaction) {
      if (newTransaction == null)
        return;
      else
        setState(() {}); // updates budget if transaction is made
    });
  }

  // Manages tabs
  @override
  Widget build(BuildContext context) {
    _selectedPageIndex = Provider.of<TabProvider>(context)
        .getSelectedPageIndex(); // Defaults to Dashboard screen
    _pages = [
      DashboardScreen(),
      BudgetScreen(),
      null, // workaround for spacing
      TransactionScreen(),
      GoalScreen(),
    ];

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/settings');
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/account');
              },
            ),
          ],
        ),
        // Scale the button up in size
        floatingActionButton: Transform.scale(
          scale: 1.2,
          child: FloatingActionButton(
            onPressed: () => _enterTransaction(context),
            child: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: buildTabBar(context));
  }

  // Builds a BottomNavigationBar that includes tabs for Dashboard, Budget,
  // Transaction, and Goals screens
  BottomNavigationBar buildTabBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: _selectPage,
      backgroundColor:
          Colors.grey[900], // Don't change. Looks good with any theme.
      unselectedItemColor: Provider.of<ColorProvider>(context).isDark
          ? Colors.grey
          : Theme.of(context).canvasColor,
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
