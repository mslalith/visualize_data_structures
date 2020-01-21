import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort_provider.dart';

class BubbleSortHistoryItem {
  final int id;
  final List<int> array;
  final int i;
  final int j;
  final BubbleSortState state;

  BubbleSortHistoryItem({
    this.id,
    this.array,
    this.i,
    this.j,
    this.state,
  });
}
