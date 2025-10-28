import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';
import 'package:pokemon_app/generated/translations.g.dart';

part 'stat.freezed.dart';
part 'stat.g.dart';

@freezed
abstract class Stat with _$Stat {
  factory Stat({
    required int id,
    @JsonKey(readValue: readName) required String name,
  }) = _Stat;

  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);
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
