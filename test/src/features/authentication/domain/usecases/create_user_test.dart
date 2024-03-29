// What dose the class depend on?
//Answer -- AuthenticationRepository
// How can we create a fake version of the dependency?
//Answer -- Use Mocktail
// How do we control what our dependencies do?
//Answer -- Using the Mocktail's API

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'authentication_repository.mock.dart';

void main() {
  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUser(repository);
  });
  const params = CreateUseCaseParams.empty();

  test(
    'should call the [AuthRepo.createUser]',
    () async {
      //Arrange
      //STUB/ING
      when(
        () => repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        ),
      ).thenAnswer((_) async => const Right(null));
      //Act
      final result = await usecase(params);
      //Assert
      expect(result, equals(const Right(null)));
      verify(() => repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar)).called(1);
      verifyNoMoreInteractions(repository);
    },
  );
}
