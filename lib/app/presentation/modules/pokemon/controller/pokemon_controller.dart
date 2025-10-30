import 'package:pokemon_app/app/data/services/local/audio_player.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_app/app/presentation/global/state_notifier.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/state/pokemon_state.dart';

class PokemonController extends StateNotifier<PokemonState> {
  PokemonController(
    super.state,
    this.pokemonRepository,
    this.player, {
    this.pokemonId,
    this.pokemonName,
  });

  final PokemonRepository pokemonRepository;
  final int? pokemonId;
  final String? pokemonName;
  final AudioPlayer player;

  Future<void> init() async {
    state = PokemonState.loading();
    Either<HttpRequestFailure, Pokemon> result;

    if (pokemonId != null) {
      result = await pokemonRepository.getPokemonById(pokemonId!);
    } else {
      result = await pokemonRepository.getPokemonByName(pokemonName!);
    }

    state = result.when(
      left: (failure) => PokemonState.failed(failure),
      right: (pokemon) => PokemonState.loaded(pokemon),
    );
  }

  Future<void> playPokemonCry() async {
    if (state is PokemonStateLoaded) {
      await player.playSoundFromUrl(
        (state as PokemonStateLoaded).pokemon.soundPath,
      );
    } else {
      print("Aún no se ha cargado el pokemon");
    }
  }
}
