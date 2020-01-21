import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';

import 'binary_search_provider.dart';
import 'binary_search_settings_view.dart';

class BinarySearchBottomBar extends StatefulWidget {
  @override
  _BinarySearchBottomBarState createState() => _BinarySearchBottomBarState();
}

class _BinarySearchBottomBarState extends State<BinarySearchBottomBar> {
  BinarySearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BinarySearchProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _BinarySearchBottomBarMobile();
        }
        return _BinarySearchBottomBar();
      },
    );
  }
}

class _BinarySearchBottomBarMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 12.0,
      ),
      child: Column(
        children: <Widget>[
          ComplexityWidget(
            shouldExpand: false,
            worstTime: 'O(log n)',
            averageTime: 'O(log n)',
            bestTime: 'O(1)',
            space: 'O(1)',
          ),
          ToRemember(
            points: [
              'Binary Search is also known as Half-Interval Search, Logarithmic Search, Binary Chop.',
              'array should be sorted before searching.',
              'dividing the search interval in half.',
              'if the search value is less than the middle item of the interval, narrow the interval to the lower half. Otherwise narrow it to the upper half.',
              'repeatedly check until the search value is found or the interval is empty.',
            ],
          ),
        ],
      ),
    );
  }
}

class _BinarySearchBottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 12.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          BinarySearchSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Binary Search is also known as Half-Interval Search, Logarithmic Search, Binary Chop.',
              'array should be sorted before searching.',
              'dividing the search interval in half.',
              'if the search value is less than the middle item of the interval, narrow the interval to the lower half. Otherwise narrow it to the upper half.',
              'repeatedly check until the search value is found or the interval is empty.',
            ],
          ),
        ],
      ),
    );
  }
}
