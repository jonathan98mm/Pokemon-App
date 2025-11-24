import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/global/widgets/flip_card.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/ability_content.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/movements_list.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/stat_bar.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/widgets/type_chip.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class PokemonContent extends StatelessWidget {
  const PokemonContent({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
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
                      ExtendedImage.network(pokemon.artworkPath, height: 275),
                      Wrap(
                        spacing: 10,
                        children: List.generate(
                          pokemon.types.length,
                          (index) => TypeChip(type: pokemon.types[index]),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: texts.pokemon.height,
                                children: [
                                  TextSpan(
                                    text: "${pokemon.height / 10} m",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 17.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: texts.pokemon.weight,
                                children: [
                                  TextSpan(
                                    text: "${pokemon.weight / 10} Kg",
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                                style: TextStyle(
                                  fontSize: 17.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
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
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 10)),
        SliverToBoxAdapter(
          child: Text(
            texts.pokemon.abilities,
            style: TextStyle(fontSize: 25, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 10)),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                pokemon.abilities.length,
                (index) => AbilityContent(ability: pokemon.abilities[index]),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 10)),
        SliverToBoxAdapter(
          child: Text(
            texts.pokemon.movements,
            style: TextStyle(fontSize: 25, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 10)),
        MovementsList(movements: pokemon.movements),
        SliverToBoxAdapter(child: const SizedBox(height: 20)),
      ],
    );
  }
}
