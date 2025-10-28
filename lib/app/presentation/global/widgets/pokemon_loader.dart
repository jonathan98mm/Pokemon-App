import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class PokemonLoader extends StatefulWidget {
  const PokemonLoader({
    super.key,
    this.size = 50,
    this.duration = const Duration(seconds: 1),
  });

  final double size;
  final Duration duration;

  @override
  State<PokemonLoader> createState() => _PokemonLoaderState();
}

class _PokemonLoaderState extends State<PokemonLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        RotationTransition(
          turns: _controller,
          child: ExtendedImage.asset(
            "assets/images/pokeball.png",
            width: widget.size,
            height: widget.size,
          ),
        ),
        SizedBox(height: 5),
        Text(texts.loader, style: TextStyle(fontSize: widget.size / 4)),
      ],
    );
  }
}
