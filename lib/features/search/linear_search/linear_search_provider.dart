import 'dart:math' show Random;

import 'package:flutter/material.dart';

class LinearSearchProvider extends ChangeNotifier {
  Set<int> _history = {};
  bool isFirst = true;

  bool get isCompleted => currentValue == searchValue && !isFirst;

  List<int> _array = [];

  List<int> get array => _array;

  bool _isUnique = false;

  bool get isUnique => _isUnique;

  int initialMinArrayValue = 20;
  int initialMaxArrayValue = 99;
  int _maxArrayValue = 100;

  int get maxArrayValue => _maxArrayValue;

  double minArraySize = 1;
  int maxArraySize = 13;
  double _arraySize = 10;

  double get arraySize => _arraySize;

  int _searchIndex;

  int get searchIndex => _searchIndex;

  int get searchValue => _array[_searchIndex];

  int _iIndex = 0;

  int get iIndex => _iIndex;

  int get currentValue => _array[_iIndex];

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

  void setIsUnique(bool isUnique, {notify = true}) {
    if (_isUnique != isUnique) {
      _isUnique = isUnique;
      if (isCompleted) generateArray(notify: notify);
      if (notify) notifyListeners();
    }
  }

  void _incrementIIndex({notify = true}) {
    if (_iIndex < _arraySize - 1) {
      _updateIIndex(_iIndex + 1, notify: notify);
    } else {
      if (notify) notifyListeners();
    }
  }

  void _updateIIndex(int index, {notify = true}) {
    if (_iIndex != index) {
      _iIndex = index;
      if (notify) notifyListeners();
    }
  }

  void _updateArray(List<int> generatedList, {notify = true}) {
    _array = generatedList;
    if (notify) notifyListeners();
  }

  void _updateSearchIndex(int index, {notify = true}) {
    if (_searchIndex != index) {
      _searchIndex = index;
      if (notify) notifyListeners();
    }
  }

  void generateArray({notify = true}) {
    Random random = Random();
    int max = _maxArrayValue;
    double size = _arraySize;
    List<int> list = [];
    if (_isUnique) {
      while (list.length < _arraySize) {
        int number = random.nextInt(max) + 1;
        if (!list.contains(number)) list.add(number);
      }
    } else {
      list = List<int>.generate(
        size.toInt(),
        (index) => random.nextInt(max) + 1,
      );
    }
    _updateArray(list, notify: notify);
    _reset(notify: notify);
  }

  void _reset({notify = true}) {
    _history = {};
    isFirst = true;
    _updateIIndex(0, notify: notify);
    _updateSearchIndex(_getRandomSearchIndex(), notify: notify);
  }

  int _getRandomSearchIndex() {
    Random random = Random();
    int index = random.nextInt(_array.length);
    if (index >= _array.length) index %= _array.length;
    return index;
  }

  void stepForward() {
    if (!isCompleted) {
      isFirst = false;
      _history.add(_iIndex);
      if (currentValue == searchValue) {
//        notifyListeners();
      } else {
        _incrementIIndex(notify: false);
      }
    }
  }

  void stepBack() {
    if (_history.isNotEmpty) {
      _updateIIndex(_history.last, notify: false);
      _history.remove(_history.last);
    } else isFirst = true;
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
