import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/get_users.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUser createUser,
    required GetUsers getUsers,
  })  : _createUser = createUser,
        _getUsers = getUsers,
        super(const AuthenticationInitial());

  final CreateUser _createUser;
  final GetUsers _getUsers;

  Future<void> crateUser(
      {required String createdAt,
      required String avatar,
      required String name}) async {
    emit(const CreatingUser());
    final result = await _createUser(CreateUseCaseParams(
      createdAt: createdAt,
      name: name,
      avatar: avatar,
    ));

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (_) => emit(const UserCreated()),
    );
  }

  Future<void> getUser() async {
    emit(const GettingUsers());
    final result = await _getUsers();

    result.fold(
      (failure) => emit(AuthenticationError(failure.errorMessage)),
      (users) => emit(UsersLoaded(users)),
    );
  }
}
