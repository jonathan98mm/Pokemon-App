import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/app/presentation/global/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController controller = context.read();
    final bool darkMode = controller.darkMode;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: darkMode ? AppColors.dark : Colors.white,
        child: Center(
          child: SizedBox(
            width: 80,
            height: 80,
            child: Column(
              children: [
                const SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 10),
                Text(
                  "LOADING...",
                  style: TextStyle(
                    color: darkMode ? Colors.white : AppColors.dark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
