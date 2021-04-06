import 'package:visualize_data_structures/features/sort/selection_sort/selection_sort_provider.dart';

class SelectionSortHistoryItem {
  final int id;
  final List<int> array;
  final int i;
  final int j;
  final int min;
  final SelectionSortState state;

  const SelectionSortHistoryItem({
    required this.id,
    required this.array,
    required this.i,
    required this.j,
    required this.min,
    required this.state,
  });
}
