// Imported Flutter packages
import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  var selectedColorIndex;
  var isDark; // Dark mode variable

  final colorOptions = [
    {
      'light': {
        'name': "Black",
        'primarySwatch': Colors.grey,
        'primaryColor': Colors.black,
        'canvasColor': Colors.white
      },
      'dark': {
        'name': "Black",
        'primarySwatch': Colors.grey,
        'primaryColor': Colors.white,
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Dark Blue",
        'primarySwatch': Colors.indigo,
        'primaryColor': Colors.indigo[900],
        'canvasColor': Colors.indigo[50]
      },
      'dark': {
        'name': "Dark Blue",
        'primarySwatch': Colors.indigo,
        'primaryColor': Colors.indigo[800],
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.amber[50]
      },
      'dark': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.blue[50]
      },
      'dark': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.green[50]
      },
      'dark': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.pink[50]
      },
      'dark': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.black
      }
    },
    {
      'light': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.purple[50]
      },
      'dark': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.black
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
