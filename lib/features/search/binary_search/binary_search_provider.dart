import 'dart:math' show Random;

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:visualize_data_structures/features/search/binary_search/binary_search_history_item.dart';

class BinarySearchProvider extends ChangeNotifier {
  Set<BinarySearchHistoryItem> _history = {};
  bool isFirst = true;

  bool get isCompleted => _mid == _searchIndex && !isFirst;

  List<int> _array = [];

  List<int> get array => _array;

  List<int> get arrayInterval => _array.sublist(_low, _high + 1);

  int initialMinArrayValue = 20;
  int initialMaxArrayValue = 99;
  int _maxArrayValue = 100;

  int get maxArrayValue => _maxArrayValue;

  double minArraySize = 1;
  int maxArraySize = 13;
  double _arraySize = 10;

  double get arraySize => _arraySize;

  int? _searchIndex;

  int? get searchIndex => _searchIndex;

  int get searchValue => _array[_searchIndex!];

  int get currentValue => _mid != -1 ? _array[_mid] : -1;

  int _low = 0;

  int get low => _low;

  int _high = 0;

  int get high => _high;

  int _mid = -1;

  int get mid => _mid;

  BinarySearchState _state = BinarySearchState.findMid;

  BinarySearchState get state => _state;

  bool get isLeftInterval => _searchIndex! < _mid;

  bool get isRightInterval => _searchIndex! > _mid;

  void initialize() {
    _history = {};
    updateMaxArrayValue(initialMinArrayValue, notify: false);
    generateArray(notify: false);
  }

  void updateArraySize(double value, {notify = true}) {
    if (_arraySize != value) {
      _arraySize = value.floor().toDouble();
      if (isCompleted) generateArray(notify: notify);
      if (notify) notifyListeners();
    }
  }

  void updateMaxArrayValue(int value, {notify = true}) {
    if (_maxArrayValue != value) {
      _maxArrayValue = value;
      if (isCompleted) generateArray(notify: notify);
      if (notify) notifyListeners();
    }
  }

  void _updateLow(int index, {notify = true}) {
    if (_low != index) {
      _low = index;
      if (notify) notifyListeners();
    }
  }

  void _updateMid(int index, {notify = true}) {
    if (_mid != index) {
      _mid = index;
      if (notify) notifyListeners();
    }
  }

  void _updateHigh(int index, {notify = true}) {
    if (_high != index) {
      _high = index;
      if (notify) notifyListeners();
    }
  }

  void _updateSearchIndex(int index, {notify = true}) {
    if (_searchIndex != index) {
      _searchIndex = index;
      if (notify) notifyListeners();
    }
  }

  void _updateArray(List<int> generatedList, {notify = true}) {
    _array = generatedList;
    if (notify) notifyListeners();
  }

  void generateArray({notify = true}) {
    Random random = Random();
    int max = _maxArrayValue;
    List<int> list = [];
    while (list.length < _arraySize) {
      int number = random.nextInt(max) + 1;
      if (!list.contains(number)) list.add(number);
    }
    list.sort();
    _updateArray(list, notify: notify);
    _reset(notify: notify);
  }

  void _reset({notify = true}) {
    _history = {};
    isFirst = true;
    _updateSearchIndex(_getRandomSearchIndex(), notify: notify);
    _state = BinarySearchState.findMid;
    _updateMid(-1, notify: notify);
    _updateLow(0, notify: notify);
    _updateHigh(_array.length - 1, notify: notify);
  }

  int _getRandomSearchIndex() {
    Random random = Random();
    int index = random.nextInt(_array.length);
    if (index >= _array.length) index %= _array.length;
    return index;
  }

  void _toggleState() {
    if (_state == BinarySearchState.findMid)
      _state = BinarySearchState.selectInterval;
    else
      _state = BinarySearchState.findMid;
  }

  void _findMid() {
    int mid = (_low + (_high - _low) / 2).toInt();
    _updateMid(mid, notify: false);
  }

  void stepForward() {
    if (!isCompleted) {
      isFirst = false;
      _history.add(
        BinarySearchHistoryItem(
          id: _history.length,
          low: _low,
          mid: _mid,
          high: _high,
          state: _state,
        ),
      );
      if (_state == BinarySearchState.findMid) {
        _findMid();
      } else if (_state == BinarySearchState.selectInterval) {
        if (isLeftInterval)
          _updateHigh(_mid - 1, notify: false);
        else if (isRightInterval) _updateLow(_mid + 1, notify: false);
      }
      _toggleState();
//      notifyListeners();
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      BinarySearchHistoryItem item = _history.last;
      _updateLow(item.low, notify: false);
      _updateMid(item.mid, notify: false);
      _updateHigh(item.high, notify: false);
      _state = item.state;
      _history.remove(item);
//      notifyListeners();
    } else
      isFirst = true;
  }

  void stepForwardAndNotify() {
    stepForward();
    notifyListeners();
  }

  void stepBackAndNotify() {
    stepBack();
    notifyListeners();
  }

  bool get canGoBack => _history.isNotEmpty;

  bool get canGoForward => !isCompleted;
}

enum BinarySearchState {
  findMid,
  selectInterval,
}
