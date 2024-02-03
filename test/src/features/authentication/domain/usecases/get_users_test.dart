import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsers usecase;
  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsers(repository);
  });

  const tResponse = [User.empty()];

  test('shoud call the [AuthRepo.getUsers] and return [List<User>]', () async {
    //Arrange
    //STUB/ING
    when(
      () => repository.getUsers(),
    ).thenAnswer((_) async => const Right(tResponse));
    //Act
    final result = await usecase();
    expect(result, equals(const Right<dynamic, List<User>>(tResponse)));

    verify(
      () => repository.getUsers(),
    ).called(1);
    verifyNoMoreInteractions(repository);
    //Assert
  });
}
