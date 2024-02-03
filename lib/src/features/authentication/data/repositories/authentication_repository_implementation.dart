import 'package:dartz/dartz.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/excetion.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/errors/failure.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/core/utils/typedefinitions.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/datasources/authentication_remote_data_sources.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/entities/user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDateSource);

  final AuthenticationRemoteDataSource _remoteDateSource;

  @override
  ResultVoid createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    // Test-Driven Development
    // call the remote data source
    // check if the method returns the proper data
    // make sure that it returns the proper data if there is no exception
    // // check if when the remoteDataSource throws an exception, we return a
    // failure    // Test-Driven Development
    //     // call the remote data source
    //     // check if the method returns the proper data
    //     // make sure that it returns the proper data if there is no exception
    //     // // check if when the remoteDataSource throws an exception, we return a
    //     // failure
    try {
      await _remoteDateSource.creatUser(
          createdAt: createdAt, name: name, avatar: avatar);
      return const Right(null);
    } on APIException catch (e) {
      return left(APIFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<User>> getUsers() async {
    try {
      final result = await _remoteDateSource.getUsers();
      return right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
