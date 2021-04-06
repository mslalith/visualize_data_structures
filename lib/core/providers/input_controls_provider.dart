import 'package:flutter/material.dart' show ChangeNotifier, RawKeyEvent;

class InputControlsProvider extends ChangeNotifier {
  static const String KEY_EVENT_UP = 'RawKeyUpEvent';

  RawKeyEvent? _keyEvent;

  RawKeyEvent? get keyEvent => _keyEvent;

  bool get isCurrentKeyUp => keyEvent.runtimeType.toString() == KEY_EVENT_UP;

  void updateKeyEvent(RawKeyEvent? event) {
    _keyEvent = event;
    if (event != null) notifyListeners();
  }
}
