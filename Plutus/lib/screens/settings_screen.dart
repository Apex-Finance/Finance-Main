// Imported Flutter packages
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:provider/provider.dart';

// Imported Plutus files
import '../providers/color.dart';

// Screen that changes the color mode and theme.
class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var selectedColorIndex;
  var isDark;
  var initialIndex;

  // Chooses the color theme and mode. This honestly should be another widget - Juan
  Widget _colorOption(String name, Color foreground, Color background,
      int index, Function setColorIndex, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).backgroundColor,
        padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
            bottom: Radius.circular(20),
          ),
        ),
      ),
      child: Row(
        children: [
          // Chosen color
          Icon(Icons.circle,
              color: selectedColorIndex ==
                      index // if user selects this color, make the icon the same color
                  ? (foreground == Colors.black ? Colors.white : foreground)
                  : IconTheme.of(context).color),
          SizedBox(
            width: 10,
          ),
          // Color name
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          // Primary color
          Container(
            width: 40,
            height: 40,
            color: foreground,
          ),
          // Secondary color
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var colors = Provider.of<ColorProvider>(context);
    isDark = colors.isDark ??
        false; // set isDark to user's last preference; if none found (or initial load), default to light mode
    selectedColorIndex = colors.selectedColorIndex ??
        0; // set active color to user's last preference; if none found (or initial load), default to amber
    initialIndex = isDark ? 0 : 1; //set toggle to match dark mode

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
      body: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Change colors',
                        style: Theme.of(context).textTheme.headline1,
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
                              activeFgColor: Theme.of(context).accentColor,
                              inactiveBgColor: Colors.grey,
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
                                  context);
                            }),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                              bottom: Radius.circular(20),
                            ),
                          ),
                          primary: Colors
                              .amber, // Default color is amber, hence it is hardcoded
                        ),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                        // Default is Amber/Light mode
                        onPressed: () {
                          colors.setSelectedColorIndex(0);
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
