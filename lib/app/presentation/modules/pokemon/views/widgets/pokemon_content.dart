import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/controller/state/pokemon_state.dart';

class PokemonContent extends StatelessWidget {
  const PokemonContent({super.key, required this.state});

  final PokemonStateLoaded state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //MovieHeader(movie: state.movie),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(state.pokemon.name),
          ),
          //MovieCast(movieId: state.movie.id),
        ],
      ),
    );
  }
}
