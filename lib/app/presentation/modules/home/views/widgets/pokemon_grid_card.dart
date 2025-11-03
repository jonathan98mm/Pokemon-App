import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';

class PokemonGridCard extends StatelessWidget {
  const PokemonGridCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.pokemon,
        pathParameters: {"param": pokemon.id.toString()},
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(5),
        child: Container(
          color: AppColors.secondary,
          width: 200,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                child: ExtendedImage.network(
                  pokemon.artworkPath,
                  width: 100,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return Container(color: Colors.black12);
                    }
                    return state.completedWidget;
                  },
                ),
              ),
              Positioned(
                top: 2.5,
                right: 2.5,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(4),
                      color: AppColors.primary,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                    child: Row(
                      children: [
                        Text(
                          "${pokemon.experience.toString()} XP",
                          style: TextStyle(fontSize: 8, color: Colors.white),
                        ),
                        SizedBox(width: 2.5),
                        Icon(
                          Icons.keyboard_double_arrow_up,
                          size: 10,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 25,
                left: 2.5,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.black54,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    child: Text(
                      "# ${pokemon.id.toString()}",
                      style: TextStyle(fontSize: 8, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2.5,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      pokemon.name.capitalize(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
