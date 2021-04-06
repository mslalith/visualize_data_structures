import 'dart:collection' show Queue;

import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_provider.dart';

class QuickSortHistoryItem {
  final int id;
  final Queue<int> queue;
  final List<int> oldArray;
  final List<int> array;
  final QuickSortState? state;
  final int left;
  final int right;
  final int i;
  final int j;
  final int p;
  final int pivot;

  const QuickSortHistoryItem({
    required this.id,
    required this.queue,
    required this.oldArray,
    required this.array,
    required this.state,
    required this.left,
    required this.right,
    required this.i,
    required this.j,
    required this.p,
    required this.pivot,
  });
}
