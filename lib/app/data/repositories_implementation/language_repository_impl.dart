import 'package:pokemon_app/app/data/services/local/language_service.dart';
import 'package:pokemon_app/app/domain/repositories/language_repository.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  LanguageRepositoryImpl(this._service);

  final LanguageService _service;

  @override
  void setLanguageCode(String code) {
    _service.setLanguageCode(code);
  }
}
