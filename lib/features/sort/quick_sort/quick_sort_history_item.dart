import 'dart:collection' show Queue;

import 'quick_sort_provider.dart';

class QuickSortHistoryItem {
  final int id;
  final Queue<int> queue;
  final List<int> oldArray;
  final List<int> array;
  final QuickSortState state;
  final int left;
  final int right;
  final int i;
  final int j;
  final int p;
  final int pivot;

  QuickSortHistoryItem({
    this.id,
    this.queue,
    this.oldArray,
    this.array,
    this.state,
    this.left,
    this.right,
    this.i,
    this.j,
    this.p,
    this.pivot,
  });
}
