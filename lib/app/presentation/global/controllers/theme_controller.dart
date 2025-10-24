import 'package:flutter/foundation.dart';
import 'package:pokemon_app/app/domain/repositories/preferences_repository.dart';

class ThemeController extends ChangeNotifier {
  ThemeController(this._darkMode, this._preferencesRepository);

  final PreferencesRepository _preferencesRepository;
  bool _darkMode;

  bool get darkMode => _darkMode;

  void onChanged(bool darkMode) {
    _darkMode = darkMode;
    _preferencesRepository.setDarkMode(_darkMode);
    notifyListeners();
  }
}
