import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokemon_app/app/data/services/local/internet_checker.dart';
import 'package:pokemon_app/app/domain/repositories/connectivity_repository.dart';

class ConnectivityRepositoryImpl implements ConnectivityRepository {
  ConnectivityRepositoryImpl(this._connectivity, this._internetChecker) {
    initialize();
  }

  final Connectivity _connectivity;
  final InternetChecker _internetChecker;
  final StreamController<bool> _controller = StreamController.broadcast();
  late bool _hasInternet;
  StreamSubscription? _subscription;

  @override
  bool get hasInternet => _hasInternet;

  @override
  Stream<bool> get onInternetChange => _controller.stream;

  @override
  Future<void> initialize() async {
    Future<bool> hasInternet(List<ConnectivityResult> result) async {
      if (result.first == ConnectivityResult.none) {
        return false;
      } else {
        return _internetChecker.hasInternet();
      }
    }

    _hasInternet = await hasInternet(await _connectivity.checkConnectivity());

    _connectivity.onConnectivityChanged.skip(Platform.isIOS ? 1 : 0).listen((
      event,
    ) async {
      _subscription?.cancel();

      _subscription = hasInternet(event).asStream().listen((value) {
        _hasInternet = value;
        if (_controller.hasListener && !_controller.isClosed) {
          _controller.add(_hasInternet);
        }
      });
    });
  }
}
