import 'package:visualize_data_structures/features/sort/insertion_sort/insertion_sort_provider.dart';

class InsertionSortHistoryItem {
  final int id;
  final List<int> oldArray;
  final List<int> array;
  final InsertionSortState? state;
  final int i;
  final int j;
  final int key;
  final int emptyIndex;

  const InsertionSortHistoryItem({
    required this.id,
    required this.oldArray,
    required this.array,
    required this.state,
    required this.i,
    required this.j,
    required this.key,
    required this.emptyIndex,
  });
}
