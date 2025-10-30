import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

part "pokemon_state.freezed.dart";

@freezed
abstract class PokemonState with _$PokemonState {
  factory PokemonState.loading() = PokemonStateLoading;
  factory PokemonState.failed(HttpRequestFailure failure) = PokemonStateFailed;
  factory PokemonState.loaded(Pokemon pokemon) = PokemonStateLoaded;
}
