import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/typedefinitions.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  // Ist ein Vertrag

  const AuthenticationRepository();

  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar});

  ResultFuture<List<User>> getUsers();
}
