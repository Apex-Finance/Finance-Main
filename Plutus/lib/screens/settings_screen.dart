import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Settings Screen',
            style: Theme.of(context).textTheme.bodyText1,
          ),
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
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            'Dark mode',
                            style: Theme.of(context).textTheme.bodyText2,
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
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      color: Colors.grey[500],
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'text',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      color: Colors.grey[500],
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'titles',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      color: Colors.grey[500],
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'icons',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                          bottom: Radius.circular(20),
                        ),
                      ),
                      color: Colors.grey[500],
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'backgrounds',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.circle,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                      onPressed: () {},
                    ),
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
