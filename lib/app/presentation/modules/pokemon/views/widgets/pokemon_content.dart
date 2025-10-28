import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/global/widgets/flip_card.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class PokemonContent extends StatelessWidget {
  const PokemonContent({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FlipCard(
              duration: Duration(milliseconds: 250),
              front: Card(
                color: AppColors.secondary,
                child: Container(
                  width: double.maxFinite,
                  height: 400,
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        pokemon.name.capitalize(),
                        style: TextStyle(fontSize: 35, color: Colors.white),
                      ),
                      ExtendedImage.network(pokemon.artworkPath),
                    ],
                  ),
                ),
              ),
              back: Card(
                color: AppColors.primary,
                child: Container(
                  width: double.maxFinite,
                  height: 400,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        pokemon.name.capitalize(),
                        style: TextStyle(fontSize: 35, color: Colors.black),
                      ),
                      SizedBox(height: 5),
                      ExtendedImage.network(pokemon.spritePath),
                      SizedBox(height: 10),
                      Text(texts.pokemon.stats, style: TextStyle(fontSize: 20)),
                      Text(pokemon.stats.first.name),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
