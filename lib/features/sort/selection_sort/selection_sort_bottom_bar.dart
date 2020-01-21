import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';

import 'selection_sort_provider.dart';
import 'selection_sort_settings_view.dart';

class SelectionSortBottomBar extends StatefulWidget {
  @override
  _SelectionSortBottomBarState createState() => _SelectionSortBottomBarState();
}

class _SelectionSortBottomBarState extends State<SelectionSortBottomBar> {
  SelectionSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SelectionSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _SelectionSortBottomBarMobile();
        }
        return _SelectionSortBottomBar();
      },
    );
  }
}

class _SelectionSortBottomBarMobile extends StatelessWidget {
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
            bestTime: 'O(n\u00B2)',
            space: 'O(1)',
          ),
          ToRemember(
            points: [
              'Selection sort is an In-place Comparison Sort.',
              'The algorithm divides the input list into two parts: the sublist which is already sorted and remaining subarray which is unsorted.',
              'Repeatedly finds the minimum element from unsorted part and putting it at the end of the sorted part.',
              'It never makes more than O(n) swaps and can be useful when memory write is a costly operation.',
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionSortBottomBar extends StatelessWidget {
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
          SelectionSortSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Selection sort is an In-place Comparison Sort.',
              'The algorithm divides the input list into two parts: the sublist which is already sorted and remaining subarray which is unsorted.',
              'Repeatedly finds the minimum element from unsorted part and putting it at the end of the sorted part.',
              'It never makes more than O(n) swaps and can be useful when memory write is a costly operation.',
            ],
          ),
        ],
      ),
    );
  }
}
