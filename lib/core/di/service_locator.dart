import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/work_orders/data/datasources/work_orders_remote_data_source.dart';
import '../../features/work_orders/data/repositories/work_orders_repository_impl.dart';
import '../../features/work_orders/domain/repositories/work_orders_repository.dart';
import '../../features/work_orders/presentation/bloc/work_orders_bloc.dart';
import '../database/db_helper.dart';
import '../database/tables/database_table.dart';
import '../database/tables/inspections_table.dart';
import '../network/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(resetOnError: true),
    ),
  );

  // Database
  List<DatabaseTable> tables = [InspectionsTable()];
  sl.registerLazySingleton<DbHelper>(() => DbHelper(tables: tables));

  // Network
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(storage: sl<FlutterSecureStorage>()),
  );

  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().client);

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<WorkOrdersRemoteDataSource>(
    () => WorkOrdersRemoteDataSourceImpl(dio: sl<Dio>()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(storage: sl<FlutterSecureStorage>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<WorkOrdersRepository>(
    () => WorkOrdersRepositoryImpl(
      remoteDataSource: sl<WorkOrdersRemoteDataSource>(),
    ),
  );

  // BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl<AuthRepository>()),
  );

  sl.registerFactory<WorkOrdersBloc>(
    () => WorkOrdersBloc(repository: sl<WorkOrdersRepository>()),
  );
}
