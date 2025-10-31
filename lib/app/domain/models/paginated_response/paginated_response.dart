import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

part "paginated_response.freezed.dart";

@freezed
abstract class PaginatedResponse with _$PaginatedResponse {
  factory PaginatedResponse({
    required List<Pokemon> pokemons,
    required bool hasNextPage,
  }) = _PaginatedResponse;
}
