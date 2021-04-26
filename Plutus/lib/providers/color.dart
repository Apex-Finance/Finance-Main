// Imported Flutter packages
import 'package:flutter/material.dart';

// Provides all color combinations available
class ColorProvider with ChangeNotifier {
  var selectedColorIndex = 0;
  var isDark = false; // Dark mode variable

  final colorOptions = [
    // Amber
    {
      'light': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.white,
        'cardColor': Colors.amber[50],
        'backgroundColor': Colors.grey[500],
      },
      'dark': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
        'backgroundColor': Colors.grey[800],
      }
    },
    // Blue
    {
      'light': {
        'name': "Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.white,
        'cardColor': Colors.blue[50],
        'backgroundColor': Colors.grey[500],
      },
      'dark': {
        'name': "Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
        'backgroundColor': Colors.grey[800],
      }
    },
    // Green
    {
      'light': {
        'name': "Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green[700],
        'canvasColor': Colors.white,
        'cardColor': Colors.green[50],
        'backgroundColor': Colors.grey[500],
      },
      'dark': {
        'name': "Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green[700],
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
        'backgroundColor': Colors.grey[800],
      }
    },
    // Pink
    {
      'light': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.white,
        'cardColor': Colors.pink[50],
        'backgroundColor': Colors.grey[500],
      },
      'dark': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
        'backgroundColor': Colors.grey[800],
      }
    },
    // Purple
    {
      'light': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.white,
        'cardColor': Colors.purple[50],
        'backgroundColor': Colors.grey[500],
      },
      'dark': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
        'backgroundColor': Colors.grey[800],
      }
    },
  ];

  void setSelectedColorIndex(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void setIsDark(bool colorMode) {
    isDark = colorMode;
    notifyListeners();
  }
}
