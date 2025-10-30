import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pokemon_app/app/app.dart';
import 'package:pokemon_app/app/domain/repositories/connectivity_repository.dart';
import 'package:pokemon_app/app/presentation/modules/home/views/home_view.dart';
import 'package:pokemon_app/app/presentation/modules/offline/views/offline_view.dart';
import 'package:pokemon_app/app/presentation/modules/pokemon/views/pokemon_view.dart';
import 'package:pokemon_app/app/presentation/routes/routes.dart';
import 'package:provider/provider.dart';

mixin RouterMixin on State<App> {
  GoRouter? _router;
  late String _initialRouteName;
  bool _loading = true;

  bool get loading => _loading;

  GoRouter get router {
    if (_router != null) {
      return _router!;
    }

    final List<GoRoute> routes = [
      GoRoute(
        name: Routes.home,
        path: "/",
        builder: (_, __) => const HomeView(),
      ),
      GoRoute(
        name: Routes.pokemon,
        path: "/pokemon/:param",
        builder: (_, state) {
          final String param = state.pathParameters["param"]!;
          final int? id = int.tryParse(param);

          if (id != null) {
            return PokemonView(pokemonId: id);
          } else {
            return PokemonView(pokemonName: param);
          }
        },
      ),
      GoRoute(
        name: Routes.offline,
        path: "/offline",
        builder: (_, __) => const OfflineView(),
      ),
    ];

    final List<GoRoute>? overrideRoutes = widget.overrideRoutes;

    if (overrideRoutes?.isNotEmpty ?? false) {
      final List<String> names = overrideRoutes!.map((e) => e.name!).toList();

      routes.removeWhere((el) {
        if (el.name != null) {
          return names.contains(el.name);
        }

        return false;
      });

      routes.addAll(overrideRoutes);
    }

    final String initialLocation = routes
        .firstWhere(
          (route) => route.name == _initialRouteName,
          orElse: () => routes.first,
        )
        .path;

    _router = GoRouter(initialLocation: initialLocation, routes: routes);

    return _router!;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    _initialRouteName =
        widget.initialRoute ?? await getInitialRouteName(context);

    setState(() {
      _loading = false;
    });
  }
}

Future<String> getInitialRouteName(BuildContext context) async {
  final ConnectivityRepository connectivityRepository = context.read();

  final bool hasInternet = connectivityRepository.hasInternet;

  if (!hasInternet) return Routes.offline;

  return Routes.home;
}
