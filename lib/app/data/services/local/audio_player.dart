import 'package:flutter_soloud/flutter_soloud.dart';

class AudioPlayer {
  final SoLoud _soLoud = SoLoud.instance;
  bool _isInitialized = false;

  Future<void> init() async {
    try {
      await _soLoud.init();
      _isInitialized = true;
    } catch (e) {
      print("Error al inicializar SoLoud: $e");
    }
  }

  Future<void> playSoundFromUrl(String url) async {
    try {
      final AudioSource source = await _soLoud.loadUrl(url);

      await _soLoud.play(source);
    } on SoLoudNetworkStatusCodeException {
      print("Ocurrió un error al hacer la petición de descarga");
    } on SoLoudNotInitializedException {
      print("SoLoud no se ha inicializado");
    } catch (e) {
      print("Ocurrió un error al reproducir el sonido: $e");
    }
  }

  void dispose() {
    if (_isInitialized) {
      _soLoud.deinit();
      _isInitialized = false;
    }
  }
}
