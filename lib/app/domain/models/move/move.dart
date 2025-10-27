import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';
import 'package:pokemon_app/generated/translations.g.dart';

part 'move.freezed.dart';
part 'move.g.dart';

@freezed
abstract class Move with _$Move {
  factory Move({
    @JsonKey(readValue: readName) required String name,
    @Default(0) int accuracy,
    @Default(0) int power,
    @JsonKey(readValue: readDescription) required String description,
  }) = _Move;

  factory Move.fromJson(Map<String, dynamic> json) => _$MoveFromJson(json);
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
