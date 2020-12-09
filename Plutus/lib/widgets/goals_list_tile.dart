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
    return Card(
      // TODO Round these edges
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Container(
        height: 100,
        child: ListTile(
          tileColor: Colors.grey[850],
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // TODO this may need to be a constrained box
            // max height and width should be 256 x 256 (icon dimensions)
            child: Container(
              // TODO Make this image icon bigger!
              child: Image.network(
                  'https://c-sf.smule.com/rs-s62/arr/03/75/7744782c-6b94-409d-93d0-61bda6d57ef9.jpg'),
            ),
          ),
          title: Text(
            "Lambroghini Reventon",
            style: Theme.of(context).textTheme.bodyText2,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "\$10,000",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              new LinearPercentIndicator(
                padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                alignment: MainAxisAlignment.center,
                width: MediaQuery.of(context).size.width * .66,
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 5,
                    ),
                    child: Text(
                      "\$1,400,000",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
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
