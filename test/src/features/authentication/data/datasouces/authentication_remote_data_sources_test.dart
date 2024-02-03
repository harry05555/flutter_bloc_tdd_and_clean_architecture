import 'dart:convert';

import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/excetion.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/constants.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/datasources/authentication_remote_data_sources.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImp(client);
    registerFallbackValue(Uri());
  });

  group('CreateUser', () {
    test(
      'should complete successfully when status code is 200 or 201',
      () async {
        when(() => client.post(any(),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('User create successfully', 201),
        );
        final methodCall = remoteDataSource.creatUser;
        expect(
            methodCall(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            completes);

        verify(
          () => client.post(
            Uri.https(kBasedUrl, kCreatUserEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw [APIException] when the status code is not 200 or 201',
      () async {
        when(() => client.post(any(),
            headers: {'Content-Type': 'application/json'},
            body: any(named: 'body'))).thenAnswer(
          (_) async => http.Response('Invalid email address', 400),
        );

        final methodCall = remoteDataSource.creatUser;

        expect(
          () async => methodCall(
            createdAt: 'createdAt',
            name: 'name',
            avatar: 'avatar',
          ),
          throwsA(
            const APIException(
              message: 'Invalid email address',
              statusCode: 400,
            ),
          ),
        );

        verify(
          () => client.post(
            Uri.https(kBasedUrl, kCreatUserEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'createdAt': 'createdAt',
              'name': 'name',
              'avatar': 'avatar',
            }),
          ),
        ).called(1);
        verifyNoMoreInteractions(client);
      },
    );
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test(
      'should return [list<User>] when the response 200',
      () async {
        when(() => client.get(any())).thenAnswer((_) async =>
            http.Response(jsonEncode([tUsers.first.toMap()]), 200));

        final result = await remoteDataSource.getUsers();

        expect(result, equals(tUsers));

        verify(() => client.get(Uri.https(kBasedUrl, kGetUsersendpoint)))
            .called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test('should throw [APIException] wen the status code is not 200',
        () async {
      const tMessage =
          'Server down, server down, I repeat Serve down, Mayday Mayday Mayday,'
          ' We are going down';
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(tMessage, 500),
      );

      final methodCall = remoteDataSource.getUsers();

      expect(
        () => methodCall,
        throwsA(
          const APIException(message: tMessage, statusCode: 500),
        ),
      );

      verify(() => client.get(Uri.https(kBasedUrl, kGetUsersendpoint)))
          .called(1);

      verifyNoMoreInteractions(client);
    });
  });
}
