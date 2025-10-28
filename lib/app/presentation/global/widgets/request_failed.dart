import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({super.key, required this.onRetry, this.text});

  final VoidCallback onRetry;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: ExtendedImage.asset("images/404.png")),
          Text(text ?? "Ocurrió un error"),
          MaterialButton(
            onPressed: onRetry,
            color: Colors.blue,
            child: Text("Try again?"),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
