import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

part "pokemon_state.freezed.dart";

@freezed
abstract class PokemonState with _$PokemonState {
  factory PokemonState.loading() = PokemonStateLoading;
  factory PokemonState.failed() = PokemonStateFailed;
  factory PokemonState.loaded(Pokemon pokemon) = PokemonStateLoaded;
}
