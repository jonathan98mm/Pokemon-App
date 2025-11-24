import 'package:flutter/material.dart';
import 'package:pokemon_app/app/domain/models/move/move.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class MovementsList extends StatelessWidget {
  const MovementsList({super.key, required this.movements});

  final List<Move> movements;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (_, index) => Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            border: Border(
              top: index != 0
                  ? BorderSide.none
                  : BorderSide(color: Colors.white),
              bottom: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.white),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  movements[index].name,
                  style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                movements[index].description,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text.rich(
                    TextSpan(
                      text: texts.pokemon.accuracy,
                      children: [
                        TextSpan(
                          text: movements[index].accuracy.toString(),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text.rich(
                    TextSpan(
                      text: texts.pokemon.power,
                      children: [
                        TextSpan(
                          text: movements[index].power.toString(),
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      itemCount: movements.length,
    );
  }
}
