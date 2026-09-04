import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

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
}
