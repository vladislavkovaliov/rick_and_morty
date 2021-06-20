import 'dart:convert';

import 'package:rick_and_morty/core/error/exception.dart';
import 'package:rick_and_morty/feature/data/models/person_model.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDateSource {
  /// Call the https://rickandmortyapi.com/api/character/?page=1 endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PersonModel>> getAllPersons(int page);

  /// Call the https://rickandmortyapi.com/api/character/?name=rick endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<PersonModel>> searchPerson(String query);
}

class PersonRemoteDateSourceImpl implements PersonRemoteDateSource {
  final http.Client client;

  PersonRemoteDateSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPersons(int page) async {
    return _getPersonFromUrl(
        'https://rickandmortyapi.com/api/character/?page=$page');
  }

  @override
  Future<List<PersonModel>> searchPerson(String query) async {
    return _getPersonFromUrl(
        'https://rickandmortyapi.com/api/character/?name=$query');
  }

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    final response = await client.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
