import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pokemon_app/app/app.dart';
import 'package:pokemon_app/app/data/http/http.dart';
import 'package:pokemon_app/app/data/repositories_implementation/connectivity_repository_impl.dart';
import 'package:pokemon_app/app/data/repositories_implementation/language_repository_impl.dart';
import 'package:pokemon_app/app/data/repositories_implementation/pokemon_repository_impl.dart';
import 'package:pokemon_app/app/data/repositories_implementation/preferences_repository_impl.dart';
import 'package:pokemon_app/app/data/services/local/api_cache.dart';
import 'package:pokemon_app/app/data/services/local/audio_player.dart';
import 'package:pokemon_app/app/data/services/local/internet_checker.dart';
import 'package:pokemon_app/app/data/services/local/language_service.dart';
import 'package:pokemon_app/app/data/services/remote/pokemon_api.dart';
import 'package:pokemon_app/app/domain/repositories/connectivity_repository.dart';
import 'package:pokemon_app/app/domain/repositories/language_repository.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';
import 'package:pokemon_app/app/domain/repositories/preferences_repository.dart';
import 'package:pokemon_app/app/presentation/global/controllers/theme_controller.dart';
import 'package:pokemon_app/generated/translations.g.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  Intl.defaultLocale = LocaleSettings.instance.currentLocale.languageTag;
  await Hive.initFlutter();
  await Hive.openBox<String>("apiCache");

  await dotenv.load(fileName: ".env");

  final Http http = Http(
    client: Client(),
    baseUrl: dotenv.get("BASE_URL", fallback: "NO_BASE_URL"),
  );

  final AudioPlayer player = AudioPlayer();

  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final bool darkMode =
      PlatformDispatcher.instance.platformBrightness == Brightness.dark;

  final ConnectivityRepository connectivityRepository =
      ConnectivityRepositoryImpl(Connectivity(), InternetChecker());

  await connectivityRepository.initialize();
  await player.init();

  runApp(
    Root(
      connectivityRepository: connectivityRepository,
      preferences: preferences,
      darkMode: darkMode,
      http: http,
      cache: ApiCache(),
      player: player,
    ),
  );
}

class Root extends StatelessWidget {
  const Root({
    super.key,
    required this.connectivityRepository,
    required this.preferences,
    required this.darkMode,
    required this.http,
    required this.cache,
    required this.player,
  });

  final ConnectivityRepository connectivityRepository;
  final SharedPreferences preferences;
  final bool darkMode;
  final Http http;
  final ApiCache cache;
  final AudioPlayer player;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioPlayer>(create: (_) => player),
        Provider<ConnectivityRepository>(create: (_) => connectivityRepository),
        Provider<LanguageRepository>(
          create: (context) => LanguageRepositoryImpl(
            LanguageService(LocaleSettings.currentLocale.languageCode),
          ),
        ),
        Provider<PreferencesRepository>(
          create: (_) => PreferencesRepositroyImpl(preferences, darkMode),
        ),
        Provider<PokemonRepository>(
          create: (_) => PokemonRepositoryImpl(PokemonApi(http, cache)),
        ),
        ChangeNotifierProvider<ThemeController>(
          create: (context) {
            final PreferencesRepository preferencesRepository = context.read();

            return ThemeController(
              preferencesRepository.darkMode,
              preferencesRepository,
            );
          },
        ),
      ],
      child: TranslationProvider(child: App()),
    );
  }
}
