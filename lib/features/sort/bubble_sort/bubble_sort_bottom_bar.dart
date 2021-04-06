import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_provider.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_settings_view.dart';

class BubbleSortBottomBar extends StatefulWidget {
  @override
  _BubbleSortBottomBarState createState() => _BubbleSortBottomBarState();
}

class _BubbleSortBottomBarState extends State<BubbleSortBottomBar> {
  late BubbleSortProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<BubbleSortProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _BubbleSortBottomBarMobile();
        }
        return _BubbleSortBottomBar();
      },
    );
  }
}

class _BubbleSortBottomBarMobile extends StatelessWidget {
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
            space: 'O(1)',
          ),
          ToRemember(
            points: [
              'Bubble sort is sometimes referred to as Sinking Sort.',
              'compares adjacent elements and swaps them if they are in the wrong order. This is repeated until the list is sorted.',
              'Although the algorithm is simple, it is too slow and impractical for most problems.',
              'Bubble sort can be practical if the input is in mostly sorted order with some out-of-order elements nearly in position.',
            ],
          ),
        ],
      ),
    );
  }
}

class _BubbleSortBottomBar extends StatelessWidget {
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
          BubbleSortSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Bubble sort is sometimes referred to as Sinking Sort.',
              'compares adjacent elements and swaps them if they are in the wrong order. This is repeated until the list is sorted.',
              'Although the algorithm is simple, it is too slow and impractical for most problems.',
              'Bubble sort can be practical if the input is in mostly sorted order with some out-of-order elements nearly in position.',
            ],
          ),
        ],
      ),
    );
  }
}
