import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get darkMode => Theme.of(this).brightness == Brightness.dark;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
