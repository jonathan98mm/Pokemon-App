import 'package:faker/faker.dart';
import 'package:pokemon_app/app/data/http/http.dart';
import 'package:pokemon_app/app/data/services/utils/handle_request_failure.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/ability/ability.dart';
import 'package:pokemon_app/app/domain/models/move/move.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/domain/models/stat/stat.dart';
import 'package:pokemon_app/app/domain/models/type/type.dart';
import 'package:pokemon_app/app/domain/typedefs.dart';

class PokemonApi {
  PokemonApi(this._http);

  final Http _http;

  Future<Either<HttpRequestFailure, Pokemon>> getPokemonById(int id) async {
    final result = await _http.request(
      "pokemon/$id",
      onSuccess: (json) async {
        final Pokemon pokemon = Pokemon.fromJson(json);

        final abilitiesResult = await getAbilities(json["abilities"]);
        final movesResult = await getMoves(json["moves"]);
        final statsResult = await getStats(json["stats"]);
        final typesResult = await getTypes(json["type"]);

        abilitiesResult.when(
          left: (failure) => failure,
          right: (abilities) {
            pokemon.abilities.addAll(abilities);
          },
        );

        movesResult.when(
          left: (failure) => failure,
          right: (moves) {
            pokemon.movements.addAll(moves);
          },
        );

        statsResult.when(
          left: (failure) => failure,
          right: (stats) {
            pokemon.stats.addAll(stats);
          },
        );

        typesResult.when(
          left: (failure) => failure,
          right: (types) {
            pokemon.types.addAll(types);
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

  Future<Either<HttpRequestFailure, Pokemon>> getPokemonByName(
    String name,
  ) async {
    final result = await _http.request(
      "pokemon/${_getFilteredName(name)}",
      onSuccess: (json) async {
        final Pokemon pokemon = Pokemon.fromJson(json);

        final abilitiesResult = await getAbilities(json["abilities"]);
        final movesResult = await getMoves(json["moves"]);
        final statsResult = await getStats(json["stats"]);
        final typesResult = await getTypes(json["type"]);

        abilitiesResult.when(
          left: (failure) => failure,
          right: (abilities) {
            pokemon.abilities.addAll(abilities);
          },
        );

        movesResult.when(
          left: (failure) => failure,
          right: (moves) {
            pokemon.movements.addAll(moves);
          },
        );

        statsResult.when(
          left: (failure) => failure,
          right: (stats) {
            pokemon.stats.addAll(stats);
          },
        );

        typesResult.when(
          left: (failure) => failure,
          right: (types) {
            pokemon.types.addAll(types);
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
      final result = await _http.request(
        "pokemon/${ids[i]}",
        onSuccess: (json) {
          Pokemon pokemon = Pokemon.fromJson(json);

          /*final abilitiesResult = await getAbilities(
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
          );*/

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

    print("Pokemones: $pokemons");

    return Either.right(pokemons);
  }

  Future<Either<HttpRequestFailure, List<Ability>>> getAbilities(
    List<Json> rawAbilities,
  ) async {
    List<Ability> abilities = [];

    for (Json item in rawAbilities) {
      final String path = item["ability"]["url"];

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          return Ability.fromJson(json);
        },
      );

      result.when(
        left: (failure) {
          print(failure.exception);
        },
        right: (ability) {
          abilities.add(ability);
        },
      );
    }

    return Either.right(abilities);
  }

  Future<Either<HttpRequestFailure, List<Move>>> getMoves(
    List<Json> rawMoves,
  ) async {
    List<Move> moves = [];

    for (Json item in rawMoves) {
      final String path = item["move"]["url"];

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          return Move.fromJson(json);
        },
      );

      result.when(
        left: handleHttpFailure,
        right: (move) async {
          moves.add(move);
        },
      );
    }

    return Either.right(moves);
  }

  Future<Either<HttpRequestFailure, List<Stat>>> getStats(
    List<Json> rawStats,
  ) async {
    List<Stat> stats = [];

    for (Json item in rawStats) {
      final String path = item["stat"]["url"];

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          return Stat.fromJson(json);
        },
      );

      result.when(
        left: handleHttpFailure,
        right: (stat) async {
          stats.add(stat);
        },
      );
    }

    return Either.right(stats);
  }

  Future<Either<HttpRequestFailure, List<PokemonType>>> getTypes(
    List<Json> rawTypes,
  ) async {
    List<PokemonType> types = [];

    for (Json item in rawTypes) {
      final String path = item["type"]["url"];

      final result = await _http.request(
        useBaseUrl: false,
        path,
        onSuccess: (json) {
          return PokemonType.fromJson(json);
        },
      );

      result.when(
        left: handleHttpFailure,
        right: (type) async {
          types.add(type);
        },
      );
    }

    return Either.right(types);
  }
}

String _getFilteredName(String name) {
  return name.toLowerCase().replaceAll(" ", "-").replaceAll(".", "");
}
