import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:pokemon_app/app/data/http/http.dart';
import 'package:pokemon_app/app/data/services/local/api_cache.dart';
import 'package:pokemon_app/app/data/services/utils/handle_request_failure.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';
import 'package:pokemon_app/app/domain/models/move/move.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/domain/models/stat/stat.dart';
import 'package:pokemon_app/app/domain/models/type/type.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';
import 'package:pokemon_app/app/presentation/global/extensions/string_extension.dart';

class PokemonApi {
  PokemonApi(this._http, this._cache);

  final Http _http;
  final ApiCache _cache;

  Future<Either<HttpRequestFailure, Pokemon>> getPokemonById(int id) async {
    Pokemon pokemon;
    final String? pokemonJson = _cache.getPokemon(id);

    if (pokemonJson != null) {
      Json json = jsonDecode(pokemonJson);

      pokemon = Pokemon.fromJson(json);

      final abilitiesResult = await getAbilities(
        List<Map<String, dynamic>>.from(json["abilities"]),
      );
      final movesResult = await getMoves(
        List<Map<String, dynamic>>.from(json["moves"]),
      );
      final statsResult = await getStats(
        List<Map<String, dynamic>>.from(json["stats"]),
      );
      final typesResult = await getTypes(
        List<Map<String, dynamic>>.from(json["types"]),
      );

      abilitiesResult.when(
        left: (failure) => failure,
        right: (abilities) {
          pokemon = pokemon.copyWith(abilities: abilities);
        },
      );

      movesResult.when(
        left: (failure) => failure,
        right: (moves) {
          pokemon = pokemon.copyWith(movements: moves);
        },
      );

      statsResult.when(
        left: (failure) => failure,
        right: (stats) {
          pokemon = pokemon.copyWith(stats: stats);
        },
      );

      typesResult.when(
        left: (failure) => failure,
        right: (types) {
          pokemon = pokemon.copyWith(types: types);
        },
      );

      return Future.value(Either.right(pokemon));
    } else {
      final result = await _http.request(
        "pokemon/$id",
        onSuccess: (json) async {
          await _cache.savePokemon(id, jsonEncode(json));

          pokemon = Pokemon.fromJson(json);

          final abilitiesResult = await getAbilities(
            List<Map<String, dynamic>>.from(json["abilities"]),
          );
          final movesResult = await getMoves(
            List<Map<String, dynamic>>.from(json["moves"]),
          );
          final statsResult = await getStats(
            List<Map<String, dynamic>>.from(json["stats"]),
          );
          final typesResult = await getTypes(
            List<Map<String, dynamic>>.from(json["types"]),
          );

          abilitiesResult.when(
            left: (failure) => failure,
            right: (abilities) {
              pokemon = pokemon.copyWith(abilities: abilities);
            },
          );

          movesResult.when(
            left: (failure) => failure,
            right: (moves) {
              pokemon = pokemon.copyWith(movements: moves);
            },
          );

          statsResult.when(
            left: (failure) => failure,
            right: (stats) {
              pokemon = pokemon.copyWith(stats: stats);
            },
          );

          typesResult.when(
            left: (failure) => failure,
            right: (types) {
              pokemon = pokemon.copyWith(types: types);
            },
          );

          //print(pokemon);

          return pokemon;
        },
      );

      return result.when(
        left: handleHttpFailure,
        right: (pokemon) async => Either.right(await pokemon),
      );
    }
  }

  Future<Either<HttpRequestFailure, Pokemon>> getPokemonByName(
    String name,
  ) async {
    final result = await _http.request(
      "pokemon/${_getFilteredName(name)}",
      onSuccess: (json) async {
        await _cache.savePokemon(int.parse(json["id"]), jsonEncode(json));

        Pokemon pokemon = Pokemon.fromJson(json);

        final abilitiesResult = await getAbilities(
          List<Map<String, dynamic>>.from(json["abilities"]),
        );
        final movesResult = await getMoves(
          List<Map<String, dynamic>>.from(json["moves"]),
        );
        final statsResult = await getStats(
          List<Map<String, dynamic>>.from(json["stats"]),
        );
        final typesResult = await getTypes(
          List<Map<String, dynamic>>.from(json["types"]),
        );

        abilitiesResult.when(
          left: (failure) => failure,
          right: (abilities) {
            pokemon = pokemon.copyWith(abilities: abilities);
          },
        );

        movesResult.when(
          left: (failure) => failure,
          right: (moves) {
            pokemon = pokemon.copyWith(movements: moves);
          },
        );

        statsResult.when(
          left: (failure) => failure,
          right: (stats) {
            pokemon = pokemon.copyWith(stats: stats);
          },
        );

        typesResult.when(
          left: (failure) => failure,
          right: (types) {
            pokemon = pokemon.copyWith(types: types);
          },
        );

        return pokemon;
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (pokemon) async => Either.right(await pokemon),
    );
  }

  Future<Either<HttpRequestFailure, List<Pokemon>>> getRandomPokemons(
    int count,
  ) async {
    List<Pokemon> pokemons = [];
    List<int> ids = faker.randomGenerator.numbers(1025, count);

    for (int i = 0; i < count; i++) {
      final String? pokemonJson = _cache.getPokemon(ids[i]);

      if (pokemonJson != null) {
        pokemons.add(Pokemon.fromJson(jsonDecode(pokemonJson)));

        continue;
      }

      final result = await _http.request(
        "pokemon/${ids[i]}",
        onSuccess: (json) {
          _cache.savePokemon(ids[i], jsonEncode(json));

          Pokemon pokemon = Pokemon.fromJson(json);

          return pokemon;
        },
      );

      result.when(
        left: (failure) {
          print(failure.data);
        },
        right: (pokemon) {
          pokemons.add(pokemon);
        },
      );
    }

    return Either.right(pokemons);
  }

  Future<Either<HttpRequestFailure, List<Ability>>> getAbilities(
    List<Json> rawAbilities,
  ) async {
    List<Ability> abilities = [];

    print("Numero de Habilidades Iniciales: ${rawAbilities.length}");

    for (Json item in rawAbilities) {
      final String path = item["ability"]["url"];
      final int id = path.getIdFromUrl();
      final String? abilityJson = _cache.getAbility(id);

      if (abilityJson != null) {
        abilities.add(Ability.fromJson(jsonDecode(abilityJson)));

        continue;
      }

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          _cache.saveAbility(id, jsonEncode(json));

          return Ability.fromJson(json);
        },
      );

      result.when(
        left: (failure) {
          print("Fallo en Habilidades: ${failure.exception}");
        },
        right: (ability) {
          abilities.add(ability);
        },
      );
    }

    print("Numero de Habilidades Finales: ${abilities.length}");

    return Either.right(abilities);
  }

  Future<Either<HttpRequestFailure, List<Move>>> getMoves(
    List<Json> rawMoves,
  ) async {
    List<Move> moves = [];

    print("Número de Movimientos Iniciales: ${rawMoves.length}");

    for (Json item in rawMoves) {
      final String path = item["move"]["url"];
      final int id = path.getIdFromUrl();
      final String? moveJson = _cache.getMove(id);

      if (moveJson != null) {
        moves.add(Move.fromJson(jsonDecode(moveJson)));

        continue;
      }

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          _cache.saveMove(id, jsonEncode(json));

          return Move.fromJson(json);
        },
      );

      result.when(
        left: (failure) => print("Fallo en Movimientos: ${failure.exception}"),
        right: (move) async {
          moves.add(move);
        },
      );
    }

    print("Número de Movimientos Finales: ${moves.length} ");

    return Either.right(moves);
  }

  Future<Either<HttpRequestFailure, List<Stat>>> getStats(
    List<Json> rawStats,
  ) async {
    List<Stat> stats = [];

    print("Número de Estadísticas Iniciales: ${rawStats.length}");

    for (Json item in rawStats) {
      final String path = item["stat"]["url"];
      final int id = path.getIdFromUrl();
      final String? statJson = _cache.getStat(id);

      if (statJson != null) {
        stats.add(Stat.fromJson(jsonDecode(statJson)));

        continue;
      }

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          _cache.saveStat(id, jsonEncode(json));

          return Stat.fromJson(json);
        },
      );

      result.when(
        left: (failure) => print("Fallo en Estadisticas: ${failure.exception}"),
        right: (stat) async {
          stats.add(stat);
        },
      );
    }

    print("Número de Estadísticas Finales: ${stats.length}");

    return Either.right(stats);
  }

  Future<Either<HttpRequestFailure, List<PokemonType>>> getTypes(
    List<Json> rawTypes,
  ) async {
    List<PokemonType> types = [];

    print("Número de Tipos Iniciales: ${rawTypes.length}");

    for (Json item in rawTypes) {
      final String path = item["type"]["url"];
      final int id = path.getIdFromUrl();
      final String? typeJson = _cache.getType(id);

      if (typeJson != null) {
        types.add(PokemonType.fromJson(jsonDecode(typeJson)));

        continue;
      }

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          _cache.saveType(id, jsonEncode(json));

          return PokemonType.fromJson(json);
        },
      );

      result.when(
        left: (failure) => print("Fallo en Tipos: ${failure.exception}"),
        right: (type) async {
          types.add(type);
        },
      );
    }

    print("Número de Tipos Finales: ${types.length}");

    return Either.right(types);
  }
}

String _getFilteredName(String name) {
  return name.toLowerCase().replaceAll(" ", "-").replaceAll(".", "");
}
