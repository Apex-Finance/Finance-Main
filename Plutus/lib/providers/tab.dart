import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _selectedPageIndex = 0;

  int getSelectedPageIndex() {
    return _selectedPageIndex;
  }

  void setSelectedPageIndex(int index) {
    _selectedPageIndex = index;
  }
}
