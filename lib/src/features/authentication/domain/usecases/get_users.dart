import 'package:flutter_bloc_tdd_and_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/typedefinitions.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';

class GetUsers extends UseCaseWithoutParams<List<User>> {
  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}
