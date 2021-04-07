import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

import '../providers/color.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var selectedColorIndex;
  var isDark;
  var initialIndex;

  Widget _colorOption(
      String name,
      Color foreground,
      Color background,
      int index,
      Function setColorIndex,
      Function setGreyColor,
      BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      color: Colors.grey[600],
      child: Row(
        children: [
          Icon(Icons.circle,
              color: selectedColorIndex ==
                      index // if user selects this color, make the icon the same color
                  ? (foreground == Colors.black ? Colors.white : foreground)
                  : IconTheme.of(context).color),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            color: foreground,
          ),
          Container(
            width: 40,
            height: 40,
            color: background,
          ),
          SizedBox(
            width: 50,
          ),
        ],
      ),
      onPressed: () {
        setColorIndex();
        setGreyColor();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = Provider.of<ColorProvider>(context);
    isDark = colors.isDark ??
        false; // set isDark to user's last preference; if none found (or initial load), default to light mode
    selectedColorIndex = colors.selectedColorIndex ??
        2; // set active color to user's last preference; if none found (or initial load), default to amber
    initialIndex = isDark ? 0 : 1; //set toggle to match dark mode
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                color: Theme.of(context).cardColor,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Change colors',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Dark mode',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            ToggleSwitch(
                              minWidth: 90.0,
                              cornerRadius: 20.0,
                              activeBgColor: Theme.of(context).primaryColor,
                              activeFgColor: Colors.black,
                              inactiveBgColor: Colors.grey[600],
                              inactiveFgColor: Colors.black,
                              labels: ['ON', 'OFF'],
                              initialLabelIndex: initialIndex,
                              icons: [
                                Icons.check,
                                Icons.highlight_off,
                              ],
                              onToggle: (index) {
                                setState(() {
                                  initialIndex =
                                      index; // package has a quirk that requires you do this if using setState; see https://github.com/PramodJoshi/toggle_switch/issues/11 for more info

                                  if (index == 0)
                                    colors.setIsDark(true);
                                  // isDark = true;
                                  else
                                    colors.setIsDark(false);
                                  //isDark = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: colors.colorOptions.length * 50.0,
                        child: ListView.builder(
                            itemCount: colors.colorOptions.length,
                            itemBuilder: (context, index) {
                              return _colorOption(
                                  colors.colorOptions[index]
                                      [isDark ? 'dark' : 'light']['name'],
                                  colors.colorOptions[index]
                                          [isDark ? 'dark' : 'light']
                                      ['primaryColor'],
                                  colors.colorOptions[index]
                                          [isDark ? 'dark' : 'light']
                                      ['canvasColor'],
                                  index,
                                  () => colors.setSelectedColorIndex(index),
                                  () => colors.setGreyColor(colors
                                          .colorOptions[index]
                                      [isDark ? 'dark' : 'light']['greyColor']),
                                  context);
                            }),
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                            bottom: Radius.circular(20),
                          ),
                        ),
                        color: Colors.amber,
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          colors.setSelectedColorIndex(2);
                          colors.setIsDark(false);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
