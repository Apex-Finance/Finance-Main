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
        'canvasColor': Colors.amber[50],
        'cardColor': Colors.grey[900],
      },
      'dark': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.black,
        'cardColor': Colors.white,
      }
    },
    // Light Blue
    {
      'light': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.blue[50],
        'cardColor': Colors.grey[900],
      },
      'dark': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.black,
        'cardColor': Colors.white,
      }
    },
    // Light Green
    {
      'light': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.green[50],
        'cardColor': Colors.grey[900],
      },
      'dark': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.black,
        'cardColor': Colors.white,
      }
    },
    // Pink
    {
      'light': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.pink[50],
        'cardColor': Colors.grey[900],
      },
      'dark': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.black,
        'cardColor': Colors.white,
      }
    },
    // Purple
    {
      'light': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.purple[50],
        'cardColor': Colors.grey[900],
      },
      'dark': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.black,
        'cardColor': Colors.white,
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
