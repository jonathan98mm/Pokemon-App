import 'package:flutter/material.dart';

abstract class StateNotifier<State> extends ChangeNotifier {
  StateNotifier(this._state) : _oldState = _state;

  State _state, _oldState;
  bool _mounted = true;

  State get state => _state;
  bool get mounted => _mounted;
  State get oldState => _oldState;

  set state(State newState) {
    _update(newState);
  }

  void onlyUpdate(State newState) {
    _update(newState, notify: false);
  }

  void _update(State newState, {bool notify = true}) {
    if (_state != _oldState) {
      _oldState = _state;
      _state = newState;

      if (notify) notifyListeners();
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
