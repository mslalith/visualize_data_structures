import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';

import 'insertion_sort_settings_view.dart';
import 'insertion_sort_provider.dart';

class InsertionSortBottomBar extends StatefulWidget {
  @override
  _InsertionSortBottomBarState createState() => _InsertionSortBottomBarState();
}

class _InsertionSortBottomBarState extends State<InsertionSortBottomBar> {
  InsertionSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<InsertionSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _InsertionSortBottomBarMobile();
        }
        return _InsertionSortBottomBar();
      },
    );
  }
}

class _InsertionSortBottomBarMobile extends StatelessWidget {
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
            worstTime: 'O(n\u00B2)',
            averageTime: 'O(n\u00B2)',
            bestTime: 'O(n)',
            space: 'O(n)',
          ),
          ToRemember(
            points: [
              'Insertion sort builds the final sorted array one item at a time.',
              'The sorted array is built by consuming input element in each iteration to find its correct position.',
              'This is used when number of elements is small. It can also be useful when input array is almost sorted.',
              'This takes maximum time to sort if elements are sorted in reverse order.',
            ],
          ),
        ],
      ),
    );
  }
}

class _InsertionSortBottomBar extends StatelessWidget {
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
          InsertionSortSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Insertion sort builds the final sorted array one item at a time.',
              'The sorted array is built by consuming input element in each iteration to find its correct position.',
              'This is used when number of elements is small. It can also be useful when input array is almost sorted.',
              'This takes maximum time to sort if elements are sorted in reverse order.',
            ],
          ),
        ],
      ),
    );
  }
}
