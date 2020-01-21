import 'selection_sort_provider.dart';

class SelectionSortHistoryItem {
  final int id;
  final List<int> array;
  final int i;
  final int j;
  final int min;
  final SelectionSortState state;

  SelectionSortHistoryItem({
    this.id,
    this.array,
    this.i,
    this.j,
    this.min,
    this.state,
  });
}