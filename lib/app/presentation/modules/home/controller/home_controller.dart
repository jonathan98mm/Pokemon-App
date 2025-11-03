import 'package:flutter/widgets.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_app/app/presentation/global/state_notifier.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/state/home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(super.state, {required this.pokemonRepository});

  final PokemonRepository pokemonRepository;
  final TextEditingController textController = TextEditingController();
  static const int _limit = 20;
  bool _isLoadingPage = false;

  Future<void> init() async {
    await Future.wait([loadRandomPokemons(), loadInitialPokemons()]);
  }

  Future<void> loadRandomPokemons() async {
    state = state.copyWith(randomPokemons: const PokemonUiState.loading());

    final result = await pokemonRepository.getRandomPokemons(count: 5);

    state = result.when(
      left: (_) => state.copyWith(randomPokemons: PokemonUiState.failed()),
      right: (list) =>
          state.copyWith(randomPokemons: PokemonUiState.loaded(list)),
    );
  }

  Future<void> loadInitialPokemons() async {
    state = state.copyWith(
      paginatedPokemons: PokemonUiState.loading(),
      offset: 0,
    );

    final result = await pokemonRepository.getPaginatedPokemons(0, _limit);

    state = result.when(
      left: (_) => state.copyWith(paginatedPokemons: PokemonUiState.failed()),
      right: (response) => state.copyWith(
        paginatedPokemons: PokemonUiState.loaded(response.pokemons),
        hasNextPage: response.hasNextPage,
        offset: _limit,
      ),
    );
  }

  Future<void> loadNextPage() async {
    if (_isLoadingPage ||
        state.paginatedPokemons is PokemonUiStateLoading ||
        !state.hasNextPage) {
      return;
    }

    _isLoadingPage = true;

    final result = await pokemonRepository.getPaginatedPokemons(
      state.offset,
      _limit,
    );

    state = result.when(
      left: (_) {
        _isLoadingPage = false;

        return state;
      },
      right: (response) {
        final List<Pokemon> currentList = state.paginatedPokemons.maybeWhen(
          loaded: (pokemons) => pokemons,
          orElse: () => [],
        );

        _isLoadingPage = false;

        return state.copyWith(
          paginatedPokemons: PokemonUiState.loaded([
            ...currentList,
            ...response.pokemons,
          ]),
          hasNextPage: response.hasNextPage,
          offset: state.offset + _limit,
        );
      },
    );
  }
}
