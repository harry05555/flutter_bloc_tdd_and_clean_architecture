import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/failure.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUsers extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUseCaseParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUsers();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial stat should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, UserCreated] when successful',
        build: () {
          when(() => createUser(any())).thenAnswer(
            (_) async => const Right(null),
          );
          return cubit;
        },
        act: (cubit) => cubit.crateUser(
              createdAt: tCreateUserParams.createdAt,
              avatar: tCreateUserParams.avatar,
              name: tCreateUserParams.name,
            ),
        expect: () => const [
              CreatingUser(),
              UserCreated(),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
        'should emit [CreatingUser, AuthenticationError] when successful when unsuccessful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Left(tAPIFailure));
          return cubit;
        },
        act: (cubit) => cubit.crateUser(
              createdAt: tCreateUserParams.createdAt,
              avatar: tCreateUserParams.avatar,
              name: tCreateUserParams.name,
            ),
        expect: () => [
              const CreatingUser(),
              AuthenticationError(tAPIFailure.errorMessage),
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded when successful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, Authentication] when unsuccessful',
      build: () {
        when(() => getUsers()).thenAnswer((_) async => const Left(tAPIFailure));
        return cubit;
      },
      act: (cubit) => cubit.getUser(),
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (_) {
        verify(() => getUsers()).called(1);
        verifyNoMoreInteractions(getUsers);
      },
    );
  });
}
