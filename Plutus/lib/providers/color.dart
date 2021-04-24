// Imported Flutter packages
import 'package:flutter/material.dart';

// Provides all color combinations available
class ColorProvider with ChangeNotifier {
  var selectedColorIndex;
  var isDark; // Dark mode variable

  final colorOptions = [
    // Amber
    {
      'light': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.white,
        'cardColor': Colors.amber[50],
      },
      'dark': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
      }
    },
    // Light Blue
    {
      'light': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.white,
        'cardColor': Colors.blue[50],
      },
      'dark': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
      }
    },
    // Light Green
    {
      'light': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.white,
        'cardColor': Colors.green[50],
      },
      'dark': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
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
      },
      'dark': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
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
      },
      'dark': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.black,
        'cardColor': Colors.grey[900],
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
