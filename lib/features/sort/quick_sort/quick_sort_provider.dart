import 'dart:math' show Random;
import 'dart:collection' show Queue;

import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:visualize_data_structures/features/sort/quick_sort/quick_sort_history_item.dart';

class QuickSortProvider extends ChangeNotifier {
  Set<QuickSortHistoryItem> _history = {};
  bool isSwapping = false;
  bool isCompleted = false;

  QuickSortState? _state;

  QuickSortState? get state => _state;

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

  int? _jIndex;

  int? get jIndex => _jIndex;

  int get jThValue => _array[_jIndex!];

  int? _leftIndex;

  int? get leftIndex => _leftIndex;

  int get leftThValue => _array[_leftIndex!];

  int? _rightIndex;

  int? get rightIndex => _rightIndex;

  int get rightThValue => _array[_rightIndex!];

  int? _pivotIndex;

  int? get pivotIndex => _pivotIndex;

  late int pivotValue;

  late Queue<int> queue;

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
    _state = QuickSortState.none;
    _leftIndex = 0;
    _rightIndex = _array.length - 1;
    _iIndex = _leftIndex!;
    _jIndex = _rightIndex;
    _pivotIndex = -1;
    pivotValue = 0;

    queue = Queue();
    queue.addLast(_leftIndex!);
    queue.addLast(_rightIndex!);
    isSwapping = false;
    isCompleted = false;
  }

  bool get shouldSwap => _iIndex <= _jIndex!;

  bool get isNoneState => _state == QuickSortState.none;

  bool get isFindPivotState => _state == QuickSortState.findPivot;

  bool get isPartitionState => _state == QuickSortState.partition;

  bool get isFindLeftMaxState => _state == QuickSortState.findLeftMax;

  bool get isFindRightMinState => _state == QuickSortState.findRightMin;

  bool get isCompareState => _state == QuickSortState.compare;

  bool get isSwapState => _state == QuickSortState.swap;

  List<int> _swap(a, i, j) {
    final int temp = a[i];
    a[i] = a[j];
    a[j] = temp;
    return a;
  }

  void stepForward() {
    if (!isCompleted && !isSwapping) {
      if (!isNoneState) {
        _history.add(
          QuickSortHistoryItem(
            id: _history.length,
            queue: Queue<int>.from(queue),
            oldArray: List<int>.from(_oldArray),
            array: List<int>.from(_array),
            state: _state,
            left: _leftIndex!,
            right: _rightIndex!,
            i: _iIndex,
            j: _jIndex!,
            p: _pivotIndex!,
            pivot: pivotValue,
          ),
        );
      }
      if (isNoneState) {
        if (queue.isEmpty) {
          isCompleted = true;
          return;
        }
        _rightIndex = queue.removeLast();
        _leftIndex = queue.removeLast();
        _iIndex = _leftIndex!;
        _jIndex = _rightIndex;
        _state = QuickSortState.findPivot;
      }
      if (isFindPivotState) {
        _pivotIndex = (_iIndex + (_jIndex! - _iIndex) / 2).toInt();
        pivotValue = _array[_pivotIndex!];
        _state = QuickSortState.partition;
        stepForward();
      } else if (isPartitionState) {
        if (_iIndex <= _jIndex!) {
          _state = QuickSortState.findLeftMax;
        } else {
          if (_iIndex < _rightIndex!) {
            queue.addLast(_iIndex);
            queue.addLast(_rightIndex!);
          }
          if (_leftIndex! < _iIndex - 1) {
            queue.addLast(_leftIndex!);
            queue.addLast(_iIndex - 1);
          }
          if (queue.isEmpty) {
            isCompleted = true;
            return;
          }
          _state = QuickSortState.none;
        }
      } else if (isFindLeftMaxState) {
        if (iThValue < pivotValue)
          _iIndex += 1;
        else {
          _state = QuickSortState.findRightMin;
        }
      } else if (isFindRightMinState) {
        if (jThValue > pivotValue)
          _jIndex = _jIndex! - 1;
        else
          _state = QuickSortState.compare;
      } else if (isCompareState) {
        if (_iIndex <= _jIndex!) {
          _oldArray = List<int>.from(array);
          _updateArray(_swap(_array, _iIndex, _jIndex), notify: false);
          _state = QuickSortState.swap;
        } else {
          _state = QuickSortState.partition;
        }
      } else if (isSwapState) {
        _iIndex += 1;
        _jIndex = _jIndex! - 1;
        _state = QuickSortState.partition;
      }
//      notifyListeners();
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      if (!isSwapping) {
        QuickSortHistoryItem item = _history.last;
        if (item.state == QuickSortState.swap) {
          _history.remove(item);
          item = _history.last;
        }
        queue = item.queue;
        _oldArray = item.oldArray;
        _array = item.array;
        _state = item.state;
        _leftIndex = item.left;
        _rightIndex = item.right;
        _iIndex = item.i;
        _jIndex = item.j;
        _pivotIndex = item.p;
        pivotValue = item.pivot;
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

enum QuickSortState {
  none,
  findPivot,
  partition,
  findLeftMax,
  findRightMin,
  compare,
  swap,
}
