import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'bubble_sort_history_item.dart';

class BubbleSortProvider extends ChangeNotifier {
  Set<BubbleSortHistoryItem> _history = {};

  bool isSwapping = false;

  bool get isCompleted => _iIndex == -1;

  BubbleSortState _state = BubbleSortState.compare;

  BubbleSortState get state => _state;

  List<int> _array = [];

  List<int> get array => _array;
  List<int> _oldArray = [];

  List<int> get oldArray => _oldArray;

  int initialMinArrayValue = 20;
  int initialMaxArrayValue = 99;
  int _maxArrayValue = 100;

  int get maxArrayValue => _maxArrayValue;

  double minArraySize = 2;
  int maxArraySize = 13;
  double _arraySize = 10;

  double get arraySize => _arraySize;

  int _iIndex = 0;

  int get iIndex => _iIndex;

  int get iThValue => _array[_iIndex];

  int _jIndex = 1;

  int get jIndex => _jIndex;

  int get jThValue => _array[_jIndex];

  int get nextJThValue => _array[_jIndex + 1];

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

  void _updateState(BubbleSortState state, {notify = true}) {
    if (_state != state) {
      _state = state;
      if (notify) notifyListeners();
    }
  }

  void _updateIIndex(int index, {notify = true}) {
    if (_iIndex != index) {
      _iIndex = index;
      if (notify) notifyListeners();
    }
  }

  void _updateJIndex(int index, {notify = true}) {
    if (_jIndex != index) {
      _jIndex = index;
      if (notify) notifyListeners();
    }
  }

  void _updateArray(List<int> list, {notify = true}) {
    _array = list;
    if (notify) notifyListeners();
  }

  void matchArrays() {
    _oldArray = List<int>.from(_array);
  }

  Set<int> changedIndexes() {
    Set<int> set = {};
    if (_array.length == _oldArray.length) {
      for (int i = 0; i < _array.length; i++) {
        if (_array[i] != _oldArray[i]) set.add(i);
      }
    }
    return set;
  }

  void generateArray({notify = true}) {
    Random random = Random();
    int max = _maxArrayValue;
    List<int> list = [];
    while (list.length < _arraySize) {
      int number = random.nextInt(max) + 1;
      if (!list.contains(number)) list.add(number);
    }
    _updateArray(list, notify: notify);
    _reset(notify: notify);
  }

  void _reset({notify = true}) {
    _history = {};
    _oldArray = [];
    _updateState(BubbleSortState.compare, notify: notify);
    _updateIIndex(0, notify: notify);
    _updateJIndex(0, notify: notify);
    isSwapping = false;
  }

  bool get shouldSwap => jThValue > nextJThValue;

  List<int> _swap(a, i, j) {
    int temp = a[i];
    a[i] = a[j];
    a[j] = temp;
    return a;
  }

  void _toNextIIndex({notify = true}) {
    if (_iIndex < _arraySize - 2) {
      _updateIIndex(_iIndex + 1, notify: notify);
    } else {
      _updateIIndex(-1, notify: notify);
      if (notify) notifyListeners();
    }
  }

  void _toNextJIndex({notify = true}) {
    if (_jIndex < _arraySize - _iIndex - 2) {
      _updateJIndex(_jIndex + 1, notify: notify);
    } else {
      _toNextIIndex(notify: notify);
      _updateJIndex(0, notify: notify);
      if (notify) notifyListeners();
    }
  }

  void stepForward() {
    if (!isCompleted && !isSwapping) {
      _history.add(
        BubbleSortHistoryItem(
          id: _history.length,
          state: _state,
          array: List<int>.from(_array),
          i: _iIndex,
          j: _jIndex,
        ),
      );
      if (_state == BubbleSortState.compare) {
        if (shouldSwap) {
          _oldArray = List<int>.from(_array);
          _updateArray(_swap(_array, _jIndex, _jIndex + 1), notify: false);
          _updateState(BubbleSortState.swap, notify: false);
        } else {
          _toNextJIndex(notify: false);
        }
      } else if (_state == BubbleSortState.swap) {
        _toNextJIndex(notify: false);
        _updateState(BubbleSortState.compare, notify: false);
      }
//      notifyListeners();
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      if (!isSwapping) {
        BubbleSortHistoryItem item = _history.last;
        if (item.state == BubbleSortState.swap) {
          _history.remove(item);
          item = _history.last;
        }
        _updateArray(item.array, notify: false);
        _updateState(item.state, notify: false);
        _updateIIndex(item.i, notify: false);
        _updateJIndex(item.j, notify: false);
        _history.remove(item);
//        notifyListeners();
      }
    }
  }

  void notify() => notifyListeners();

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

enum BubbleSortState {
  compare,
  swap,
}
