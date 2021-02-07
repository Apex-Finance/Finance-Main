import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Settings Screen',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Column(
        children: [
          Text(
            'Change colors',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Row(
            children: [
              Text(
                'text',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // IconButton(
              //icon:
              Icon(
                Icons.circle,
                size: 20,
                color: Theme.of(context).primaryColor,
                //onPressed: () {},
              ),
              // ),
            ],
          ),
          Row(
            children: [
              Text(
                'titles',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // IconButton(
              //icon:
              Icon(
                Icons.circle,
                size: 20,
                color: Theme.of(context).primaryColor,
                //onPressed: () {},
              ),
              // ),
            ],
          ),
          Row(
            children: [
              Text(
                'background',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // IconButton(
              //icon:
              Icon(
                Icons.circle,
                size: 20,
                color: Theme.of(context).primaryColor,
                //onPressed: () {},
              ),
              // ),
            ],
          ),
          Row(
            children: [
              Text(
                'icons',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              // IconButton(
              //icon:
              Icon(
                Icons.circle,
                size: 20,
                color: Theme.of(context).primaryColor,
                //onPressed: () {},
              ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
