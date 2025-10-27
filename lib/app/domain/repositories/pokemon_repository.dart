import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<HttpRequestFailure, Pokemon>> getPokemonById(int id);
  Future<Either<HttpRequestFailure, Pokemon>> getPokemonByName(String name);
  Future<Either<HttpRequestFailure, List<Pokemon>>> getRandomPokemons({
    int count,
  });
}
