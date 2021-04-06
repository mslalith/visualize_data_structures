import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:visualize_data_structures/core/widgets/complexity_widget.dart';
import 'package:visualize_data_structures/core/widgets/to_remember.dart';
import 'package:visualize_data_structures/features/search/linear_search/linear_search_provider.dart';
import 'package:visualize_data_structures/features/search/linear_search/linear_search_settings_view.dart';

class LinearSearchBottomBar extends StatefulWidget {
  @override
  _LinearSearchBottomBarState createState() => _LinearSearchBottomBarState();
}

class _LinearSearchBottomBarState extends State<LinearSearchBottomBar> {
  late LinearSearchProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LinearSearchProvider>(context);
    return ResponsiveBuilder(
      builder: (_, sizingInfo) {
        if (sizingInfo.isMobile) {
          return _LinearSearchBottomBarMobile();
        }
        return _LinearSearchBottomBar();
      },
    );
  }
}

class _LinearSearchBottomBarMobile extends StatelessWidget {
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
            worstTime: 'O(n)',
            averageTime: 'O(n)',
            bestTime: 'O(1)',
            space: 'O(1)',
          ),
          ToRemember(
            points: [
              'Linear Search is also known as Sequential Search.',
              'sequentially checks each element of the list until a match is found.',
            ],
          ),
        ],
      ),
    );
  }
}

class _LinearSearchBottomBar extends StatelessWidget {
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
          LinearSearchSettingsView(),
          Spacer(),
          ToRemember(
            points: [
              'Linear Search is also known as Sequential Search.',
              'sequentially checks each element of the list until a match is found.',
            ],
          ),
        ],
      ),
    );
  }
}
