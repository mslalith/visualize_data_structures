import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'insertion_sort_history_item.dart';

class InsertionSortProvider extends ChangeNotifier {
  Set<InsertionSortHistoryItem> _history = {};
  bool isSwapping = false;
  bool isCompleted = false;

  InsertionSortState _state;

  InsertionSortState get state => _state;

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

  int _key = 0;

  int get key => _key;

  int _emptyIndex = 0;

  int get emptyIndex => _emptyIndex;

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
    isCompleted = false;
    _oldArray = List<int>.from(_array);
    _state = InsertionSortState.none;
    _updateIIndex(1, notify: notify);
    _updateJIndex(0, notify: notify);
    _key = iThValue;
    _emptyIndex = _iIndex;
    isSwapping = false;
  }

  bool get isJMin => jThValue < _key;

  bool get isNoneState => _state == InsertionSortState.none;

  bool get isLiftKeyState => _state == InsertionSortState.liftKey;

  bool get isFindMinPlaceState => _state == InsertionSortState.findMinPlace;

  bool get isSwapAndContinueState =>
      _state == InsertionSortState.swapAndContinue;

  bool get isSwapKeyState => _state == InsertionSortState.swapKey;

  bool get isNextState => _state == InsertionSortState.next;

  List<int> _swap(a, i, j) {
    int temp = a[i];
    a[i] = a[j];
    a[j] = temp;
    return a;
  }

  void stepForward() {
    if (!isCompleted && !isSwapping) {
      if (isNoneState) {
        _history.add(
          InsertionSortHistoryItem(
            id: _history.length,
            oldArray: List<int>.from(_oldArray),
            array: List<int>.from(_array),
            state: _state,
            i: _iIndex,
            j: _jIndex,
            key: _key,
            emptyIndex: _emptyIndex,
          ),
        );
      }
      if (isNoneState) {
        if (jThValue > _key)
          _state = InsertionSortState.liftKey;
        else {
          _state = InsertionSortState.next;
          stepForward();
        }
      } else if (isLiftKeyState) {
        _state = InsertionSortState.findMinPlace;
      } else if (isFindMinPlaceState) {
        if (_jIndex >= 0 && jThValue > _key) {
          _oldArray = List<int>.from(_array);
          _updateArray(_swap(_array, _jIndex, _jIndex + 1), notify: false);
          _emptyIndex = _jIndex;
          _state = InsertionSortState.swapAndContinue;
          stepForward();
        } else {
          _state = InsertionSortState.swapKey;
        }
      } else if (isSwapAndContinueState) {
        if (_jIndex > 0) {
          _updateJIndex(_jIndex - 1, notify: false);
          _state = InsertionSortState.findMinPlace;
        } else {
          _state = InsertionSortState.swapKey;
        }
      } else if (isSwapKeyState) {
        _oldArray = List<int>.from(_array);
        _state = InsertionSortState.next;
        stepForward();
      } else if (isNextState) {
        if (_iIndex < _array.length - 1) {
          _updateIIndex(_iIndex + 1, notify: false);
          _updateJIndex(_iIndex - 1, notify: false);
          _key = iThValue;
          _emptyIndex = _iIndex;
          _state = InsertionSortState.none;
        } else if (_iIndex == _array.length - 1) {
          isCompleted = true;
          stepForward();
        }
      }
//      notifyListeners();
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      isCompleted = false;
      if (!isSwapping) {
        InsertionSortHistoryItem item = _history.last;
        _oldArray = item.oldArray;
        _updateArray(item.array, notify: false);
        _state = item.state;
        _updateIIndex(item.i, notify: false);
        _updateJIndex(item.j, notify: false);
        _key = item.key;
        _emptyIndex = item.emptyIndex;
        _history.remove(item);
//        notifyListeners();
      }
    }
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

enum InsertionSortState {
  none,
  liftKey,
  findMinPlace,
  swapAndContinue,
  swapKey,
  next,
}
