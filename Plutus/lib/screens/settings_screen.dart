import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.bodyText1,
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'black',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.grey[900],
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.black,
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Dark Blue',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.blue[900],
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.indigo[900],
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Amber',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.amber,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.amber[50],
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Light Blue',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.blue[700],
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.blue[50],
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Light Green',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.green,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.green[50],
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Pink',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.pink,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.pink[50],
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
                          Icon(Icons.circle),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              'Purple',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.purple,
                          ),
                          Container(
                            width: 30,
                            height: 20,
                            color: Colors.purple[900],
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
