import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

part "home_state.freezed.dart";

@freezed
abstract class HomeState with _$HomeState {
  factory HomeState({
    @Default(PokemonsState.loading()) PokemonsState pokemons,
  }) = _HomeState;
}

@freezed
abstract class PokemonsState with _$PokemonsState {
  const factory PokemonsState.loading() = PokemonsStateLoading;
  const factory PokemonsState.failed() = PokemonsStateFailed;
  const factory PokemonsState.loaded(List<Pokemon> list) = PokemonsStateLoaded;
}
