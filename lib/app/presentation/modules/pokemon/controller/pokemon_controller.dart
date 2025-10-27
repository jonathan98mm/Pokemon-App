import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_app/app/presentation/global/state_notifier.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/state/pokemon_state.dart';

class PokemonController extends StateNotifier<PokemonState> {
  PokemonController(super.state, this.pokemonRepository, this.id);

  final PokemonRepository pokemonRepository;
  final int id;

  Future<void> init() async {
    state = PokemonState.loading();

    final result = await pokemonRepository.getPokemonById(id);

    state = result.when(
      left: (_) => PokemonState.failed(),
      right: (pokemon) => PokemonState.loaded(pokemon),
    );

    print(state);
  }
}
