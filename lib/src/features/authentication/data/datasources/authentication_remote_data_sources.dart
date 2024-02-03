import 'dart:convert';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/excetion.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/constants.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/typedefinitions.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> creatUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreatUserEndpoint = '/test-api/users';
const kGetUsersendpoint = '/test-api/users';

class AuthenticationRemoteDataSourceImp
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImp(this._client);

  final http.Client _client;

  @override
  Future<void> creatUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    //  1. check to make sure that it returns the right data when the status
    //  code is 200 or the proper response code
    //  2. check to make sure that it "THROWS A CUSTOM EXCEPTION" with the
    //  right message when status code is the bad one

    try {
      final response =
          await _client.post(Uri.https(kBasedUrl, kCreatUserEndpoint),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
                'avatar': avatar,
              }),
              headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await _client.get(Uri.https(kBasedUrl, kGetUsersendpoint));

      if (response.statusCode != 200) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userDater) => UserModel.fromMap(userDater))
          .toList();
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }
}
