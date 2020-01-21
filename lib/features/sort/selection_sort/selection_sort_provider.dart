import 'dart:math' show Random;

import 'package:flutter/material.dart';

import 'selection_sort_history_item.dart';

class SelectionSortProvider extends ChangeNotifier {
  Set<SelectionSortHistoryItem> _history = {};
  bool isSwapping = false;
  bool isCompleted = false;

  SelectionSortState _state = SelectionSortState.findMin;

  SelectionSortState get state => _state;

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

  int _minIndex = 1;

  int get minIndex => _minIndex;

  int get minThValue => _array[_minIndex];

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

  void _updateMinIndex(int index, {notify = true}) {
    if (_minIndex != index) {
      _minIndex = index;
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
    isCompleted = false;
    _state = SelectionSortState.findMin;
    _updateIIndex(0, notify: notify);
    _updateJIndex(1, notify: notify);
    _updateMinIndex(_iIndex, notify: notify);
	isSwapping = false;
  }

  bool get isJMin => jThValue < minThValue;

  bool get isJLast => _jIndex == _arraySize - 1;

  List<int> _swap(a, i, j) {
    int temp = a[i];
    a[i] = a[j];
    a[j] = temp;
    return a;
  }

  void stepForward() {
    if (!isCompleted && !isSwapping) {
      _history.add(
        SelectionSortHistoryItem(
          id: _history.length,
          array: List<int>.from(_array),
          state: _state,
          i: _iIndex,
          j: _jIndex,
          min: _minIndex,
        ),
      );
      if (_state == SelectionSortState.findMin) {
        if (isJMin) {
          _updateMinIndex(_jIndex, notify: false);
        }
        if (_jIndex < _arraySize - 1)
          _updateJIndex(_jIndex + 1, notify: false);
        else if (jIndex == _arraySize - 1) {
          _oldArray = List<int>.from(_array);
          _updateArray(_swap(_array, _iIndex, _minIndex), notify: false);
          _state = SelectionSortState.swap;
        }
      } else if (_state == SelectionSortState.swap) {
        if (_iIndex < _arraySize - 2) {
          _updateIIndex(_iIndex + 1, notify: false);
          _updateMinIndex(_iIndex, notify: false);
          _updateJIndex(_iIndex + 1, notify: false);
          _state = SelectionSortState.findMin;
        } else {
          if (iThValue > jThValue) {
            _oldArray = List<int>.from(_array);
            _updateArray(_swap(_array, _iIndex, _jIndex), notify: false);
            _state = SelectionSortState.swap;
          } else isCompleted = true;
        }
      }
//      notifyListeners();
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      isCompleted = false;
      if (!isSwapping) {
        SelectionSortHistoryItem item = _history.last;
        if (item.state == SelectionSortState.swap) {
          _history.remove(item);
          item = _history.last;
        }
        _updateArray(item.array, notify: false);
        _updateIIndex(item.i, notify: false);
        _updateJIndex(item.j, notify: false);
        _updateMinIndex(item.min, notify: false);
        _state = item.state;
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

enum SelectionSortState {
  findMin,
  swap,
}
