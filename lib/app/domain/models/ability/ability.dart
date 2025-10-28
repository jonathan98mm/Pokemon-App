import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';
import 'package:pokemon_app/generated/translations.g.dart';

part 'ability.freezed.dart';
part 'ability.g.dart';

@freezed
abstract class Ability with _$Ability {
  factory Ability({
    required id,
    @JsonKey(readValue: readName) required String name,
    @JsonKey(readValue: readDescription) required String description,
  }) = _Ability;

  factory Ability.fromJson(Map<String, dynamic> json) =>
      _$AbilityFromJson(json);
}

Object? readDescription(Map map, String _) {
  final List<Json> textEntries = List<Json>.from(map["flavor_text_entries"]);

  Json localText = textEntries.firstWhere(
    (json) =>
        json["language"]["name"] == LocaleSettings.currentLocale.languageCode,
    orElse: () =>
        textEntries.firstWhere((json) => json["language"]["name"] == "en"),
  );

  return (localText["flavor_text"] as String).replaceAll("\n", " ");
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
