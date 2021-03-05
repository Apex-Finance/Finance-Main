import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  Widget _colorOption(
      String name, Color color1, Color color2, BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
          bottom: Radius.circular(20),
        ),
      ),
      color: Colors.grey[500],
      child: Row(
        children: [
          Icon(Icons.circle),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            width: 30,
            height: 20,
            color: color1,
          ),
          Container(
            width: 30,
            height: 20,
            color: color2,
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ),
      body: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        )),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              child: ListTile(
                tileColor: Colors.grey[800],
                title: Column(
                  children: [
                    Text(
                      'Change colors',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
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
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.black,
                          labels: ['YES', 'NO'],
                          icons: [
                            Icons.check,
                            Icons.highlight_off,
                          ],
                          onToggle: (index) {
                            print('switched to: $index');
                          },
                        ),
                      ],
                    ),
                    _colorOption(
                        'Black', Colors.grey[900], Colors.black, context),
                    _colorOption('Dark Blue', Colors.blue[900],
                        Colors.indigo[900], context),
                    _colorOption(
                        'Amber', Colors.amber, Colors.amber[50], context),
                    _colorOption('Light Blue', Colors.blue[700],
                        Colors.blue[50], context),
                    _colorOption(
                        'Light Green', Colors.green, Colors.green[50], context),
                    _colorOption('Pink', Colors.pink, Colors.pink[50], context),
                    _colorOption(
                        'Purple', Colors.purple, Colors.purple[900], context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
