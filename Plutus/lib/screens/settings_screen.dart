import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
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
