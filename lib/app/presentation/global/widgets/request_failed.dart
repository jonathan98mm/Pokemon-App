import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_app/app/presentation/global/colors.dart';
import 'package:pokemon_app/generated/translations.g.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({super.key, required this.onRetry, this.text});

  final VoidCallback onRetry;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: ExtendedImage.asset("assets/images/404.png", height: 200),
          ),
          const SizedBox(height: 15),
          Text(text ?? texts.errors.error, style: TextStyle(fontSize: 25)),
          const SizedBox(height: 15),
          MaterialButton(
            onPressed: onRetry,
            shape: Border.all(color: Colors.black, width: 3),
            color: AppColors.secondary,
            child: Text(
              texts.errors.buttonMessage,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
