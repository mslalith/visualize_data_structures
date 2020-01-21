import 'binary_search_provider.dart';

class BinarySearchHistoryItem {
  final int id;
  final int low;
  final int mid;
  final int high;
  final BinarySearchState state;

  BinarySearchHistoryItem({
    this.id,
    this.low,
    this.mid,
    this.high,
    this.state,
  });
}
