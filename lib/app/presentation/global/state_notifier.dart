import 'package:flutter/material.dart';

abstract class StateNotifier<S> extends ChangeNotifier {
  StateNotifier(this._state) : _oldState = _state;

  S _state, _oldState;
  bool _mounted = true;

  S get state => _state;
  bool get mounted => _mounted;
  S get oldState => _oldState;

  set state(S newState) {
    _update(newState);
  }

  void onlyUpdate(S newState) {
    _update(newState, notify: false);
  }

  void _update(S newState, {bool notify = true}) {
    if (newState != _oldState) {
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
