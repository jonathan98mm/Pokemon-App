import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class InternetChecker {
  Future<bool> hasInternet() async {
    try {
      if (kIsWeb) {
        final Response response = await get(Uri.parse("8.8.8.8"));

        return response.statusCode == 200;
      } else {
        final List<InternetAddress> list = await InternetAddress.lookup(
          "google.com",
        );

        return list.isNotEmpty && list.first.rawAddress.isNotEmpty;
      }
    } on SocketException {
      return false;
    }
  }
}
