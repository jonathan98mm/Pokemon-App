import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';

part 'stat.freezed.dart';
part 'stat.g.dart';

@freezed
abstract class Stat with _$Stat {
  factory Stat({@JsonKey(readValue: readName) required String name}) = _Stat;

  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);
}

Object? readName(Map map, String _) {
  final List<Json> nameEntries = List<Json>.from(map["names"]);

  Json localText = nameEntries.firstWhere(
    (json) => json["language"]["name"] == "es",
  );

  return localText["name"];
}
