import 'package:flutter/material.dart';
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
          body: controller.state.map(
            loading: (_) => const CircularProgressIndicator(),
            failed: (_) => RequestFailed(onRetry: () => controller.init()),
            loaded: (state) => PokemonContent(state: state),
          ),
        );
      },
    );
  }
}
