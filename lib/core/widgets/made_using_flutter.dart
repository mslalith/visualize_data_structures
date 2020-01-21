import 'package:flutter/material.dart';

class MadeUsingFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlutterLogo(size: 44.0),
          SizedBox(width: 6.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Made Using',
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(height: 2.0),
              Text(
                'Flutter',
                style: Theme.of(context).textTheme.title,
              ),
            ],
          ),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
