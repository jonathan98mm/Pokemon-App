import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';
import 'package:pokemon_app/app/domain/models/move/move.dart';
import 'package:pokemon_app/app/domain/models/stat/stat.dart';
import 'package:pokemon_app/app/domain/models/type/type.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';

part "pokemon.freezed.dart";
part "pokemon.g.dart";

@Freezed(makeCollectionsUnmodifiable: false)
abstract class Pokemon with _$Pokemon {
  Pokemon._();

  factory Pokemon({
    required int id,
    required String name,
    @JsonKey(name: "base_experience") required int experience,
    @Default([]) List<Ability> abilities,
    @JsonKey(readValue: readSoundPath) required String soundPath,
    required int height,
    @Default([]) List<Move> movements,
    @JsonKey(readValue: readSpritePath) required String spritePath,
    @JsonKey(readValue: readArtworkPath) required String artworkPath,
    @Default([]) List<Stat> stats,
    @Default([]) List<PokemonType> types,
    required int weight,
  }) = _Pokemon;

  factory Pokemon.fromJson(Json json) => _$PokemonFromJson(json);
}

Object? readSoundPath(Map map, String _) {
  return map["cries"]["latest"];
}

Object? readSpritePath(Map map, String _) {
  return map["sprites"]["front_default"];
}

Object? readArtworkPath(Map map, String _) {
  return map["sprites"]["other"]["official-artwork"]["front_default"];
}
