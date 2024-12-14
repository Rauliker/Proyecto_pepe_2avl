import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_raul/data/datasources/provincias_datasource.dart';
import 'package:proyecto_raul/data/datasources/user_datasource.dart';
import 'package:proyecto_raul/data/repositories/prov_repository_impl.dart';
import 'package:proyecto_raul/data/repositories/user_repository_impl.dart';
import 'package:proyecto_raul/domain/repositories/prov_repository.dart';
import 'package:proyecto_raul/domain/repositories/user_repisitory.dart';
import 'package:proyecto_raul/domain/usercase/prov_usercase.dart';
import 'package:proyecto_raul/domain/usercase/user_usecase.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/users/users_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;
Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<ProvRemoteDataSource>(
      () => ProvRemoteDataSourceImpl(sl()));

  sl.registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(sl()));

  // Repositories
  sl.registerLazySingleton<ProvRepository>(
      () => ProvRepositoryImpl(remoteDataSource: sl()));

  sl.registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(remoteDataSource: sl()));

  // Use Cases
  sl.registerLazySingleton(() => CaseProvInfo(sl()));

  sl.registerLazySingleton(() => CaseUser(sl()));
  sl.registerLazySingleton(() => CaseUserInfo(sl()));
  sl.registerLazySingleton(() => CreateUser(sl()));

  // Blocs
  sl.registerFactory(() => ProvBloc(sl()));
  sl.registerFactory(() => UserBloc(sl(), sl(), sl()));

  // External
  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
