import 'package:hive/hive.dart';

class ApiCache {
  final Box<String> _box = Hive.box("apiCache");

  Future<void> savePokemon(int id, String json) {
    return _box.put("pokemon_$id", json);
  }

  Future<void> saveAbility(int id, String json) {
    return _box.put("ability_$id", json);
  }

  Future<void> saveMove(int id, String json) {
    return _box.put("move_$id", json);
  }

  Future<void> saveStat(int id, String json) {
    return _box.put("stat_$id", json);
  }

  Future<void> saveType(int id, String json) {
    return _box.put("type_$id", json);
  }

  String? getPokemon(int id) {
    return _box.get("pokemon_$id");
  }

  String? getAbility(int id) {
    return _box.get("ability_$id");
  }

  String? getMove(int id) {
    return _box.get("move_$id");
  }

  String? getStat(int id) {
    return _box.get("stat_$id");
  }

  String? getType(int id) {
    return _box.get("type_$id");
  }
}
