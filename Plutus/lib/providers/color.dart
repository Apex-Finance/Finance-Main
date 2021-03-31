import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  var selectedColorIndex;
  var isDark;
  var selectedGreyColor;

  final colorOptions = [
    // {
    //   'light': {
    //     'name': "Black",
    //     'primarySwatch': Colors.grey,
    //     'primaryColor': Colors.black,
    //     'canvasColor': Colors.white
    //   },
    //   'dark': {
    //     'name': "Black",
    //     'primarySwatch': Colors.grey,
    //     'primaryColor': Colors.white,
    //     'canvasColor': Colors.black
    //   }
    // },
    // {
    //   'light': {
    //     'name': "Dark Blue",
    //     'primarySwatch': Colors.indigo,
    //     'primaryColor': Colors.indigo[900],
    //     'canvasColor': Colors.indigo[50]
    //   },
    //   'dark': {
    //     'name': "Dark Blue",
    //     'primarySwatch': Colors.indigo,
    //     'primaryColor': Colors.indigo[800],
    //     'canvasColor': Colors.black
    //   }
    // },
    {
      'light': {
        'name': "Red",
        'primarySwatch': Colors.red,
        'primaryColor': Colors.red,
        'canvasColor': Colors.red[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Red",
        'primarySwatch': Colors.red,
        'primaryColor': Colors.red,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Orange",
        'primarySwatch': Colors.orange,
        'primaryColor': Colors.orange,
        'canvasColor': Colors.orange[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Red",
        'primarySwatch': Colors.orange,
        'primaryColor': Colors.orange,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.amber[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Amber",
        'primarySwatch': Colors.amber,
        'primaryColor': Colors.amber,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.green[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Light Green",
        'primarySwatch': Colors.green,
        'primaryColor': Colors.green,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.blue[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Light Blue",
        'primarySwatch': Colors.blue,
        'primaryColor': Colors.blue[700],
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.purple[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Purple",
        'primarySwatch': Colors.purple,
        'primaryColor': Colors.purple,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
      }
    },
    {
      'light': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.pink[50],
        'greyColor': Colors.grey
      },
      'dark': {
        'name': "Pink",
        'primarySwatch': Colors.pink,
        'primaryColor': Colors.pink,
        'canvasColor': Colors.black,
        'greyColor': Colors.grey[700]
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

  void setGreyColor(MaterialColor greyColor) {
    selectedGreyColor = greyColor;
    notifyListeners();
  }
}
