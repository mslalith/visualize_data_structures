import 'package:flutter/material.dart';
import 'package:visualize_data_structures/features/search/binary_search/binary_search.dart';
import 'package:visualize_data_structures/features/search/linear_search/linear_search.dart';
import 'package:visualize_data_structures/features/sort/bubble_sort/bubble_sort.dart';
import 'package:visualize_data_structures/features/sort/insertion_sort/insertion_sort.dart';
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort.dart';
import 'package:visualize_data_structures/features/sort/selection_sort/selection_sort.dart';

class TopicProvider extends ChangeNotifier {
  static const String INITIAL_TOPIC = LinearSearch.KEY;

  String _currentTopic = '';

  String get currentTopic => _currentTopic;

  Widget _currentWidget;

  Widget get currentWidget => _currentWidget;

  void initialize() {
    _currentTopic = INITIAL_TOPIC;
    updateWidget(_currentTopic);
    updateTopic(_currentTopic, notify: false);
  }

  void updateTopic(String topic, {notify = true}) {
    if (_currentTopic != topic) {
      _currentTopic = topic;
      updateWidget(topic);
      if (notify) notifyListeners();
    }
  }

  void updateWidget(String topic) {
    switch (topic) {
      case LinearSearch.KEY:
        _currentWidget = LinearSearch();
        break;
      case BinarySearch.KEY:
        _currentWidget = BinarySearch();
        break;
      case BubbleSort.KEY:
        _currentWidget = BubbleSort();
        break;
      case SelectionSort.KEY:
        _currentWidget = SelectionSort();
        break;
      case InsertionSort.KEY:
        _currentWidget = InsertionSort();
        break;
      case QuickSort.KEY:
        _currentWidget = QuickSort();
        break;
      default:
        _currentWidget = null;
        break;
    }
  }
}
