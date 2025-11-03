import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/global/widgets/pokemon_loader.dart';
import 'package:pokemon_app/app/presentation/global/widgets/request_failed.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/home_controller.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/state/home_state.dart';
import 'package:pokemon_app/app/presentation/modules/home/views/widgets/pokemon_grid_card.dart';
import 'package:provider/provider.dart';

class PaginatedPokemon extends StatefulWidget {
  const PaginatedPokemon({super.key});

  @override
  State<PaginatedPokemon> createState() => _PaginatedPokemonState();
}

class _PaginatedPokemonState extends State<PaginatedPokemon> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final HomeController controller = context.read();

    if (_scrollController.position.maxScrollExtent -
            _scrollController.position.pixels >
        300) {
      return;
    }

    controller.loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = context.watch();
    final PokemonUiState paginatedState = controller.state.paginatedPokemons;
    final bool hasNextPage = controller.state.hasNextPage;

    return paginatedState.when(
      loading: () => const Center(child: PokemonLoader(size: 80)),
      failed: () => Center(
        child: RequestFailed(onRetry: () => controller.loadInitialPokemons()),
      ),
      loaded: (pokemons) => GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
        ),
        itemCount: pokemons.length + (hasNextPage ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pokemons.length) {
            return const Center(child: PokemonLoader());
          }

          return PokemonGridCard(pokemon: pokemons[index]);
        },
      ),
    );
  }
}
