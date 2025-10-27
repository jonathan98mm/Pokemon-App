import 'package:pokemon_app/app/data/services/remote/pokemon_api.dart';
import 'package:pokemon_app/app/domain/either/either.dart';
import 'package:pokemon_app/app/domain/failures/http_request_failure/http_request_failure.dart';
import 'package:pokemon_app/app/domain/models/pokemon/pokemon.dart';
import 'package:pokemon_app/app/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this._pokemonApi);

  final PokemonApi _pokemonApi;

  @override
  Future<Either<HttpRequestFailure, Pokemon>> getPokemonById(int id) {
    return _pokemonApi.getPokemonById(id);
  }

  @override
  Future<Either<HttpRequestFailure, Pokemon>> getPokemonByName(String name) {
    return _pokemonApi.getPokemonByName(name);
  }

  @override
  Future<Either<HttpRequestFailure, List<Pokemon>>> getRandomPokemons({
    int count = 1,
  }) async {
    return _pokemonApi.getRandomPokemons(count);
  }
}
