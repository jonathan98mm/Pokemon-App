import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:pokemon_app/app/data/http/http.dart';
import 'package:pokemon_app/app/data/services/local/api_cache.dart';
import 'package:pokemon_app/app/data/services/utils/handle_request_failure.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';
import 'package:pokemon_app/app/domain/models/move/move.dart';
import 'package:pokemon_app/app/domain/models/paginated_response/paginated_response.dart';
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
        await _cache.savePokemon(json["id"], jsonEncode(json));

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
        left: handleHttpFailure,
        right: (pokemon) {
          pokemons.add(pokemon);
        },
      );
    }

    return Either.right(pokemons);
  }

  Future<Either<HttpRequestFailure, Pokemon>> getUndetailedPokemon(
    String url,
  ) async {
    final int id = url.getIdFromUrl();
    final String? pokemonJson = _cache.getPokemon(id);
    final Pokemon pokemon;

    if (pokemonJson != null) {
      pokemon = Pokemon.fromJson(jsonDecode(pokemonJson));

      return Future.value(Either.right(pokemon));
    } else {
      final result = await _http.request(
        url,
        useBaseUrl: false,
        onSuccess: (json) {
          _cache.savePokemon(id, jsonEncode(json));

          Pokemon pokemon = Pokemon.fromJson(json);

          return pokemon;
        },
      );

      return result.when(
        left: handleHttpFailure,
        right: (pokemon) => Either.right(pokemon),
      );
    }
  }

  Future<Either<HttpRequestFailure, Ability>> getAbility(String url) async {
    final int id = url.getIdFromUrl();
    final String? abilityJson = _cache.getAbility(id);

    if (abilityJson != null) {
      return Future.value(
        Either.right(Ability.fromJson(jsonDecode(abilityJson))),
      );
    }

    final result = await _http.request(
      useBaseUrl: false,
      url,
      onSuccess: (json) {
        _cache.saveAbility(id, jsonEncode(json));

        return Ability.fromJson(json);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (ability) => Either.right(ability),
    );
  }

  Future<Either<HttpRequestFailure, Move>> getMove(String url) async {
    final int id = url.getIdFromUrl();
    final String? moveJson = _cache.getMove(id);

    if (moveJson != null) {
      return Future.value(Either.right(Move.fromJson(jsonDecode(moveJson))));
    }

    final result = await _http.request(
      useBaseUrl: false,
      url,
      onSuccess: (json) {
        _cache.saveMove(id, jsonEncode(json));

        return Move.fromJson(json);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (move) => Either.right(move),
    );
  }

  Future<Either<HttpRequestFailure, Stat>> getStat(
    String url,
    int? value,
  ) async {
    final int id = url.getIdFromUrl();
    final String? statJson = _cache.getStat(id);

    if (statJson != null) {
      return Future.value(Either.right(Stat.fromJson(jsonDecode(statJson))));
    }

    final result = await _http.request(
      useBaseUrl: false,
      url,
      onSuccess: (json) {
        _cache.saveStat(id, jsonEncode(json));

        Stat stat = Stat.fromJson(json);

        return stat.copyWith(value: value ?? 0);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (stat) => Either.right(stat),
    );
  }

  Future<Either<HttpRequestFailure, PokemonType>> getType(String url) async {
    final int id = url.getIdFromUrl();
    final String? typeJson = _cache.getType(id);

    if (typeJson != null) {
      return Future.value(
        Either.right(PokemonType.fromJson(jsonDecode(typeJson))),
      );
    }

    final result = await _http.request(
      useBaseUrl: false,
      url,
      onSuccess: (json) {
        _cache.saveType(id, jsonEncode(json));

        return PokemonType.fromJson(json);
      },
    );

    return result.when(
      left: handleHttpFailure,
      right: (type) => Either.right(type),
    );
  }

  Future<Either<HttpRequestFailure, PaginatedResponse>> getPaginatedPokemons(
    int offset,
    int limit,
  ) async {
    bool hasNextPage = false;
    List<Json> results = [];
    List<Pokemon> pokemonDetails = [];

    final result = await _http.request(
      "pokemon",
      queryParameters: {"offset": offset.toString(), "limit": limit.toString()},
      onSuccess: (json) {
        hasNextPage = json["next"] != null;

        return List<Json>.from(json["results"]);
      },
    );

    result.when(
      left: handleHttpFailure,
      right: (list) {
        results = list;
      },
    );

    final List<Future<Either<HttpRequestFailure, Pokemon>>> detailsFutures =
        results.map((json) => getUndetailedPokemon(json["url"])).toList();

    final List<Either<HttpRequestFailure, Pokemon>> responseList =
        await Future.wait(detailsFutures);

    for (Either<HttpRequestFailure, Pokemon> response in responseList) {
      response.when(
        left: (failure) => Either.left(failure),
        right: (pokemon) {
          pokemonDetails.add(pokemon);
        },
      );
    }

    return Either.right(
      PaginatedResponse(hasNextPage: hasNextPage, pokemons: pokemonDetails),
    );
  }

  Future<Either<HttpRequestFailure, List<Ability>>> getAbilities(
    List<Json> rawAbilities,
  ) async {
    List<Ability> abilities = [];

    print("Numero de Habilidades Iniciales: ${rawAbilities.length}");

    final List<Future<Either<HttpRequestFailure, Ability>>> detailsFutures =
        rawAbilities.map((json) => getAbility(json["ability"]["url"])).toList();

    final List<Either<HttpRequestFailure, Ability>> responseList =
        await Future.wait(detailsFutures);

    for (Either<HttpRequestFailure, Ability> response in responseList) {
      response.when(
        left: (failure) => Either.left(failure),
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

    final List<Future<Either<HttpRequestFailure, Move>>> detailsFutures =
        rawMoves.map((json) => getMove(json["move"]["url"])).toList();

    final List<Either<HttpRequestFailure, Move>> responseList =
        await Future.wait(detailsFutures);

    for (Either<HttpRequestFailure, Move> response in responseList) {
      response.when(
        left: (failure) => Either.left(failure),
        right: (move) {
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

    final List<Future<Either<HttpRequestFailure, Stat>>> detailsFutures =
        rawStats
            .map((json) => getStat(json["stat"]["url"], json["base_stat"]))
            .toList();

    final List<Either<HttpRequestFailure, Stat>> responseList =
        await Future.wait(detailsFutures);

    for (Either<HttpRequestFailure, Stat> response in responseList) {
      response.when(
        left: (failure) => Either.left(failure),
        right: (stat) {
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

    final List<Future<Either<HttpRequestFailure, PokemonType>>> detailsFutures =
        rawTypes.map((json) => getType(json["type"]["url"])).toList();

    final List<Either<HttpRequestFailure, PokemonType>> responseList =
        await Future.wait(detailsFutures);

    for (Either<HttpRequestFailure, PokemonType> response in responseList) {
      response.when(
        left: (failure) => Either.left(failure),
        right: (type) {
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
