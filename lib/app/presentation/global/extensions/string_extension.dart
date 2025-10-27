extension StringExtension on String {
  String capitalize() {
    if (contains("-")) {
      List<String> substrings = split("-");

      String firstPart =
          "${substrings[0].substring(0, 1).toUpperCase()}${substrings[0].substring(1)}";
      String secondPart =
          "${substrings[1].substring(0, 1).toUpperCase()}${substrings[1].substring(1)}";

      return "$firstPart-$secondPart";
    }

    return "${substring(0, 1).toUpperCase()}${substring(1)}";
  }
}
