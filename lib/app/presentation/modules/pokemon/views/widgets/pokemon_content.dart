import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/global/widgets/flip_card.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/ability_content.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/stat_bar.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/type_chip.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class PokemonContent extends StatelessWidget {
  const PokemonContent({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: FlipCard(
            duration: Duration(milliseconds: 250),
            front: Card(
              color: AppColors.secondary,
              child: Container(
                width: double.maxFinite,
                height: 450,
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      pokemon.name.capitalize(),
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    ExtendedImage.network(pokemon.artworkPath, height: 300),
                    Wrap(
                      spacing: 10,
                      children: List.generate(
                        pokemon.types.length,
                        (index) => TypeChip(type: pokemon.types[index]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            back: Card(
              color: AppColors.primary,
              child: Container(
                width: double.maxFinite,
                height: 450,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      pokemon.name.capitalize(),
                      style: TextStyle(fontSize: 30, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    ExtendedImage.network(pokemon.spritePath),
                    SizedBox(height: 10),
                    Text(texts.pokemon.stats, style: TextStyle(fontSize: 20)),
                    SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (_, constraints) => Container(
                        width: constraints.maxWidth * 0.9,
                        height: 220,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: List.generate(
                            pokemon.stats.length,
                            (index) => StatBar(stat: pokemon.stats[index]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text("Habilidades", style: TextStyle(fontSize: 25)),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
          child: Column(
            children: [
              for (Ability ability in pokemon.abilities)
                AbilityContent(ability: ability),
            ],
          ),
        ),
      ],
    );
  }
}
