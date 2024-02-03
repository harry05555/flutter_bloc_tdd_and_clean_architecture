import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/datasources/authentication_remote_data_sources.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/create_user.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/domain/usecases/get_users.dart';
import 'package:flutter_bloc_tdd_and_clean_architecture/src/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final servicelocatorSL = GetIt.instance;
// final sl = GetIt.instance; das gleibe wie Zeile 5

Future<void> init() async {
  // servicelocatorSL.registerFactory(() => AuthenticationCubit(
  //       createUser: servicelocatorSL(),
  //       getUsers: servicelocatorSL(),
  //     ));
  // servicelocatorSL.registerLazySingleton(CreateUser(servicelocatorSL()));
  // servicelocatorSL.registerLazySingleton(GetUsers(servicelocatorSL()));

  // Oder das ist das gleiche wie ab Zeile 8. zeile 18 benutzt ein cascade operator"..".
  servicelocatorSL
    // App Logic
    ..registerFactory(() => AuthenticationCubit(
          createUser: servicelocatorSL(),
          getUsers: servicelocatorSL(),
        ))
    // ..registerFactory(() => AuthenticationBloc(
    //       createUser: servicelocatorSL(),
    //       getUsers: servicelocatorSL(),
    //     ))

    // Use cases
    ..registerLazySingleton(() => CreateUser(servicelocatorSL()))
    ..registerLazySingleton(() => GetUsers(servicelocatorSL()))

    //Repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(servicelocatorSL()))

    //Data Sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImp(servicelocatorSL()))

    //External Dependencies
    ..registerLazySingleton(() => http.Client());
}
