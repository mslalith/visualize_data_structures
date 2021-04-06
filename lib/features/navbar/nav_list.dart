import 'package:flutter/material.dart';
import 'package:visualize_data_structures/features/navbar/nav_item.dart';
import 'package:visualize_data_structures/features/navbar/nav_list_item.dart';

class NavList extends StatefulWidget {
  @override
  _NavListState createState() => _NavListState();
}

class _NavListState extends State<NavList> {
  List<NavItem> navItems = [
    NavItem(
      name: 'Search',
      topics: [
        'Linear Search',
        'Binary Search',
      ],
    ),
    NavItem(
      name: 'Sort',
      topics: [
        'Bubble Sort',
        'Selection Sort',
        'Insertion Sort',
        'Quick Sort',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (NavItem item in navItems) NavListItem(item: item)
        ],
      ),
    );
  }
}
