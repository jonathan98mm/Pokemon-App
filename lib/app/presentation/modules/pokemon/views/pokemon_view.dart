import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/global/widgets/pokemon_loader.dart';
import 'package:pokemon_app/app/presentation/global/widgets/request_failed.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/pokemon_controller.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/state/pokemon_state.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/pokemon_content.dart';
import 'package:provider/provider.dart';

class PokemonView extends StatelessWidget {
  const PokemonView({super.key, required this.pokemonId});

  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PokemonController>(
      create: (_) =>
          PokemonController(PokemonState.loading(), context.read(), pokemonId)
            ..init(),
      builder: (context, _) {
        final PokemonController controller = context.watch();

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(title: Text(pokemonId.toString())),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.state.when(
                        loading: () => Container(
                          height: constraints.maxHeight,
                          alignment: Alignment.center,
                          child: PokemonLoader(),
                        ),
                        failed: () =>
                            RequestFailed(onRetry: () => controller.init()),
                        loaded: (pokemon) => PokemonContent(pokemon: pokemon),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
