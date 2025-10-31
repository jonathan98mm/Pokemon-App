import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

part "home_state.freezed.dart";

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    @Default(PokemonUiState.loading()) PokemonUiState randomPokemons,
    @Default(PokemonUiState.loading()) PokemonUiState paginatedPokemons,
    @Default(true) bool hasNextPage,
    @Default(0) int offset,
  }) = _HomeState;
}

@freezed
abstract class PokemonUiState with _$PokemonUiState {
  const factory PokemonUiState.loading() = PokemonUiStateLoading;
  const factory PokemonUiState.failed() = PokemonUiStateFailed;
  const factory PokemonUiState.loaded(List<Pokemon> pokemons) =
      PokemonUiStateLoaded;
}
