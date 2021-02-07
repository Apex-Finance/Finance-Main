import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:percent_indicator/percent_indicator.dart';

class GoalsListTile extends StatefulWidget {
  @override
  _GoalsListTileState createState() => _GoalsListTileState();
}

class _GoalsListTileState extends State<GoalsListTile> {
  DateTime _date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: ListTile(
          tileColor: Colors.grey[850],
          leading: Image.network(
            'https://2p2bboli8d61fqhjiqzb8p1a-wpengine.netdna-ssl.com/wp-content/uploads/2018/07/1.jpg',
            alignment: Alignment.center,
          ),

          // leading: ClipRRect(
          //   borderRadius: BorderRadius.all(Radius.circular(20)),
          //   // TODO this may need to be a constrained box
          //   // max height and width should be 256 x 256 (icon dimensions)
          //   child: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       minWidth: 44,
          //       minHeight: 44,
          //       maxWidth: 70,
          //       maxHeight: 70,
          //     ),
          //     // TODO Make this image icon bigger!
          //     child: Image.network(
          //         'https://cdn.carbuzz.com/gallery-images/840x560/243000/300/243339.jpg'),
          //   ),
          // ),
          title: Text(
            "Lambroghini Reventon",
            style: Theme.of(context).textTheme.headline1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$10,000",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 10,
              ),
              new LinearPercentIndicator(
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width * .57,
                lineHeight: 12.0,
                backgroundColor: Colors.black,
                progressColor: Colors.amber,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${DateFormat.yMMMd().format(_date)}",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Text(
                    "\$1,400,000",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
