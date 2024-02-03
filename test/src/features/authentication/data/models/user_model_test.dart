import 'dart:convert';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/models/user_model.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  test('shoud be a subclass of [User] entity', () {
    //Assert
    expect(tModel, isA<User>());
  });

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson);

  group('formMap', () {
    test('should return [UserModel] with the right data', () {
      //Act
      final result = UserModel.fromMap(tMap);
      //Assert
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {
    test('should return [UserModel] with the right data', () {
      //Act
      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () {
    test('should return a [Map] with the right data', () {
      //Act
      final result = tModel.toMap();
      //Assert
      expect(result, equals(tMap));
    });
  });

  group('toJson', () {
    test('should return a [Json] string with the right data', () {
      //Act
      final result = tModel.toJson();
      //Assert
      final tJson = jsonEncode({
        "id": "1",
        "avatar": "_empty.string",
        "createdAt": "_empty.string",
        "name": "_empty.string",
      });
      expect(result, equals(tJson));
    });
  });

  group('copyWith', () {
    test('should return a [UserModel] with different data', () {
      //Act
      final result = tModel.copyWith(name: 'Paul');
      expect(result.name, equals('Paul'));
    });
  });
}
