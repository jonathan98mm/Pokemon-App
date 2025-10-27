import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pokemon_app/app/domain/repositories/language_repository.dart';
import 'package:pokemon_app/app/presentation/global/controllers/theme_controller.dart';
import 'package:pokemon_app/app/presentation/global/theme.dart';
import 'package:pokemon_app/app/presentation/modules/splash/views/splash_view.dart';
import 'package:pokemon_app/app/presentation/routes/router.dart';
import 'package:pokemon_app/generated/translations.g.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key, this.initialRoute, this.overrideRoutes});

  final String? initialRoute;
  final List<GoRoute>? overrideRoutes;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver, RouterMixin {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales?.isNotEmpty ?? false) {
      final Locale systemLocale = locales!.first;
      final LanguageRepository repository = context.read();

      repository.setLanguageCode(systemLocale.languageCode);
      Intl.defaultLocale = systemLocale.toLanguageTag();
      LocaleSettings.setLocaleRaw(systemLocale.languageCode);
    }
    super.didChangeLocales(locales);
  }

  @override
  void dispose() {
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = context.watch();

    if (loading) {
      return const SplashView();
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        theme: getTheme(themeController.darkMode),
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocaleUtils.supportedLocales,
        locale: TranslationProvider.of(context).flutterLocale,
      ),
    );
  }
}
