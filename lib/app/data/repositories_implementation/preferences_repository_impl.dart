import 'package:pokemon_app/app/domain/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepositroyImpl implements PreferencesRepository {
  PreferencesRepositroyImpl(this._preferences, this._systemDarkMode);

  final SharedPreferences _preferences;
  final bool _systemDarkMode;

  @override
  bool get darkMode {
    return _preferences.getBool("darkMode") ?? _systemDarkMode;
  }

  @override
  Future<void> setDarkMode(bool darkMode) async {
    await _preferences.setBool("darkMode", darkMode);
  }
}
