import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/home_controller.dart';
import 'package:pokemon_app/app/presentation/modules/home/controller/state/home_state.dart';
import 'package:pokemon_app/app/presentation/modules/home/views/widgets/pokemon_list.dart';
import 'package:pokemon_app/generated/translations.g.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) =>
          HomeController(HomeState(), pokemonRepository: context.read())
            ..init(),
      child: Scaffold(
        appBar: AppBar(title: Text("Pokémon App")),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => RefreshIndicator(
              onRefresh: context.read<HomeController>().init,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        texts.home.randomPokemon,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      PokemonList(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
