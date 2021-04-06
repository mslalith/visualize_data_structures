import 'package:visualize_data_structures/features/search/binary_search/binary_search_provider.dart';

class BinarySearchHistoryItem {
  final int id;
  final int low;
  final int mid;
  final int high;
  final BinarySearchState state;

  const BinarySearchHistoryItem({
    required this.id,
    required this.low,
    required this.mid,
    required this.high,
    required this.state,
  });
}
