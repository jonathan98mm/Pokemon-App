import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/type/type.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';

class TypeChip extends StatelessWidget {
  const TypeChip({super.key, required this.type});

  final PokemonType type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        type.name,
        style: TextStyle(
          color: AppColors.typesText[type.id] ?? Colors.black,
          fontSize: 20,
        ),
      ),
      color: WidgetStatePropertyAll(AppColors.types[type.id] ?? Colors.grey),
      padding: EdgeInsets.all(5),
    );
  }
}
