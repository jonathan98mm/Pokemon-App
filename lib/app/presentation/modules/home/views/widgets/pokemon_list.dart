import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/global/widgets/request_failed.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/home_controller.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/state/home_state.dart';
import 'package:pokemon_app/app/presentation/modules/home/views/widgets/pokemon_tile.dart';
import 'package:provider/provider.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final PokemonsState state = controller.state.pokemons;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 16 / 8,
          child: LayoutBuilder(
            builder: (_, constraints) {
              final double width = constraints.maxHeight * 0.65;

              return Center(
                child: state.when(
                  loading: () => CircularProgressIndicator(),
                  failed: () => RequestFailed(
                    onRetry: () {
                      controller.loadRandomPokemons(
                        pokemons: PokemonsState.loading(),
                      );
                    },
                  ),
                  loaded: (list) => ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      final pokemon = list[index];
                      return PokemonTile(
                        pokemon: pokemon,
                        width: width,
                        showData: true,
                      );
                    },
                    itemCount: list.length,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
