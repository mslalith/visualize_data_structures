import 'package:flutter/material.dart';

import 'expanded_widget.dart';

class ComplexityWidget extends StatelessWidget {
  final String worstTime;
  final String averageTime;
  final String bestTime;
  final String space;
  final bool shouldExpand;

  const ComplexityWidget({
    Key key,
    this.worstTime,
    this.averageTime,
    this.bestTime,
    this.space,
    this.shouldExpand = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandedWidget<String>(
      openWidth: 220.0,
      closeWidth: 140.0,
      shouldExpand: shouldExpand,
      title: Text(
        'Complexity',
        style: Theme.of(context).textTheme.subhead,
      ),
      children: [
        'Worst (t)\t=\t$worstTime',
        'Avg (t)\t=\t$averageTime',
        'Best (t)\t=\t$bestTime',
        'Space (s)\t=\t$space',
      ],
      builder: (String text) {
        List<String> data = text.split('\t');
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 2.0,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(data[0]),
                ),
              ),
              Text(data[1]),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    data[2],
                    style: TextStyle(letterSpacing: 1.1),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
