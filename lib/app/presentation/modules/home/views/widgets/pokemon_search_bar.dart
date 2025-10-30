import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';

class PokemonSearchBar extends StatelessWidget {
  const PokemonSearchBar({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return AnimSearchBar(
      width: 185,
      textController: controller,
      color: const Color.fromARGB(255, 196, 196, 196),
      helpText: "Buscar...",
      autoFocus: true,
      textFieldColor: const Color.fromARGB(255, 196, 196, 196),
      style: TextStyle(fontSize: 15, color: Colors.black),
      onSuffixTap: () => controller.clear(),
      onSubmitted: (value) {
        context.pushNamed(
          Routes.pokemon,
          pathParameters: {"param": int.tryParse(value)?.toString() ?? value},
        );
      },
    );
  }
}
