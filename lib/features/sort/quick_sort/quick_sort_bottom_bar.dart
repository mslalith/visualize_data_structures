import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_provider.dart';

import 'quick_sort_settings_view.dart';

class QuickSortBottomBar extends StatefulWidget {
  @override
  _QuickSortBottomBarState createState() => _QuickSortBottomBarState();
}

class _QuickSortBottomBarState extends State<QuickSortBottomBar> {
  QuickSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<QuickSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _QuickSortBottomBarMobile();
        }
        return _QuickSortBottomBar();
      },
    );
  }
}

class _QuickSortBottomBarMobile extends StatelessWidget {
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
            averageTime: 'O(n logn)',
            bestTime: 'O(n logn)',
            space: 'O(n)',
          ),
          ToRemember(
            points: [
              'Quick Sort is sometimes called Partition-Exchange Sort.',
              'Like Merge Sort, Quick Sort is a Divide and Conquer algorithm. It is an efficient sorting algorithm.',
              'When implemented well, it can be about two or three times faster than its main competitors, Merge Sort and Heap Sort.',
              'It picks an element as pivot and partitions the given array around the picked pivot.',
              'There are many different versions of quickSort that pick pivot in different ways:\n  1. Always pick first element as pivot.\n  2. Always pick last element as pivot.\n  3. Pick a random element as pivot.\n  4. Pick median as pivot.',
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickSortBottomBar extends StatelessWidget {
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
          QuickSortSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Quick Sort is sometimes called Partition-Exchange Sort.',
              'Like Merge Sort, Quick Sort is a Divide and Conquer algorithm. It is an efficient sorting algorithm.',
              'When implemented well, it can be about two or three times faster than its main competitors, Merge Sort and Heap Sort.',
              'It picks an element as pivot and partitions the given array around the picked pivot.',
              'There are many different versions of quickSort that pick pivot in different ways:\n  1. Always pick first element as pivot.\n  2. Always pick last element as pivot.\n  3. Pick a random element as pivot.\n  4. Pick median as pivot.',
            ],
          ),
        ],
      ),
    );
  }
}
