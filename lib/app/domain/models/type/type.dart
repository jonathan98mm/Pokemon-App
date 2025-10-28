import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';
import 'package:pokemon_app/generated/translations.g.dart';

part 'type.freezed.dart';
part 'type.g.dart';

@freezed
abstract class PokemonType with _$PokemonType {
  factory PokemonType({
    required int id,
    @JsonKey(readValue: readName) required String name,
  }) = _PokemonType;

  factory PokemonType.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeFromJson(json);
}

Object? readName(Map map, String _) {
  final List<Json> nameEntries = List<Json>.from(map["names"]);

  Json localText = nameEntries.firstWhere(
    (json) =>
        json["language"]["name"] == LocaleSettings.currentLocale.languageCode,
    orElse: () =>
        nameEntries.firstWhere((json) => json["language"]["name"] == "en"),
  );

  return localText["name"];
}
