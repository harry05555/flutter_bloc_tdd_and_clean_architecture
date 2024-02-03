import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/excetion.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/failure.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/datasources/authentication_remote_data_sources.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRemoteDataSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation
      authenticationRepositoryImplementation;

  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDataSource();
    authenticationRepositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );
  group('createUser', () {
    const createdAt = 'Whatever.createdAt';
    const name = 'Whatever.name';
    const avatar = 'Whatever.avatar';

    test(
        'should call the [RemoteDateSource.createUser] and complete successfully'
        'when the call to the remote', () async {
      //arrange
      when(
        () => remoteDataSource.creatUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar')),
      ).thenAnswer((_) async => Future.value());

      //act
      final result = await authenticationRepositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      //assert
      expect(result, equals(const Right(null)));
      verify(() => remoteDataSource.creatUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);
    });

    test(
      'should return a [APIFailure] when the call to the remote source is unsuccessful',
      () async {
        //Arrang
        when(() => remoteDataSource.creatUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'))).thenThrow(tException);
        //Act
        final result = await authenticationRepositoryImplementation.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );
        expect(
          result,
          equals(
            Left(
              APIFailure(
                message: tException.message,
                statusCode: tException.statusCode,
              ),
            ),
          ),
        );
        verify(() => remoteDataSource.creatUser(
            createdAt: createdAt, name: name, avatar: avatar)).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUsers', () {
    test(
        'should call [RemoteDateSource.getUsers] and return [List<Users>] when'
        'call to Remote Source is successful', () async {
      when(() => remoteDataSource.getUsers()).thenAnswer(
        (_) async => [],
      );
      final result = await authenticationRepositoryImplementation.getUsers();
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
    
    test('should return a [APIFailure] when the call to the remote source is unsuccessful', () async {
      when(() => remoteDataSource.getUsers()).thenThrow(tException);
      final result = await authenticationRepositoryImplementation.getUsers();
      expect(result, equals(Left(APIFailure.fromException(tException))));
      verify(() => remoteDataSource.getUsers());
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
