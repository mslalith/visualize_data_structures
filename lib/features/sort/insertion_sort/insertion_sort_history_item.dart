import 'insertion_sort_provider.dart';

class InsertionSortHistoryItem {
  final int id;
  final List<int> oldArray;
  final List<int> array;
  final InsertionSortState state;
  final int i;
  final int j;
  final int key;
  final int emptyIndex;

  InsertionSortHistoryItem({
    this.id,
    this.oldArray,
    this.array,
    this.state,
    this.i,
    this.j,
    this.key,
    this.emptyIndex,
  });
}
