import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile({
    super.key,
    required this.pokemon,
    required this.width,
    required this.showData,
  });

  final Pokemon pokemon;
  final double width;
  final bool showData;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        Routes.pokemon,
        pathParameters: {"id": pokemon.id.toString()},
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: Container(
          color: const Color.fromARGB(255, 196, 196, 196),
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: ExtendedImage.network(
                  pokemon.artworkPath,
                  fit: BoxFit.contain,
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
                  opacity: 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87),
                          borderRadius: BorderRadius.circular(7.5),
                          color: Colors.blueGrey,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 1,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "${pokemon.experience.toString()} XP",
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(width: 2.5),
                            Icon(Icons.keyboard_double_arrow_up, size: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 2.5,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(7.5),
                      color: Colors.black54,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                    child: Text(
                      "# ${pokemon.id.toString()}",
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Positioned(
                width: width,
                bottom: 5,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      pokemon.name.capitalize(),
                      style: TextStyle(color: Colors.black, fontSize: 13),
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
