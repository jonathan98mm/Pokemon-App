import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_app/app/presentation/global/state_notifier.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/state/home_state.dart';

class HomeController extends StateNotifier<HomeState> {
  HomeController(super.state, {required this.pokemonRepository});

  final PokemonRepository pokemonRepository;

  Future<void> init() async {
    await loadRandomPokemons(pokemons: PokemonsState.loading());
  }

  Future<void> loadRandomPokemons({PokemonsState? pokemons}) async {
    if (pokemons != null) {
      state = state.copyWith(pokemons: pokemons);
    }

    final result = await pokemonRepository.getRandomPokemons(count: 5);

    state = result.when(
      left: (_) => state.copyWith(pokemons: PokemonsState.failed()),
      right: (list) => state.copyWith(pokemons: PokemonsState.loaded(list)),
    );
  }
}
