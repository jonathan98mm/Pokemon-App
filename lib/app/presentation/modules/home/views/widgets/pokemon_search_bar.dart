import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class PokemonSearchBar extends StatefulWidget {
  const PokemonSearchBar({super.key});

  @override
  State<PokemonSearchBar> createState() => _PokemonSearchBarState();
}

class _PokemonSearchBarState extends State<PokemonSearchBar> {
  IconData icon = Icons.search;
  double textWidth = kToolbarHeight * 0.75;
  bool isOpen = false;
  late final FocusNode _focus;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focus = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: kToolbarHeight * 0.75,
              width: textWidth,
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focus,
                textAlign: TextAlign.left,
                onSubmitted: (value) => context.pushNamed(
                  Routes.pokemon,
                  pathParameters: {
                    "param": int.tryParse(value)?.toString() ?? value,
                  },
                ),
                style: TextStyle(fontSize: 15, color: AppColors.dark),
                cursorColor: AppColors.secondary,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15, bottom: 7.5),
                  hintText: texts.home.search,
                  border: UnderlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                setState(() => _onTap());
              },
              child: Container(
                width: kToolbarHeight * 0.75,
                height: kToolbarHeight * 0.75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.light,
                ),
                child: Icon(icon, color: AppColors.dark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    if (isOpen) {
      icon = Icons.search;
      textWidth = kToolbarHeight * 0.75;
      _controller.clear();
      _focus.unfocus();
    } else {
      textWidth = 200;
      icon = Icons.close;
      _focus.requestFocus();
    }

    isOpen = !isOpen;
  }
}
