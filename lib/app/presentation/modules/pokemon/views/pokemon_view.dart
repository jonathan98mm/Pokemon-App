import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/global/widgets/pokemon_loader.dart';
import 'package:pokemon_app/app/presentation/global/widgets/request_failed.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/pokemon_controller.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/state/pokemon_state.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/pokemon_content.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonView extends StatelessWidget {
  const PokemonView({super.key, this.pokemonId, this.pokemonName})
    : assert(
        (pokemonId != null && pokemonName == null) ||
            (pokemonId == null && pokemonName != null),
        "Debes proveer un pokemonId O un pokemonName, pero no ambos.",
      );

  final int? pokemonId;
  final String? pokemonName;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PokemonController>(
      create: (_) => PokemonController(
        PokemonState.loading(),
        context.read(),
        context.read(),
        pokemonId: pokemonId,
        pokemonName: pokemonName,
      )..init(),
      builder: (context, _) {
        final PokemonController controller = context.watch();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Skeletonizer(
              enabled: controller.state.when(
                loading: () => true,
                failed: (_) => false,
                loaded: (_) => false,
              ),
              child: Text(
                controller.state.when(
                  loading: () => "Cargando...",
                  failed: (_) => "Ocurrió un error",
                  loaded: (pokemon) =>
                      "#${pokemon.id} - ${pokemon.name.capitalize()}",
                ),
                style: TextStyle(fontSize: 20),
              ),
            ),
            actions: [
              Skeletonizer(
                enabled: controller.state.when(
                  loading: () => true,
                  failed: (_) => false,
                  loaded: (_) => false,
                ),
                child: IconButton(
                  onPressed: () => controller.playPokemonCry(),
                  icon: Icon(Icons.hearing),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: controller.state.when(
              loading: () => Center(child: PokemonLoader(size: 80)),
              failed: (failure) => Center(
                child: RequestFailed(
                  text: failure is HttpNotFound
                      ? "¡El Pokémon no existe!"
                      : null,
                  onRetry: () {
                    if (failure is HttpNotFound) {
                      context.goNamed(Routes.home);
                    } else {
                      controller.init();
                    }
                  },
                ),
              ),
              loaded: (pokemon) => PokemonContent(pokemon: pokemon),
            ),
          ),
        );
      },
    );
  }
}
