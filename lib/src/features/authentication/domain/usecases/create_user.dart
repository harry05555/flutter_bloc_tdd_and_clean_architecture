import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/usecase/usecase.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/typedefinitions.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';

class CreateUser extends UseCaseWithParams<void, CreateUseCaseParams> {
  final AuthenticationRepository _repository;

  const CreateUser(this._repository);

  @override
  ResultVoid call(CreateUseCaseParams params) async => _repository.createUser(
        createdAt: params.createdAt,
        name: params.name,
        avatar: params.avatar,
      );
}

class CreateUseCaseParams extends Equatable {
  final String createdAt;
  final String name;
  final String avatar;

  const CreateUseCaseParams(
      {required this.createdAt, required this.name, required this.avatar});

  const CreateUseCaseParams.empty()
      : this(
            createdAt: '_empty.string',
            name: '_empty.string',
            avatar: '_empty.string');

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
